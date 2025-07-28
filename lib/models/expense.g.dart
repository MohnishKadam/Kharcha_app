// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseSplitImpl _$$ExpenseSplitImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseSplitImpl(
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      isPaid: json['isPaid'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExpenseSplitImplToJson(_$ExpenseSplitImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'amount': instance.amount,
      'isPaid': instance.isPaid,
    };

_$ExpenseImpl _$$ExpenseImplFromJson(Map<String, dynamic> json) =>
    _$ExpenseImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      categoryId: json['categoryId'] as String,
      paidById: json['paidById'] as String,
      splits: (json['splits'] as List<dynamic>)
          .map((e) => ExpenseSplit.fromJson(e as Map<String, dynamic>))
          .toList(),
      splitType: $enumDecode(_$SplitTypeEnumMap, json['splitType']),
      date: DateTime.parse(json['date'] as String),
      groupId: json['groupId'] as String?,
      notes: json['notes'] as String?,
      receiptImagePath: json['receiptImagePath'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExpenseImplToJson(_$ExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'currency': instance.currency,
      'categoryId': instance.categoryId,
      'paidById': instance.paidById,
      'splits': instance.splits,
      'splitType': _$SplitTypeEnumMap[instance.splitType]!,
      'date': instance.date.toIso8601String(),
      'groupId': instance.groupId,
      'notes': instance.notes,
      'receiptImagePath': instance.receiptImagePath,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SplitTypeEnumMap = {
  SplitType.equal: 'equal',
  SplitType.exact: 'exact',
  SplitType.percentage: 'percentage',
};
