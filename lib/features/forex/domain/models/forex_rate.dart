import 'package:freezed_annotation/freezed_annotation.dart';

part 'forex_rate.freezed.dart';
part 'forex_rate.g.dart';

@freezed
class ForexRate with _$ForexRate {
  const factory ForexRate({
    required String baseCurrency,
    required String quoteCurrency,
    required double rate,
    required double bid,
    required double ask,
    required DateTime timestamp,
    double? change,
    double? changePercent,
  }) = _ForexRate;

  factory ForexRate.fromJson(Map<String, dynamic> json) =>
      _$ForexRateFromJson(json);
}