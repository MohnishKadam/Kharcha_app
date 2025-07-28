// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) {
  return _ExpenseCategory.fromJson(json);
}

/// @nodoc
mixin _$ExpenseCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  int get colorIndex => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExpenseCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCategoryCopyWith<ExpenseCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCategoryCopyWith<$Res> {
  factory $ExpenseCategoryCopyWith(
          ExpenseCategory value, $Res Function(ExpenseCategory) then) =
      _$ExpenseCategoryCopyWithImpl<$Res, ExpenseCategory>;
  @useResult
  $Res call(
      {String id,
      String name,
      String iconName,
      int colorIndex,
      bool isCustom,
      DateTime? createdAt});
}

/// @nodoc
class _$ExpenseCategoryCopyWithImpl<$Res, $Val extends ExpenseCategory>
    implements $ExpenseCategoryCopyWith<$Res> {
  _$ExpenseCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconName = null,
    Object? colorIndex = null,
    Object? isCustom = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorIndex: null == colorIndex
          ? _value.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseCategoryImplCopyWith<$Res>
    implements $ExpenseCategoryCopyWith<$Res> {
  factory _$$ExpenseCategoryImplCopyWith(_$ExpenseCategoryImpl value,
          $Res Function(_$ExpenseCategoryImpl) then) =
      __$$ExpenseCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String iconName,
      int colorIndex,
      bool isCustom,
      DateTime? createdAt});
}

/// @nodoc
class __$$ExpenseCategoryImplCopyWithImpl<$Res>
    extends _$ExpenseCategoryCopyWithImpl<$Res, _$ExpenseCategoryImpl>
    implements _$$ExpenseCategoryImplCopyWith<$Res> {
  __$$ExpenseCategoryImplCopyWithImpl(
      _$ExpenseCategoryImpl _value, $Res Function(_$ExpenseCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? iconName = null,
    Object? colorIndex = null,
    Object? isCustom = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$ExpenseCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorIndex: null == colorIndex
          ? _value.colorIndex
          : colorIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseCategoryImpl implements _ExpenseCategory {
  const _$ExpenseCategoryImpl(
      {required this.id,
      required this.name,
      required this.iconName,
      required this.colorIndex,
      this.isCustom = false,
      this.createdAt});

  factory _$ExpenseCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String iconName;
  @override
  final int colorIndex;
  @override
  @JsonKey()
  final bool isCustom;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ExpenseCategory(id: $id, name: $name, iconName: $iconName, colorIndex: $colorIndex, isCustom: $isCustom, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorIndex, colorIndex) ||
                other.colorIndex == colorIndex) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, iconName, colorIndex, isCustom, createdAt);

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      __$$ExpenseCategoryImplCopyWithImpl<_$ExpenseCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseCategoryImplToJson(
      this,
    );
  }
}

abstract class _ExpenseCategory implements ExpenseCategory {
  const factory _ExpenseCategory(
      {required final String id,
      required final String name,
      required final String iconName,
      required final int colorIndex,
      final bool isCustom,
      final DateTime? createdAt}) = _$ExpenseCategoryImpl;

  factory _ExpenseCategory.fromJson(Map<String, dynamic> json) =
      _$ExpenseCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get iconName;
  @override
  int get colorIndex;
  @override
  bool get isCustom;
  @override
  DateTime? get createdAt;

  /// Create a copy of ExpenseCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseCategoryImplCopyWith<_$ExpenseCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
