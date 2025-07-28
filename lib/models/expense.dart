import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class ExpenseSplit with _$ExpenseSplit {
  const factory ExpenseSplit({
    required String userId,
    required double amount,
    @Default(false) bool isPaid,
  }) = _ExpenseSplit;

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) =>
      _$ExpenseSplitFromJson(json);
}

enum SplitType { equal, exact, percentage }

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    required String description,
    required double amount,
    required String currency,
    required String categoryId,
    required String paidById,
    required List<ExpenseSplit> splits,
    required SplitType splitType,
    required DateTime date,
    String? groupId,
    String? notes,
    String? receiptImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}
