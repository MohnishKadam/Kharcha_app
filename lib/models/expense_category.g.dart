// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseCategoryImpl _$$ExpenseCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ExpenseCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorIndex: (json['colorIndex'] as num).toInt(),
      isCustom: json['isCustom'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExpenseCategoryImplToJson(
        _$ExpenseCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorIndex': instance.colorIndex,
      'isCustom': instance.isCustom,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
