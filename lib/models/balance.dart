import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance.freezed.dart';
part 'balance.g.dart';

@freezed
class Balance with _$Balance {
  const factory Balance({
    required String id,
    required String fromUserId,
    required String toUserId,
    required double amount,
    required String currency,
    String? groupId,
    DateTime? lastUpdated,
  }) = _Balance;

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);
}
