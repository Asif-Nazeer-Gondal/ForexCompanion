// lib/features/jarvis/domain/models/trading_recommendation_model.dart (Placeholder file)

import 'package:json_annotation/json_annotation.dart';

part 'trading_recommendation_model.g.dart';

enum TradingSignal { buy, sell, hold }

/// Represents the structured recommendation output from the AI for delicate investing.
@JsonSerializable()
class TradingRecommendationModel {
  final TradingSignal signal;
  final String reasoning;
  final String currencyPair;
  final double currentRate;

  TradingRecommendationModel({
    required this.signal,
    required this.reasoning,
    required this.currencyPair,
    required this.currentRate,
  });

  factory TradingRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$TradingRecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradingRecommendationModelToJson(this);
}