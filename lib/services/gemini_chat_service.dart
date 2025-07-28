import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:async';
import '../models/chat_message.dart' as chat_models;
import '../models/expense.dart';
import '../models/expense_category.dart';

class GeminiChatService {
  static const String _apiKey = 'AIzaSyCEZ9Ci-38Ew-qf-Iep8QNr2B7pvXHkFUE';
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  GeminiChatService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 32,
        topP: 0.8,
        maxOutputTokens: 1000,
      ),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
  }

  /// Initialize chat session with context about Kharcha app
  Future<void> initializeChatSession({
    List<Expense>? userExpenses,
    List<ExpenseCategory>? categories,
    Map<String, double>? categorySpending,
    double? monthlyTotal,
    double? netBalance,
  }) async {
    final contextPrompt = _buildContextPrompt(
      userExpenses: userExpenses,
      categories: categories,
      categorySpending: categorySpending,
      monthlyTotal: monthlyTotal,
      netBalance: netBalance,
    );

    _chatSession = _model.startChat(history: [
      Content.text(contextPrompt),
      Content.model([
        TextPart(
            'Hello! I\'m Kharcha AI, your personal finance assistant. I can help you with:\n\n'
            '💰 **Expense Analysis**: Understand your spending patterns\n'
            '📊 **Budget Planning**: Get personalized budget recommendations\n'
            '💡 **Financial Tips**: Learn money-saving strategies\n'
            '📈 **Insights**: Discover trends in your expenses\n'
            '❓ **App Help**: Learn how to use Kharcha features\n\n'
            'What would you like to know about your finances today?')
      ]),
    ]);
  }

  /// Send message and get response from Gemini
  Future<String> sendMessage(String message) async {
    try {
      final content = Content.text(message);
      final response = await _chatSession.sendMessage(content);
      return response.text ??
          'I apologize, but I couldn\'t process your message. Please try again.';
    } on GenerativeAIException catch (e) {
      return _handleGeminiError(e);
    } catch (e) {
      return 'I\'m experiencing technical difficulties. Please check your connection and try again.';
    }
  }

  /// Build context prompt with user's financial data
  String _buildContextPrompt({
    List<Expense>? userExpenses,
    List<ExpenseCategory>? categories,
    Map<String, double>? categorySpending,
    double? monthlyTotal,
    double? netBalance,
  }) {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    String context = '''
You are Kharcha AI, an intelligent financial assistant for the Kharcha expense tracking app. Your role is to help users understand their finances, provide insights, and answer questions about their spending.

CURRENT USER: MOHNISH
CURRENT DATE: ${now.toString().split(' ')[0]}
CURRENT MONTH: $currentMonth

APP CONTEXT:
Kharcha is a smart expense tracking app with these features:
- Add and categorize expenses
- Split expenses with friends
- AI-powered expense categorization 
- Budget recommendations based on spending patterns
- Real-time balance tracking
- Visual spending insights and charts

USER'S FINANCIAL DATA:
''';

    if (monthlyTotal != null) {
      context += '- Monthly Total Spent: ₹${monthlyTotal.toStringAsFixed(0)}\n';
    }

    if (netBalance != null) {
      if (netBalance >= 0) {
        context +=
            '- Net Balance: You are owed ₹${netBalance.toStringAsFixed(0)}\n';
      } else {
        context +=
            '- Net Balance: You owe ₹${netBalance.abs().toStringAsFixed(0)}\n';
      }
    }

    if (categorySpending != null && categorySpending.isNotEmpty) {
      context += '\nCATEGORY-WISE SPENDING THIS MONTH:\n';
      for (var entry in categorySpending.entries) {
        final categoryName = categories
                ?.firstWhere(
                  (cat) => cat.id == entry.key,
                  orElse: () => ExpenseCategory(
                      id: entry.key,
                      name: entry.key,
                      iconName: '',
                      colorIndex: 0),
                )
                .name ??
            entry.key;
        context += '- $categoryName: ₹${entry.value.toStringAsFixed(0)}\n';
      }
    }

    if (userExpenses != null && userExpenses.isNotEmpty) {
      context += '\nRECENT EXPENSES (Last 5):\n';
      userExpenses.take(5).forEach((expense) {
        final categoryName = categories
                ?.firstWhere(
                  (cat) => cat.id == expense.categoryId,
                  orElse: () => ExpenseCategory(
                      id: expense.categoryId,
                      name: expense.categoryId,
                      iconName: '',
                      colorIndex: 0),
                )
                .name ??
            expense.categoryId;
        context +=
            '- ${expense.description} ($categoryName): ₹${expense.amount.toStringAsFixed(0)} on ${expense.date.toString().split(' ')[0]}\n';
      });
    }

    context += '''

INSTRUCTIONS:
1. Be conversational, helpful, and personalized to MOHNISH
2. Use the financial data provided to give specific insights
3. Suggest actionable financial advice based on spending patterns
4. Help with Kharcha app features and functionality
5. Use emojis appropriately to make conversations engaging
6. Keep responses concise but informative (under 200 words typically)
7. Always use Indian Rupees (₹) for currency
8. If asked about features not in the data, explain Kharcha's capabilities
9. Encourage good financial habits and smart spending
10. Be supportive and positive while being realistic about finances

RESPONSE STYLE:
- Start with a friendly greeting for the first message
- Use bullet points for lists
- Include relevant emojis
- Provide specific numbers from the user's data when relevant
- End with a helpful question or suggestion when appropriate

Remember: You have access to MOHNISH's actual expense data, so provide personalized insights rather than generic advice.
''';

    return context;
  }

  /// Handle Gemini API errors gracefully
  String _handleGeminiError(GenerativeAIException error) {
    final errorMessage = error.message.toLowerCase();

    if (errorMessage.contains('quota') || errorMessage.contains('limit')) {
      return '⚠️ I\'m experiencing high usage right now. Please try again in a few minutes.';
    } else if (errorMessage.contains('server') ||
        errorMessage.contains('internal')) {
      return '🔧 I\'m having technical issues. Please try again shortly.';
    } else if (errorMessage.contains('api key') ||
        errorMessage.contains('authentication')) {
      return '🔑 There\'s an authentication issue. Please contact support.';
    } else if (errorMessage.contains('safety') ||
        errorMessage.contains('blocked')) {
      return '🛡️ I can\'t respond to that type of request. Let\'s talk about your finances instead!';
    } else if (errorMessage.contains('unsupported')) {
      return '❌ That request isn\'t supported. Try asking about your expenses or budget planning.';
    } else {
      return '😅 Something went wrong: ${error.message}. Could you rephrase your question?';
    }
  }

  /// Get predefined quick response suggestions
  List<String> getQuickResponses() {
    return [
      '📊 Show my spending summary',
      '💡 Give me budget tips',
      '🎯 How can I save more?',
      '📈 Analyze my trends',
      '❓ How do I add expenses?',
      '🏷️ Explain categories',
    ];
  }

  /// Get contextual responses based on user's financial state
  List<String> getContextualSuggestions({
    double? monthlyTotal,
    Map<String, double>? categorySpending,
    int? daysLeftInMonth,
  }) {
    List<String> suggestions = [];

    if (monthlyTotal != null && monthlyTotal > 0) {
      if (daysLeftInMonth != null && daysLeftInMonth > 0) {
        final dailyAverage = monthlyTotal / (30 - daysLeftInMonth);
        final projectedSpending = dailyAverage * 30;

        if (projectedSpending > monthlyTotal * 1.2) {
          suggestions.add('🚨 Your spending is trending high this month');
        }
      }
    }

    if (categorySpending != null && categorySpending.isNotEmpty) {
      final topCategory = categorySpending.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      suggestions.add('💰 Most spent on ${topCategory.key}');

      if (categorySpending.length > 3) {
        suggestions.add('📊 Review all category spending');
      }
    }

    if (suggestions.isEmpty) {
      suggestions.addAll([
        '🎯 Set monthly budgets',
        '📱 Learn app features',
        '💡 Get saving tips',
      ]);
    }

    return suggestions.take(3).toList();
  }

  /// Clean up resources
  void dispose() {
    // Clean up any resources if needed
  }
}

/// Gemini API configuration
class GeminiConfig {
  static const String defaultModel = 'gemini-1.5-flash';
  static const double defaultTemperature = 0.7;
  static const int defaultMaxTokens = 1000;

  // API key is now configured
  static const String apiKeyPlaceholder = 'YOUR_GEMINI_API_KEY_HERE';

  static const String helpMessage = '''
🔑 **Setup Required**

To use the AI chat feature, you need to:

1. Get a free API key from Google AI Studio
2. Replace 'YOUR_GEMINI_API_KEY_HERE' in the code
3. Restart the app

Visit: https://makersuite.google.com/app/apikey
''';
}
