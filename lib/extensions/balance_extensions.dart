import '../models/balance.dart';

extension BalanceExtension on Balance {
  bool involvesUser(String userId) {
    return fromUserId == userId || toUserId == userId;
  }

  double amountForUser(String userId) {
    if (fromUserId == userId) return -amount; // User owes money
    if (toUserId == userId) return amount; // User is owed money
    return 0;
  }

  String getOtherUserId(String currentUserId) {
    return fromUserId == currentUserId ? toUserId : fromUserId;
  }

  bool get isSettled => amount == 0;
}
