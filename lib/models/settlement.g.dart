// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettlementImpl _$$SettlementImplFromJson(Map<String, dynamic> json) =>
    _$SettlementImpl(
      id: json['id'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      method: $enumDecode(_$SettlementMethodEnumMap, json['method']),
      date: DateTime.parse(json['date'] as String),
      groupId: json['groupId'] as String?,
      notes: json['notes'] as String?,
      transactionReference: json['transactionReference'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SettlementImplToJson(_$SettlementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'amount': instance.amount,
      'currency': instance.currency,
      'method': _$SettlementMethodEnumMap[instance.method]!,
      'date': instance.date.toIso8601String(),
      'groupId': instance.groupId,
      'notes': instance.notes,
      'transactionReference': instance.transactionReference,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$SettlementMethodEnumMap = {
  SettlementMethod.cash: 'cash',
  SettlementMethod.bankTransfer: 'bankTransfer',
  SettlementMethod.upi: 'upi',
  SettlementMethod.other: 'other',
};
