// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Settlement _$SettlementFromJson(Map<String, dynamic> json) {
  return _Settlement.fromJson(json);
}

/// @nodoc
mixin _$Settlement {
  String get id => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  SettlementMethod get method => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get transactionReference => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Settlement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettlementCopyWith<Settlement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettlementCopyWith<$Res> {
  factory $SettlementCopyWith(
          Settlement value, $Res Function(Settlement) then) =
      _$SettlementCopyWithImpl<$Res, Settlement>;
  @useResult
  $Res call(
      {String id,
      String fromUserId,
      String toUserId,
      double amount,
      String currency,
      SettlementMethod method,
      DateTime date,
      String? groupId,
      String? notes,
      String? transactionReference,
      DateTime? createdAt});
}

/// @nodoc
class _$SettlementCopyWithImpl<$Res, $Val extends Settlement>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? date = null,
    Object? groupId = freezed,
    Object? notes = freezed,
    Object? transactionReference = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as SettlementMethod,
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
      transactionReference: freezed == transactionReference
          ? _value.transactionReference
          : transactionReference // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettlementImplCopyWith<$Res>
    implements $SettlementCopyWith<$Res> {
  factory _$$SettlementImplCopyWith(
          _$SettlementImpl value, $Res Function(_$SettlementImpl) then) =
      __$$SettlementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String fromUserId,
      String toUserId,
      double amount,
      String currency,
      SettlementMethod method,
      DateTime date,
      String? groupId,
      String? notes,
      String? transactionReference,
      DateTime? createdAt});
}

/// @nodoc
class __$$SettlementImplCopyWithImpl<$Res>
    extends _$SettlementCopyWithImpl<$Res, _$SettlementImpl>
    implements _$$SettlementImplCopyWith<$Res> {
  __$$SettlementImplCopyWithImpl(
      _$SettlementImpl _value, $Res Function(_$SettlementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? amount = null,
    Object? currency = null,
    Object? method = null,
    Object? date = null,
    Object? groupId = freezed,
    Object? notes = freezed,
    Object? transactionReference = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$SettlementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as SettlementMethod,
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
      transactionReference: freezed == transactionReference
          ? _value.transactionReference
          : transactionReference // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettlementImpl implements _Settlement {
  const _$SettlementImpl(
      {required this.id,
      required this.fromUserId,
      required this.toUserId,
      required this.amount,
      required this.currency,
      required this.method,
      required this.date,
      this.groupId,
      this.notes,
      this.transactionReference,
      this.createdAt});

  factory _$SettlementImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettlementImplFromJson(json);

  @override
  final String id;
  @override
  final String fromUserId;
  @override
  final String toUserId;
  @override
  final double amount;
  @override
  final String currency;
  @override
  final SettlementMethod method;
  @override
  final DateTime date;
  @override
  final String? groupId;
  @override
  final String? notes;
  @override
  final String? transactionReference;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Settlement(id: $id, fromUserId: $fromUserId, toUserId: $toUserId, amount: $amount, currency: $currency, method: $method, date: $date, groupId: $groupId, notes: $notes, transactionReference: $transactionReference, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettlementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.transactionReference, transactionReference) ||
                other.transactionReference == transactionReference) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fromUserId, toUserId, amount,
      currency, method, date, groupId, notes, transactionReference, createdAt);

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettlementImplCopyWith<_$SettlementImpl> get copyWith =>
      __$$SettlementImplCopyWithImpl<_$SettlementImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettlementImplToJson(
      this,
    );
  }
}

abstract class _Settlement implements Settlement {
  const factory _Settlement(
      {required final String id,
      required final String fromUserId,
      required final String toUserId,
      required final double amount,
      required final String currency,
      required final SettlementMethod method,
      required final DateTime date,
      final String? groupId,
      final String? notes,
      final String? transactionReference,
      final DateTime? createdAt}) = _$SettlementImpl;

  factory _Settlement.fromJson(Map<String, dynamic> json) =
      _$SettlementImpl.fromJson;

  @override
  String get id;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  double get amount;
  @override
  String get currency;
  @override
  SettlementMethod get method;
  @override
  DateTime get date;
  @override
  String? get groupId;
  @override
  String? get notes;
  @override
  String? get transactionReference;
  @override
  DateTime? get createdAt;

  /// Create a copy of Settlement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettlementImplCopyWith<_$SettlementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
