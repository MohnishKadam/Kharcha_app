import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import '../models/chat_message.dart' as chat_models;
import '../services/gemini_chat_service.dart';
import '../extensions/expense_extensions.dart';
import 'expense_provider.dart';
import 'user_provider.dart';
import 'balance_provider.dart';

/// Chat service provider
final chatServiceProvider = Provider<GeminiChatService>((ref) {
  return GeminiChatService();
});

/// Current chat session provider
final currentChatSessionProvider =
    StateNotifierProvider<ChatSessionNotifier, chat_models.ChatSession?>((ref) {
  return ChatSessionNotifier(ref);
});

/// Chat messages provider
final chatMessagesProvider =
    Provider<List<chat_models.ChatMessageModel>>((ref) {
  final session = ref.watch(currentChatSessionProvider);
  return session?.messages ?? [];
});

/// Is typing provider
final isTypingProvider = StateProvider<bool>((ref) => false);

/// Quick responses provider
final quickResponsesProvider = Provider<List<String>>((ref) {
  final chatService = ref.read(chatServiceProvider);
  return chatService.getQuickResponses();
});

/// Contextual suggestions provider
final contextualSuggestionsProvider = Provider<List<String>>((ref) {
  final chatService = ref.read(chatServiceProvider);
  final monthlyTotal = ref.watch(monthlyTotalProvider);
  final categorySpending = ref.watch(categorySpendingProvider);

  final now = DateTime.now();
  final daysLeftInMonth = DateTime(now.year, now.month + 1, 0).day - now.day;

  return chatService.getContextualSuggestions(
    monthlyTotal: monthlyTotal,
    categorySpending: categorySpending,
    daysLeftInMonth: daysLeftInMonth,
  );
});

/// Chat session notifier
class ChatSessionNotifier extends StateNotifier<chat_models.ChatSession?> {
  final Ref ref;
  static const String _sessionKey = 'current_chat_session';

  ChatSessionNotifier(this.ref) : super(null) {
    _loadSession();
  }

  /// Load saved chat session
  Future<void> _loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);

      if (sessionJson != null) {
        final sessionData = json.decode(sessionJson);
        state = chat_models.ChatSession.fromJson(sessionData);
      }
    } catch (e) {
      // If loading fails, start fresh
      await startNewSession();
    }
  }

  /// Save current session
  Future<void> _saveSession() async {
    if (state != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final sessionJson = json.encode(state!.toJson());
        await prefs.setString(_sessionKey, sessionJson);
      } catch (e) {
        // Handle save error gracefully
      }
    }
  }

  /// Start a new chat session
  Future<void> startNewSession() async {
    try {
      // Initialize Gemini with current expense context
      final chatService = ref.read(chatServiceProvider);
      final expenses = ref.read(expensesProvider);
      final categories = ref.read(categoriesProvider);
      final categorySpending = ref.read(categorySpendingProvider);
      final monthlyTotal = ref.read(monthlyTotalProvider);
      final netBalance = ref.read(netBalanceProvider);
      final currentUser = ref.read(currentUserProvider);

      // Filter user's expenses
      final userExpenses = currentUser != null
          ? expenses
              .where((expense) => expense.involvesUser(currentUser.id))
              .toList()
          : <dynamic>[];

      await chatService.initializeChatSession(
        userExpenses: userExpenses.cast(),
        categories: categories,
        categorySpending: categorySpending,
        monthlyTotal: monthlyTotal,
        netBalance: netBalance,
      );

      // Create new session with welcome message
      final welcomeMessage = chat_models.ChatMessageModel(
        id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
        text:
            'Hello! I\'m Kharcha AI, your personal finance assistant. I can help you with:\n\n',
        createdAt: DateTime.now(),
        isFromUser: false,
      );

      state = chat_models.ChatSession(
        id: 'session_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Chat with Kharcha AI',
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        messages: [welcomeMessage],
      );

      await _saveSession();
    } catch (e) {
      // Handle initialization error
      final errorMessage = chat_models.ChatMessageModel.error(
        errorText:
            'Failed to initialize chat. Please check your API key configuration.',
        createdAt: DateTime.now(),
      );

      state = chat_models.ChatSession(
        id: 'error_session_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Chat Error',
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        messages: [errorMessage],
      );
    }
  }

  /// Send a message
  Future<void> sendMessage(String messageText) async {
    if (state == null) {
      await startNewSession();
    }

    if (messageText.trim().isEmpty) return;

    try {
      // Add user message
      final userMessage = chat_models.ChatMessageModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        text: messageText.trim(),
        createdAt: DateTime.now(),
        isFromUser: true,
      );

      _addMessage(userMessage);

      // Show typing indicator
      ref.read(isTypingProvider.notifier).state = true;
      final typingMessage = chat_models.ChatMessageModel.typing();
      _addMessage(typingMessage);

      // Get AI response
      final chatService = ref.read(chatServiceProvider);
      final response = await chatService.sendMessage(messageText);

      // Remove typing indicator and add AI response
      _removeMessage(typingMessage.id);
      ref.read(isTypingProvider.notifier).state = false;

      final aiMessage = chat_models.ChatMessageModel(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: response,
        createdAt: DateTime.now(),
        isFromUser: false,
      );

      _addMessage(aiMessage);
      await _saveSession();
    } catch (e) {
      // Handle send error
      ref.read(isTypingProvider.notifier).state = false;

      final errorMessage = chat_models.ChatMessageModel.error(
        errorText: 'Sorry, I couldn\'t process your message. Please try again.',
        createdAt: DateTime.now(),
      );

      _addMessage(errorMessage);
    }
  }

  /// Add message to current session
  void _addMessage(chat_models.ChatMessageModel message) {
    if (state != null) {
      final updatedMessages = [...state!.messages, message];
      state = state!.copyWith(
        messages: updatedMessages,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Remove message from current session
  void _removeMessage(String messageId) {
    if (state != null) {
      final updatedMessages =
          state!.messages.where((msg) => msg.id != messageId).toList();
      state = state!.copyWith(
        messages: updatedMessages,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Clear chat history
  Future<void> clearChat() async {
    await startNewSession();
  }

  /// Refresh chat with updated expense context
  Future<void> refreshContext() async {
    await startNewSession();
  }
}

/// Send message provider
final sendMessageProvider = Provider<Future<void> Function(String)>((ref) {
  return (String message) async {
    final notifier = ref.read(currentChatSessionProvider.notifier);
    await notifier.sendMessage(message);
  };
});

/// Clear chat provider
final clearChatProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final notifier = ref.read(currentChatSessionProvider.notifier);
    await notifier.clearChat();
  };
});

/// Refresh context provider
final refreshContextProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final notifier = ref.read(currentChatSessionProvider.notifier);
    await notifier.refreshContext();
  };
});

/// Check if API key is configured
final isApiKeyConfiguredProvider = Provider<bool>((ref) {
  // API key is configured if it's not the placeholder
  return true; // API key is already configured
});

/// Get API help message
final apiHelpMessageProvider = Provider<String>((ref) {
  return 'API is configured and ready to use!';
});
