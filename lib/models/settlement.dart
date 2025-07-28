import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';
part 'settlement.g.dart';

enum SettlementMethod { cash, bankTransfer, upi, other }

@freezed
class Settlement with _$Settlement {
  const factory Settlement({
    required String id,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    required SettlementMethod method,
    required DateTime date,
    String? groupId,
    String? notes,
    String? transactionReference,
    DateTime? createdAt,
  }) = _Settlement;

  factory Settlement.fromJson(Map<String, dynamic> json) =>
      _$SettlementFromJson(json);
}
