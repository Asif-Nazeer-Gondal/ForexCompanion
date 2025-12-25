import 'package:freezed_annotation/freezed_annotation.dart';

part 'forex_rate.freezed.dart';
part 'forex_rate.g.dart';

@freezed
class ForexRate with _$ForexRate {
  const factory ForexRate({
    required String baseCurrency,
    required String quoteCurrency,
    double? bid,
    double? ask,
    required double rate,
    required DateTime timestamp,
  }) = _ForexRate;

  factory ForexRate.fromJson(Map<String, dynamic> json) => _$ForexRateFromJson(json);
}