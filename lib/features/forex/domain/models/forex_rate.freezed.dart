// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forex_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForexRate _$ForexRateFromJson(Map<String, dynamic> json) {
  return _ForexRate.fromJson(json);
}

/// @nodoc
mixin _$ForexRate {
  String get baseCurrency => throw _privateConstructorUsedError;
  String get quoteCurrency => throw _privateConstructorUsedError;
  double get rate => throw _privateConstructorUsedError;
  double get bid => throw _privateConstructorUsedError;
  double get ask => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  double? get change => throw _privateConstructorUsedError;
  double? get changePercent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ForexRateCopyWith<ForexRate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForexRateCopyWith<$Res> {
  factory $ForexRateCopyWith(ForexRate value, $Res Function(ForexRate) then) =
      _$ForexRateCopyWithImpl<$Res, ForexRate>;
  @useResult
  $Res call(
      {String baseCurrency,
      String quoteCurrency,
      double rate,
      double bid,
      double ask,
      DateTime timestamp,
      double? change,
      double? changePercent});
}

/// @nodoc
class _$ForexRateCopyWithImpl<$Res, $Val extends ForexRate>
    implements $ForexRateCopyWith<$Res> {
  _$ForexRateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseCurrency = null,
    Object? quoteCurrency = null,
    Object? rate = null,
    Object? bid = null,
    Object? ask = null,
    Object? timestamp = null,
    Object? change = freezed,
    Object? changePercent = freezed,
  }) {
    return _then(_value.copyWith(
      baseCurrency: null == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      quoteCurrency: null == quoteCurrency
          ? _value.quoteCurrency
          : quoteCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double,
      bid: null == bid
          ? _value.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as double,
      ask: null == ask
          ? _value.ask
          : ask // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double?,
      changePercent: freezed == changePercent
          ? _value.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForexRateImplCopyWith<$Res>
    implements $ForexRateCopyWith<$Res> {
  factory _$$ForexRateImplCopyWith(
          _$ForexRateImpl value, $Res Function(_$ForexRateImpl) then) =
      __$$ForexRateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String baseCurrency,
      String quoteCurrency,
      double rate,
      double bid,
      double ask,
      DateTime timestamp,
      double? change,
      double? changePercent});
}

/// @nodoc
class __$$ForexRateImplCopyWithImpl<$Res>
    extends _$ForexRateCopyWithImpl<$Res, _$ForexRateImpl>
    implements _$$ForexRateImplCopyWith<$Res> {
  __$$ForexRateImplCopyWithImpl(
      _$ForexRateImpl _value, $Res Function(_$ForexRateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseCurrency = null,
    Object? quoteCurrency = null,
    Object? rate = null,
    Object? bid = null,
    Object? ask = null,
    Object? timestamp = null,
    Object? change = freezed,
    Object? changePercent = freezed,
  }) {
    return _then(_$ForexRateImpl(
      baseCurrency: null == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      quoteCurrency: null == quoteCurrency
          ? _value.quoteCurrency
          : quoteCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      rate: null == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as double,
      bid: null == bid
          ? _value.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as double,
      ask: null == ask
          ? _value.ask
          : ask // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      change: freezed == change
          ? _value.change
          : change // ignore: cast_nullable_to_non_nullable
              as double?,
      changePercent: freezed == changePercent
          ? _value.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForexRateImpl implements _ForexRate {
  const _$ForexRateImpl(
      {required this.baseCurrency,
      required this.quoteCurrency,
      required this.rate,
      required this.bid,
      required this.ask,
      required this.timestamp,
      this.change,
      this.changePercent});

  factory _$ForexRateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForexRateImplFromJson(json);

  @override
  final String baseCurrency;
  @override
  final String quoteCurrency;
  @override
  final double rate;
  @override
  final double bid;
  @override
  final double ask;
  @override
  final DateTime timestamp;
  @override
  final double? change;
  @override
  final double? changePercent;

  @override
  String toString() {
    return 'ForexRate(baseCurrency: $baseCurrency, quoteCurrency: $quoteCurrency, rate: $rate, bid: $bid, ask: $ask, timestamp: $timestamp, change: $change, changePercent: $changePercent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForexRateImpl &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.quoteCurrency, quoteCurrency) ||
                other.quoteCurrency == quoteCurrency) &&
            (identical(other.rate, rate) || other.rate == rate) &&
            (identical(other.bid, bid) || other.bid == bid) &&
            (identical(other.ask, ask) || other.ask == ask) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, baseCurrency, quoteCurrency,
      rate, bid, ask, timestamp, change, changePercent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForexRateImplCopyWith<_$ForexRateImpl> get copyWith =>
      __$$ForexRateImplCopyWithImpl<_$ForexRateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForexRateImplToJson(
      this,
    );
  }
}

abstract class _ForexRate implements ForexRate {
  const factory _ForexRate(
      {required final String baseCurrency,
      required final String quoteCurrency,
      required final double rate,
      required final double bid,
      required final double ask,
      required final DateTime timestamp,
      final double? change,
      final double? changePercent}) = _$ForexRateImpl;

  factory _ForexRate.fromJson(Map<String, dynamic> json) =
      _$ForexRateImpl.fromJson;

  @override
  String get baseCurrency;
  @override
  String get quoteCurrency;
  @override
  double get rate;
  @override
  double get bid;
  @override
  double get ask;
  @override
  DateTime get timestamp;
  @override
  double? get change;
  @override
  double? get changePercent;
  @override
  @JsonKey(ignore: true)
  _$$ForexRateImplCopyWith<_$ForexRateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
