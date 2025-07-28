import '../models/expense.dart';

extension ExpenseExtension on Expense {
  double get totalSplitAmount =>
      splits.fold(0, (sum, split) => sum + split.amount);

  List<String> get participantIds =>
      splits.map((split) => split.userId).toList();

  double amountOwedBy(String userId) {
    final split = splits.firstWhere(
      (split) => split.userId == userId,
      orElse: () => const ExpenseSplit(userId: '', amount: 0),
    );
    return split.amount;
  }

  double amountOwedTo(String userId) {
    if (paidById != userId) return 0;
    return amount - amountOwedBy(userId);
  }

  bool get isSettled => splits.every((split) => split.isPaid);

  bool involvesUser(String userId) {
    return paidById == userId || participantIds.contains(userId);
  }
}
