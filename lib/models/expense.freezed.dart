// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseSplit _$ExpenseSplitFromJson(Map<String, dynamic> json) {
  return _ExpenseSplit.fromJson(json);
}

/// @nodoc
mixin _$ExpenseSplit {
  String get userId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;

  /// Serializes this ExpenseSplit to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseSplitCopyWith<ExpenseSplit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseSplitCopyWith<$Res> {
  factory $ExpenseSplitCopyWith(
          ExpenseSplit value, $Res Function(ExpenseSplit) then) =
      _$ExpenseSplitCopyWithImpl<$Res, ExpenseSplit>;
  @useResult
  $Res call({String userId, double amount, bool isPaid});
}

/// @nodoc
class _$ExpenseSplitCopyWithImpl<$Res, $Val extends ExpenseSplit>
    implements $ExpenseSplitCopyWith<$Res> {
  _$ExpenseSplitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? amount = null,
    Object? isPaid = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseSplitImplCopyWith<$Res>
    implements $ExpenseSplitCopyWith<$Res> {
  factory _$$ExpenseSplitImplCopyWith(
          _$ExpenseSplitImpl value, $Res Function(_$ExpenseSplitImpl) then) =
      __$$ExpenseSplitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, double amount, bool isPaid});
}

/// @nodoc
class __$$ExpenseSplitImplCopyWithImpl<$Res>
    extends _$ExpenseSplitCopyWithImpl<$Res, _$ExpenseSplitImpl>
    implements _$$ExpenseSplitImplCopyWith<$Res> {
  __$$ExpenseSplitImplCopyWithImpl(
      _$ExpenseSplitImpl _value, $Res Function(_$ExpenseSplitImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? amount = null,
    Object? isPaid = null,
  }) {
    return _then(_$ExpenseSplitImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseSplitImpl implements _ExpenseSplit {
  const _$ExpenseSplitImpl(
      {required this.userId, required this.amount, this.isPaid = false});

  factory _$ExpenseSplitImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseSplitImplFromJson(json);

  @override
  final String userId;
  @override
  final double amount;
  @override
  @JsonKey()
  final bool isPaid;

  @override
  String toString() {
    return 'ExpenseSplit(userId: $userId, amount: $amount, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseSplitImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, amount, isPaid);

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseSplitImplCopyWith<_$ExpenseSplitImpl> get copyWith =>
      __$$ExpenseSplitImplCopyWithImpl<_$ExpenseSplitImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseSplitImplToJson(
      this,
    );
  }
}

abstract class _ExpenseSplit implements ExpenseSplit {
  const factory _ExpenseSplit(
      {required final String userId,
      required final double amount,
      final bool isPaid}) = _$ExpenseSplitImpl;

  factory _ExpenseSplit.fromJson(Map<String, dynamic> json) =
      _$ExpenseSplitImpl.fromJson;

  @override
  String get userId;
  @override
  double get amount;
  @override
  bool get isPaid;

  /// Create a copy of ExpenseSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseSplitImplCopyWith<_$ExpenseSplitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return _Expense.fromJson(json);
}

/// @nodoc
mixin _$Expense {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get paidById => throw _privateConstructorUsedError;
  List<ExpenseSplit> get splits => throw _privateConstructorUsedError;
  SplitType get splitType => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get receiptImagePath => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseCopyWith<Expense> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res, Expense>;
  @useResult
  $Res call(
      {String id,
      String description,
      double amount,
      String currency,
      String categoryId,
      String paidById,
      List<ExpenseSplit> splits,
      SplitType splitType,
      DateTime date,
      String? groupId,
      String? notes,
      String? receiptImagePath,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ExpenseCopyWithImpl<$Res, $Val extends Expense>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? currency = null,
    Object? categoryId = null,
    Object? paidById = null,
    Object? splits = null,
    Object? splitType = null,
    Object? date = null,
    Object? groupId = freezed,
    Object? notes = freezed,
    Object? receiptImagePath = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      paidById: null == paidById
          ? _value.paidById
          : paidById // ignore: cast_nullable_to_non_nullable
              as String,
      splits: null == splits
          ? _value.splits
          : splits // ignore: cast_nullable_to_non_nullable
              as List<ExpenseSplit>,
      splitType: null == splitType
          ? _value.splitType
          : splitType // ignore: cast_nullable_to_non_nullable
              as SplitType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptImagePath: freezed == receiptImagePath
          ? _value.receiptImagePath
          : receiptImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseImplCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$$ExpenseImplCopyWith(
          _$ExpenseImpl value, $Res Function(_$ExpenseImpl) then) =
      __$$ExpenseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      double amount,
      String currency,
      String categoryId,
      String paidById,
      List<ExpenseSplit> splits,
      SplitType splitType,
      DateTime date,
      String? groupId,
      String? notes,
      String? receiptImagePath,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ExpenseImplCopyWithImpl<$Res>
    extends _$ExpenseCopyWithImpl<$Res, _$ExpenseImpl>
    implements _$$ExpenseImplCopyWith<$Res> {
  __$$ExpenseImplCopyWithImpl(
      _$ExpenseImpl _value, $Res Function(_$ExpenseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? amount = null,
    Object? currency = null,
    Object? categoryId = null,
    Object? paidById = null,
    Object? splits = null,
    Object? splitType = null,
    Object? date = null,
    Object? groupId = freezed,
    Object? notes = freezed,
    Object? receiptImagePath = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ExpenseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      paidById: null == paidById
          ? _value.paidById
          : paidById // ignore: cast_nullable_to_non_nullable
              as String,
      splits: null == splits
          ? _value._splits
          : splits // ignore: cast_nullable_to_non_nullable
              as List<ExpenseSplit>,
      splitType: null == splitType
          ? _value.splitType
          : splitType // ignore: cast_nullable_to_non_nullable
              as SplitType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      receiptImagePath: freezed == receiptImagePath
          ? _value.receiptImagePath
          : receiptImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseImpl implements _Expense {
  const _$ExpenseImpl(
      {required this.id,
      required this.description,
      required this.amount,
      required this.currency,
      required this.categoryId,
      required this.paidById,
      required final List<ExpenseSplit> splits,
      required this.splitType,
      required this.date,
      this.groupId,
      this.notes,
      this.receiptImagePath,
      this.createdAt,
      this.updatedAt})
      : _splits = splits;

  factory _$ExpenseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseImplFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final String categoryId;
  @override
  final String paidById;
  final List<ExpenseSplit> _splits;
  @override
  List<ExpenseSplit> get splits {
    if (_splits is EqualUnmodifiableListView) return _splits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_splits);
  }

  @override
  final SplitType splitType;
  @override
  final DateTime date;
  @override
  final String? groupId;
  @override
  final String? notes;
  @override
  final String? receiptImagePath;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Expense(id: $id, description: $description, amount: $amount, currency: $currency, categoryId: $categoryId, paidById: $paidById, splits: $splits, splitType: $splitType, date: $date, groupId: $groupId, notes: $notes, receiptImagePath: $receiptImagePath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.paidById, paidById) ||
                other.paidById == paidById) &&
            const DeepCollectionEquality().equals(other._splits, _splits) &&
            (identical(other.splitType, splitType) ||
                other.splitType == splitType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.receiptImagePath, receiptImagePath) ||
                other.receiptImagePath == receiptImagePath) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      amount,
      currency,
      categoryId,
      paidById,
      const DeepCollectionEquality().hash(_splits),
      splitType,
      date,
      groupId,
      notes,
      receiptImagePath,
      createdAt,
      updatedAt);

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      __$$ExpenseImplCopyWithImpl<_$ExpenseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseImplToJson(
      this,
    );
  }
}

abstract class _Expense implements Expense {
  const factory _Expense(
      {required final String id,
      required final String description,
      required final double amount,
      required final String currency,
      required final String categoryId,
      required final String paidById,
      required final List<ExpenseSplit> splits,
      required final SplitType splitType,
      required final DateTime date,
      final String? groupId,
      final String? notes,
      final String? receiptImagePath,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ExpenseImpl;

  factory _Expense.fromJson(Map<String, dynamic> json) = _$ExpenseImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  double get amount;
  @override
  String get currency;
  @override
  String get categoryId;
  @override
  String get paidById;
  @override
  List<ExpenseSplit> get splits;
  @override
  SplitType get splitType;
  @override
  DateTime get date;
  @override
  String? get groupId;
  @override
  String? get notes;
  @override
  String? get receiptImagePath;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Expense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseImplCopyWith<_$ExpenseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
