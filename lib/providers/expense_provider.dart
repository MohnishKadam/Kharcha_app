import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../extensions/expense_extensions.dart';
import '../services/ai_categorization_service.dart';
import 'user_provider.dart';

// Categories provider
final categoriesProvider = StateProvider<List<ExpenseCategory>>((ref) {
  return DefaultCategories.categories;
});

// Expenses provider with mock data
final expensesProvider = StateProvider<List<Expense>>((ref) {
  return [
    Expense(
      id: 'exp_1',
      description: 'Dinner at Italian Restaurant',
      amount: 2400.0,
      currency: 'INR',
      categoryId: 'food',
      paidById: 'user_1',
      splits: const [
        ExpenseSplit(userId: 'user_1', amount: 800.0),
        ExpenseSplit(userId: 'user_2', amount: 800.0),
        ExpenseSplit(userId: 'user_3', amount: 800.0),
      ],
      splitType: SplitType.equal,
      date: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Great pasta and wine!',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: 'exp_2',
      description: 'Uber to Airport',
      amount: 450.0,
      currency: 'INR',
      categoryId: 'transportation',
      paidById: 'user_2',
      splits: const [
        ExpenseSplit(userId: 'user_1', amount: 225.0),
        ExpenseSplit(userId: 'user_2', amount: 225.0),
      ],
      splitType: SplitType.equal,
      date: DateTime.now().subtract(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Expense(
      id: 'exp_3',
      description: 'Coffee and Breakfast',
      amount: 320.0,
      currency: 'INR',
      categoryId: 'coffee',
      paidById: 'user_3',
      splits: const [
        ExpenseSplit(userId: 'user_1', amount: 160.0),
        ExpenseSplit(userId: 'user_3', amount: 160.0),
      ],
      splitType: SplitType.equal,
      date: DateTime.now().subtract(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    Expense(
      id: 'exp_4',
      description: 'Movie Tickets',
      amount: 600.0,
      currency: 'INR',
      categoryId: 'entertainment',
      paidById: 'user_1',
      splits: const [
        ExpenseSplit(userId: 'user_1', amount: 150.0),
        ExpenseSplit(userId: 'user_2', amount: 150.0),
        ExpenseSplit(userId: 'user_3', amount: 150.0),
        ExpenseSplit(userId: 'user_4', amount: 150.0),
      ],
      splitType: SplitType.equal,
      date: DateTime.now().subtract(const Duration(days: 5)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
});

// Get category by ID
final categoryByIdProvider =
    Provider.family<ExpenseCategory?, String>((ref, categoryId) {
  final categories = ref.watch(categoriesProvider);
  try {
    return categories.firstWhere((category) => category.id == categoryId);
  } catch (e) {
    return null;
  }
});

// User's expenses (where user is involved)
final userExpensesProvider = Provider<List<Expense>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final expenses = ref.watch(expensesProvider);

  if (currentUser == null) return [];

  return expenses
      .where((expense) => expense.involvesUser(currentUser.id))
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

// Recent expenses (last 7 days)
final recentExpensesProvider = Provider<List<Expense>>((ref) {
  final userExpenses = ref.watch(userExpensesProvider);
  final weekAgo = DateTime.now().subtract(const Duration(days: 7));

  return userExpenses
      .where((expense) => expense.date.isAfter(weekAgo))
      .toList();
});

// Monthly expenses
final monthlyExpensesProvider = Provider<List<Expense>>((ref) {
  final userExpenses = ref.watch(userExpensesProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  return userExpenses
      .where((expense) => expense.date.isAfter(startOfMonth))
      .toList();
});

// Total spent this month by current user
final monthlyTotalProvider = Provider<double>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final monthlyExpenses = ref.watch(monthlyExpensesProvider);

  if (currentUser == null) return 0.0;

  return monthlyExpenses.fold(0.0, (total, expense) {
    if (expense.paidById == currentUser.id) {
      return total + expense.amount;
    }
    return total + expense.amountOwedBy(currentUser.id);
  });
});

// Category-wise spending this month
final categorySpendingProvider = Provider<Map<String, double>>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final monthlyExpenses = ref.watch(monthlyExpensesProvider);

  if (currentUser == null) return {};

  final categorySpending = <String, double>{};

  for (final expense in monthlyExpenses) {
    final amount = expense.paidById == currentUser.id
        ? expense.amount
        : expense.amountOwedBy(currentUser.id);

    categorySpending[expense.categoryId] =
        (categorySpending[expense.categoryId] ?? 0) + amount;
  }

  return categorySpending;
});

// Add expense method
final addExpenseProvider = Provider<void Function(Expense)>((ref) {
  return (Expense expense) {
    final expenses = ref.read(expensesProvider.notifier);
    expenses.update((state) => [...state, expense]);
  };
});

// Smart add expense method with AI categorization
final addExpenseWithAiProvider = Provider<void Function(ExpenseInput)>((ref) {
  return (ExpenseInput input) {
    // Use AI to categorize the expense
    final suggestedCategoryId = AiCategorizationService.categorizeExpense(
      input.description,
      notes: input.notes,
    );

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final expense = Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      description: input.description,
      amount: input.amount,
      currency: 'INR',
      categoryId: suggestedCategoryId,
      paidById: currentUser.id,
      splits: input.splits,
      splitType: input.splitType,
      date: input.date ?? DateTime.now(),
      notes: input.notes,
      createdAt: DateTime.now(),
    );

    final expenses = ref.read(expensesProvider.notifier);
    expenses.update((state) => [...state, expense]);
  };
});

/// Enhanced expense input for AI categorization
class ExpenseInput {
  final String description;
  final double amount;
  final List<ExpenseSplit> splits;
  final SplitType splitType;
  final String? notes;
  final DateTime? date;
  final String? groupId;

  const ExpenseInput({
    required this.description,
    required this.amount,
    required this.splits,
    required this.splitType,
    this.notes,
    this.date,
    this.groupId,
  });
}
