import '../models/settlement.dart';

extension SettlementExtension on Settlement {
  bool involvesUser(String userId) {
    return fromUserId == userId || toUserId == userId;
  }

  String getMethodDisplayName() {
    switch (method) {
      case SettlementMethod.cash:
        return 'Cash';
      case SettlementMethod.bankTransfer:
        return 'Bank Transfer';
      case SettlementMethod.upi:
        return 'UPI';
      case SettlementMethod.other:
        return 'Other';
    }
  }
}
