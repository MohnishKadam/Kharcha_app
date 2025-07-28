/// AI-powered expense categorization service
/// Uses keyword matching to automatically categorize expenses
class AiCategorizationService {
  // Keyword mappings for each category
  static const Map<String, List<String>> _categoryKeywords = {
    'food': [
      'restaurant',
      'dinner',
      'lunch',
      'breakfast',
      'meal',
      'eating',
      'zomato',
      'swiggy',
      'dominos',
      'pizza',
      'burger',
      'biryani',
      'food',
      'snack',
      'grocery',
      'vegetables',
      'fruits',
      'meat',
      'chicken',
      'mutton',
      'fish',
      'rice',
      'dal',
      'bread',
      'milk',
      'eggs',
      'cheese',
      'yogurt',
      'cake',
      'ice cream',
      'sweet',
      'dessert',
      'hotel',
      'buffet',
      'canteen',
      'dhaba',
      'street food',
      'chaat',
      'samosa',
      'dosa',
      'idli',
      'vada'
    ],
    'coffee': [
      'coffee',
      'tea',
      'chai',
      'latte',
      'cappuccino',
      'espresso',
      'starbucks',
      'cafe coffee day',
      'ccd',
      'barista',
      'cafe',
      'mocha',
      'frappe',
      'smoothie',
      'juice',
      'shake',
      'lassi'
    ],
    'transportation': [
      'uber',
      'ola',
      'taxi',
      'auto',
      'rickshaw',
      'bus',
      'metro',
      'train',
      'flight',
      'petrol',
      'diesel',
      'fuel',
      'gas',
      'parking',
      'toll',
      'transport',
      'cab',
      'ride',
      'travel',
      'rapido',
      'bike',
      'car',
      'vehicle',
      'maintenance',
      'service'
    ],
    'shopping': [
      'amazon',
      'flipkart',
      'myntra',
      'ajio',
      'nykaa',
      'shopping',
      'clothes',
      'shirt',
      'pants',
      'jeans',
      'dress',
      'shoes',
      'bag',
      'purse',
      'wallet',
      'watch',
      'jewelry',
      'cosmetics',
      'makeup',
      'skincare',
      'perfume',
      'electronics',
      'mobile',
      'laptop',
      'headphones',
      'book',
      'furniture',
      'appliance'
    ],
    'entertainment': [
      'movie',
      'cinema',
      'pvr',
      'inox',
      'theatre',
      'netflix',
      'amazon prime',
      'hotstar',
      'spotify',
      'youtube premium',
      'game',
      'gaming',
      'concert',
      'show',
      'event',
      'party',
      'club',
      'bar',
      'pub',
      'bowling',
      'pool',
      'sports',
      'subscription',
      'streaming',
      'music',
      'video'
    ],
    'housing': [
      'rent',
      'emi',
      'mortgage',
      'house',
      'apartment',
      'flat',
      'deposit',
      'maintenance',
      'society',
      'home',
      'property',
      'landlord',
      'tenant',
      'lease',
      'broker',
      'brokerage'
    ],
    'utilities': [
      'electricity',
      'electric',
      'power',
      'water',
      'gas',
      'lpg',
      'wifi',
      'internet',
      'broadband',
      'airtel',
      'jio',
      'vi',
      'recharge',
      'mobile bill',
      'phone bill',
      'postpaid',
      'prepaid',
      'data',
      'plan',
      'cable',
      'dth',
      'tata sky'
    ],
    'healthcare': [
      'doctor',
      'hospital',
      'clinic',
      'medicine',
      'pharmacy',
      'medical',
      'health',
      'appointment',
      'checkup',
      'treatment',
      'surgery',
      'dental',
      'dentist',
      'eye',
      'test',
      'lab',
      'x-ray',
      'scan',
      'insurance',
      'mediclaim',
      'ambulance'
    ],
    'education': [
      'school',
      'college',
      'university',
      'course',
      'class',
      'tuition',
      'coaching',
      'book',
      'notebook',
      'stationery',
      'exam',
      'fee',
      'admission',
      'education',
      'learning',
      'online course',
      'udemy',
      'coursera',
      'skill',
      'training'
    ],
    'travel': [
      'hotel',
      'resort',
      'accommodation',
      'booking',
      'trip',
      'vacation',
      'holiday',
      'tour',
      'package',
      'sightseeing',
      'visa',
      'passport',
      'luggage',
      'backpack',
      'travel insurance',
      'makemytrip',
      'goibibo',
      'cleartrip',
      'yatra',
      'airbnb'
    ],
    'gifts': [
      'gift',
      'present',
      'birthday',
      'anniversary',
      'wedding',
      'festival',
      'celebration',
      'surprise',
      'flower',
      'flowers',
      'card',
      'greeting',
      'chocolate',
      'hamper',
      'voucher'
    ],
    'investment': [
      'mutual fund',
      'sip',
      'stock',
      'share',
      'investment',
      'fd',
      'fixed deposit',
      'rd',
      'recurring deposit',
      'ppf',
      'nps',
      'insurance',
      'premium',
      'portfolio',
      'zerodha',
      'groww',
      'upstox',
      'paytm money',
      'kuvera'
    ],
  };

  /// Analyzes the expense description and returns the most likely category ID
  /// Returns 'shopping' as default if no category can be determined
  static String categorizeExpense(String description, {String? notes}) {
    // Combine description and notes for analysis
    final text = '${description.toLowerCase()} ${notes?.toLowerCase() ?? ''}';

    // Track category scores
    final Map<String, int> categoryScores = {};

    // Initialize scores
    for (final categoryId in _categoryKeywords.keys) {
      categoryScores[categoryId] = 0;
    }

    // Score each category based on keyword matches
    for (final entry in _categoryKeywords.entries) {
      final categoryId = entry.key;
      final keywords = entry.value;

      for (final keyword in keywords) {
        if (text.contains(keyword.toLowerCase())) {
          categoryScores[categoryId] = categoryScores[categoryId]! + 1;

          // Give extra weight for exact word matches
          final words = text.split(' ');
          if (words.contains(keyword.toLowerCase())) {
            categoryScores[categoryId] = categoryScores[categoryId]! + 2;
          }
        }
      }
    }

    // Find the category with highest score
    String bestCategory = 'shopping'; // default fallback
    int maxScore = 0;

    categoryScores.forEach((categoryId, score) {
      if (score > maxScore) {
        maxScore = score;
        bestCategory = categoryId;
      }
    });

    return bestCategory;
  }

  /// Returns a confidence score (0-100) for the categorization
  static int getConfidenceScore(String description, String categoryId,
      {String? notes}) {
    final text = '${description.toLowerCase()} ${notes?.toLowerCase() ?? ''}';
    final keywords = _categoryKeywords[categoryId] ?? [];

    int matches = 0;
    int totalKeywords = keywords.length;

    for (final keyword in keywords) {
      if (text.contains(keyword.toLowerCase())) {
        matches++;
      }
    }

    // Calculate confidence based on keyword density
    if (totalKeywords == 0) return 0;

    final baseConfidence = (matches / totalKeywords * 100).round();

    // Boost confidence for strong matches
    if (matches >= 2) return (baseConfidence * 1.5).clamp(0, 100).round();
    if (matches == 1) return (baseConfidence * 1.2).clamp(0, 100).round();

    return baseConfidence;
  }

  /// Returns suggested categories with confidence scores
  static List<MapEntry<String, int>> getSuggestedCategories(
    String description, {
    String? notes,
    int maxSuggestions = 3,
  }) {
    final suggestions = <MapEntry<String, int>>[];

    for (final categoryId in _categoryKeywords.keys) {
      final confidence =
          getConfidenceScore(description, categoryId, notes: notes);
      if (confidence > 0) {
        suggestions.add(MapEntry(categoryId, confidence));
      }
    }

    // Sort by confidence score in descending order
    suggestions.sort((a, b) => b.value.compareTo(a.value));

    return suggestions.take(maxSuggestions).toList();
  }

  /// Adds a custom keyword to a category (for learning purposes)
  static void addCustomKeyword(String categoryId, String keyword) {
    if (_categoryKeywords.containsKey(categoryId)) {
      _categoryKeywords[categoryId]!.add(keyword.toLowerCase());
    }
  }

  /// Gets all keywords for a specific category
  static List<String> getKeywordsForCategory(String categoryId) {
    return _categoryKeywords[categoryId] ?? [];
  }
}
