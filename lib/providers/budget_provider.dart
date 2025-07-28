import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Budget models and services are defined inline for simplicity
import '../providers/expense_provider.dart';
import '../providers/user_provider.dart';

// Simple budget model since we can't use freezed right now
class SimpleBudget {
  final String id;
  final String categoryId;
  final double monthlyLimit;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  SimpleBudget({
    required this.id,
    required this.categoryId,
    required this.monthlyLimit,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'monthlyLimit': monthlyLimit,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'isActive': isActive,
      };

  factory SimpleBudget.fromJson(Map<String, dynamic> json) => SimpleBudget(
        id: json['id'],
        categoryId: json['categoryId'],
        monthlyLimit: json['monthlyLimit'].toDouble(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        isActive: json['isActive'] ?? true,
      );
}

class SimpleBudgetRecommendation {
  final String categoryId;
  final double averageSpending;
  final double recommendedBudget;
  final double confidenceScore;
  final int monthsOfData;
  final List<double> monthlySpending;

  SimpleBudgetRecommendation({
    required this.categoryId,
    required this.averageSpending,
    required this.recommendedBudget,
    required this.confidenceScore,
    required this.monthsOfData,
    required this.monthlySpending,
  });
}

class SimpleBudgetProgress {
  final String categoryId;
  final double budgetLimit;
  final double currentSpending;
  final double remainingBudget;
  final double progressPercentage;
  final int daysLeftInMonth;
  final BudgetStatus status;

  SimpleBudgetProgress({
    required this.categoryId,
    required this.budgetLimit,
    required this.currentSpending,
    required this.remainingBudget,
    required this.progressPercentage,
    required this.daysLeftInMonth,
    required this.status,
  });

  bool get isOnTrack =>
      status == BudgetStatus.safe || status == BudgetStatus.warning;
  bool get isOverBudget => status == BudgetStatus.exceeded;

  String get statusMessage {
    switch (status) {
      case BudgetStatus.safe:
        return 'On track';
      case BudgetStatus.warning:
        return 'Watch spending';
      case BudgetStatus.danger:
        return 'Almost over budget';
      case BudgetStatus.exceeded:
        return 'Over budget';
    }
  }
}

enum BudgetStatus {
  safe, // < 70% of budget used
  warning, // 70-90% of budget used
  danger, // 90-100% of budget used
  exceeded, // > 100% of budget used
}

// Budget storage provider
final budgetStorageProvider = Provider<BudgetStorage>((ref) {
  return BudgetStorage();
});

class BudgetStorage {
  static const String _budgetsKey = 'user_budgets';

  Future<List<SimpleBudget>> getBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetsJson = prefs.getString(_budgetsKey);

    if (budgetsJson == null) return [];

    final List<dynamic> budgetsList = json.decode(budgetsJson);
    return budgetsList.map((json) => SimpleBudget.fromJson(json)).toList();
  }

  Future<void> saveBudgets(List<SimpleBudget> budgets) async {
    final prefs = await SharedPreferences.getInstance();
    final budgetsJson = json.encode(budgets.map((b) => b.toJson()).toList());
    await prefs.setString(_budgetsKey, budgetsJson);
  }

  Future<void> addBudget(SimpleBudget budget) async {
    final budgets = await getBudgets();
    budgets.add(budget);
    await saveBudgets(budgets);
  }

  Future<void> updateBudget(SimpleBudget updatedBudget) async {
    final budgets = await getBudgets();
    final index = budgets.indexWhere((b) => b.id == updatedBudget.id);
    if (index != -1) {
      budgets[index] = updatedBudget;
      await saveBudgets(budgets);
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    final budgets = await getBudgets();
    budgets.removeWhere((b) => b.id == budgetId);
    await saveBudgets(budgets);
  }
}

// Active budgets provider
final budgetsProvider = FutureProvider<List<SimpleBudget>>((ref) async {
  final storage = ref.read(budgetStorageProvider);
  return await storage.getBudgets();
});

// Budget recommendations provider
final budgetRecommendationsProvider =
    Provider<List<SimpleBudgetRecommendation>>((ref) {
  final expenses = ref.watch(expensesProvider);
  final categories = ref.watch(categoriesProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return [];

  return _generateSimpleBudgetRecommendations(
      expenses, categories, currentUser.id);
});

// Budget progress provider
final budgetProgressProvider =
    FutureProvider<List<SimpleBudgetProgress>>((ref) async {
  final budgetsAsync = await ref.watch(budgetsProvider.future);
  final expenses = ref.watch(expensesProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser == null) return [];

  return _calculateSimpleBudgetProgress(budgetsAsync, expenses, currentUser.id);
});

// Add budget provider
final addBudgetProvider = Provider<Future<void> Function(SimpleBudget)>((ref) {
  return (SimpleBudget budget) async {
    final storage = ref.read(budgetStorageProvider);
    await storage.addBudget(budget);
    ref.invalidate(budgetsProvider);
    ref.invalidate(budgetProgressProvider);
  };
});

// Accept budget recommendations provider
final acceptBudgetRecommendationsProvider =
    Provider<Future<void> Function(List<SimpleBudgetRecommendation>)>((ref) {
  return (List<SimpleBudgetRecommendation> recommendations) async {
    final storage = ref.read(budgetStorageProvider);
    final budgets = recommendations
        .map((rec) => SimpleBudget(
              id: 'budget_${rec.categoryId}_${DateTime.now().millisecondsSinceEpoch}',
              categoryId: rec.categoryId,
              monthlyLimit: rec.recommendedBudget,
              createdAt: DateTime.now(),
            ))
        .toList();

    for (final budget in budgets) {
      await storage.addBudget(budget);
    }

    ref.invalidate(budgetsProvider);
    ref.invalidate(budgetProgressProvider);
  };
});

// Helper functions
List<SimpleBudgetRecommendation> _generateSimpleBudgetRecommendations(
  List<dynamic> expenses,
  List<dynamic> categories,
  String userId,
) {
  final now = DateTime.now();
  final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);

  // Filter expenses for the last 3 months
  final recentExpenses = expenses.where((expense) {
    return expense.date.isAfter(threeMonthsAgo) && expense.involvesUser(userId);
  }).toList();

  if (recentExpenses.isEmpty) return [];

  final recommendations = <SimpleBudgetRecommendation>[];

  for (final category in categories) {
    final categoryExpenses = recentExpenses
        .where((expense) => expense.categoryId == category.id)
        .toList();

    if (categoryExpenses.isEmpty) continue;

    // Calculate monthly spending for the last 3 months
    final monthlySpending = _calculateMonthlySpending(categoryExpenses, userId);

    if (monthlySpending.isEmpty) continue;

    // Calculate average spending
    final averageSpending =
        monthlySpending.reduce((a, b) => a + b) / monthlySpending.length;

    // Recommend 90% of average spending for savings
    final recommendedBudget = averageSpending * 0.9;

    // Calculate confidence score based on spending consistency
    final confidenceScore =
        _calculateConfidenceScore(monthlySpending, averageSpending);

    recommendations.add(SimpleBudgetRecommendation(
      categoryId: category.id,
      averageSpending: averageSpending,
      recommendedBudget: recommendedBudget,
      confidenceScore: confidenceScore,
      monthsOfData: monthlySpending.length,
      monthlySpending: monthlySpending,
    ));
  }

  // Sort by recommended budget amount (descending)
  recommendations
      .sort((a, b) => b.recommendedBudget.compareTo(a.recommendedBudget));

  return recommendations;
}

List<double> _calculateMonthlySpending(List<dynamic> expenses, String userId) {
  final now = DateTime.now();
  final monthlySpending = <int, double>{};

  for (final expense in expenses) {
    final monthKey = expense.date.year * 12 + expense.date.month;
    final userAmount = expense.paidById == userId
        ? expense.amount
        : expense.amountOwedBy(userId);

    monthlySpending[monthKey] = (monthlySpending[monthKey] ?? 0) + userAmount;
  }

  // Get spending for last 3 months
  final spending = <double>[];
  for (int i = 2; i >= 0; i--) {
    final targetDate = DateTime(now.year, now.month - i, 1);
    final monthKey = targetDate.year * 12 + targetDate.month;
    spending.add(monthlySpending[monthKey] ?? 0);
  }

  return spending.where((amount) => amount > 0).toList();
}

double _calculateConfidenceScore(
    List<double> monthlySpending, double averageSpending) {
  if (monthlySpending.length < 2) return 50.0;

  final variance = monthlySpending
          .map((amount) =>
              (amount - averageSpending) * (amount - averageSpending))
          .reduce((a, b) => a + b) /
      monthlySpending.length;

  final standardDeviation = variance < 0 ? 0.0 : variance;
  final coefficientOfVariation =
      averageSpending == 0 ? 0.0 : standardDeviation / averageSpending;

  final confidenceScore = (1 - coefficientOfVariation.clamp(0.0, 1.0)) * 100;
  return confidenceScore.clamp(0.0, 100.0);
}

List<SimpleBudgetProgress> _calculateSimpleBudgetProgress(
  List<SimpleBudget> budgets,
  List<dynamic> expenses,
  String userId,
) {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  final daysLeftInMonth = daysInMonth - now.day;

  // Filter current month expenses
  final currentMonthExpenses = expenses
      .where((expense) =>
          expense.date.isAfter(startOfMonth) && expense.involvesUser(userId))
      .toList();

  final progressList = <SimpleBudgetProgress>[];

  for (final budget in budgets.where((b) => b.isActive)) {
    final categoryExpenses = currentMonthExpenses
        .where((expense) => expense.categoryId == budget.categoryId)
        .toList();

    final currentSpending = categoryExpenses.fold(0.0, (total, expense) {
      return total +
          (expense.paidById == userId
              ? expense.amount
              : expense.amountOwedBy(userId));
    });

    final remainingBudget = (budget.monthlyLimit - currentSpending)
        .clamp(0.0, double.infinity)
        .toDouble();
    final progressPercentage = budget.monthlyLimit == 0
        ? 0.0
        : (currentSpending / budget.monthlyLimit * 100)
            .clamp(0.0, double.infinity)
            .toDouble();

    final status = _determineBudgetStatus(progressPercentage);

    progressList.add(SimpleBudgetProgress(
      categoryId: budget.categoryId,
      budgetLimit: budget.monthlyLimit,
      currentSpending: currentSpending,
      remainingBudget: remainingBudget,
      progressPercentage: progressPercentage,
      daysLeftInMonth: daysLeftInMonth,
      status: status,
    ));
  }

  return progressList;
}

BudgetStatus _determineBudgetStatus(double progressPercentage) {
  if (progressPercentage >= 100) {
    return BudgetStatus.exceeded;
  } else if (progressPercentage >= 90) {
    return BudgetStatus.danger;
  } else if (progressPercentage >= 70) {
    return BudgetStatus.warning;
  } else {
    return BudgetStatus.safe;
  }
}
