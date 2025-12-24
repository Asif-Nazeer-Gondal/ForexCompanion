// lib/features/trading/domain/models/trading_rule.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class TradingRule {
  final String id;
  final String userId;
  final String currencyPair;
  final TradingRuleType type;
  final TradeDirection direction;
  final double triggerPrice;
  final EntryCondition entryCondition;
  final double? stopLoss;
  final double? takeProfit;
  final double? trailingStop;
  final double positionSize;
  final double maxSlippage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastChecked;
  final DateTime? executedAt;
  final int timesTriggered;
  final double totalProfit;
  final double totalLoss;
  final TimeWindow? timeWindow;
  final int maxExecutions;

  TradingRule({
    required this.id,
    required this.userId,
    required this.currencyPair,
    required this.type,
    required this.direction,
    required this.triggerPrice,
    required this.entryCondition,
    this.stopLoss,
    this.takeProfit,
    this.trailingStop,
    this.positionSize = 1.0,
    this.maxSlippage = 0.001,
    this.isActive = true,
    required this.createdAt,
    this.lastChecked,
    this.executedAt,
    this.timesTriggered = 0,
    this.totalProfit = 0.0,
    this.totalLoss = 0.0,
    this.timeWindow,
    this.maxExecutions = 1,
  });

  // Copy with method for updates
  TradingRule copyWith({
    String? id,
    String? userId,
    String? currencyPair,
    TradingRuleType? type,
    TradeDirection? direction,
    double? triggerPrice,
    EntryCondition? entryCondition,
    double? stopLoss,
    double? takeProfit,
    double? trailingStop,
    double? positionSize,
    double? maxSlippage,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastChecked,
    DateTime? executedAt,
    int? timesTriggered,
    double? totalProfit,
    double? totalLoss,
    TimeWindow? timeWindow,
    int? maxExecutions,
  }) {
    return TradingRule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currencyPair: currencyPair ?? this.currencyPair,
      type: type ?? this.type,
      direction: direction ?? this.direction,
      triggerPrice: triggerPrice ?? this.triggerPrice,
      entryCondition: entryCondition ?? this.entryCondition,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      trailingStop: trailingStop ?? this.trailingStop,
      positionSize: positionSize ?? this.positionSize,
      maxSlippage: maxSlippage ?? this.maxSlippage,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastChecked: lastChecked ?? this.lastChecked,
      executedAt: executedAt ?? this.executedAt,
      timesTriggered: timesTriggered ?? this.timesTriggered,
      totalProfit: totalProfit ?? this.totalProfit,
      totalLoss: totalLoss ?? this.totalLoss,
      timeWindow: timeWindow ?? this.timeWindow,
      maxExecutions: maxExecutions ?? this.maxExecutions,
    );
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'currencyPair': currencyPair,
      'type': type.toString().split('.').last,
      'direction': direction.toString().split('.').last,
      'triggerPrice': triggerPrice,
      'entryCondition': entryCondition.toString().split('.').last,
      'stopLoss': stopLoss,
      'takeProfit': takeProfit,
      'trailingStop': trailingStop,
      'positionSize': positionSize,
      'maxSlippage': maxSlippage,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastChecked': lastChecked != null ? Timestamp.fromDate(lastChecked!) : null,
      'executedAt': executedAt != null ? Timestamp.fromDate(executedAt!) : null,
      'timesTriggered': timesTriggered,
      'totalProfit': totalProfit,
      'totalLoss': totalLoss,
      'timeWindow': timeWindow?.toJson(),
      'maxExecutions': maxExecutions,
    };
  }

  // Create from Firestore document
  factory TradingRule.fromJson(Map<String, dynamic> json) {
    return TradingRule(
      id: json['id'] as String,
      userId: json['userId'] as String,
      currencyPair: json['currencyPair'] as String,
      type: TradingRuleType.values.firstWhere(
            (e) => e.toString().split('.').last == json['type'],
        orElse: () => TradingRuleType.priceAlert,
      ),
      direction: TradeDirection.values.firstWhere(
            (e) => e.toString().split('.').last == json['direction'],
        orElse: () => TradeDirection.buy,
      ),
      triggerPrice: (json['triggerPrice'] as num).toDouble(),
      entryCondition: EntryCondition.values.firstWhere(
            (e) => e.toString().split('.').last == json['entryCondition'],
        orElse: () => EntryCondition.priceAbove,
      ),
      stopLoss: json['stopLoss'] != null ? (json['stopLoss'] as num).toDouble() : null,
      takeProfit: json['takeProfit'] != null ? (json['takeProfit'] as num).toDouble() : null,
      trailingStop: json['trailingStop'] != null ? (json['trailingStop'] as num).toDouble() : null,
      positionSize: (json['positionSize'] as num?)?.toDouble() ?? 1.0,
      maxSlippage: (json['maxSlippage'] as num?)?.toDouble() ?? 0.001,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastChecked: json['lastChecked'] != null
          ? (json['lastChecked'] as Timestamp).toDate()
          : null,
      executedAt: json['executedAt'] != null
          ? (json['executedAt'] as Timestamp).toDate()
          : null,
      timesTriggered: json['timesTriggered'] as int? ?? 0,
      totalProfit: (json['totalProfit'] as num?)?.toDouble() ?? 0.0,
      totalLoss: (json['totalLoss'] as num?)?.toDouble() ?? 0.0,
      timeWindow: json['timeWindow'] != null
          ? TimeWindow.fromJson(json['timeWindow'] as Map<String, dynamic>)
          : null,
      maxExecutions: json['maxExecutions'] as int? ?? 1,
    );
  }

  // Factory constructor for creating a new rule
  factory TradingRule.create({
    required String userId,
    required String currencyPair,
    required TradingRuleType type,
    required TradeDirection direction,
    required double triggerPrice,
    required EntryCondition entryCondition,
    double? stopLoss,
    double? takeProfit,
    double? trailingStop,
    double positionSize = 1.0,
    double maxSlippage = 0.001,
    TimeWindow? timeWindow,
    int maxExecutions = 1,
  }) {
    return TradingRule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      currencyPair: currencyPair,
      type: type,
      direction: direction,
      triggerPrice: triggerPrice,
      entryCondition: entryCondition,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      trailingStop: trailingStop,
      positionSize: positionSize,
      maxSlippage: maxSlippage,
      isActive: true,
      createdAt: DateTime.now(),
      timesTriggered: 0,
      totalProfit: 0.0,
      totalLoss: 0.0,
      timeWindow: timeWindow,
      maxExecutions: maxExecutions,
    );
  }
}

// Enums for trading rule types
enum TradingRuleType {
  priceAlert,      // Just notify when price is reached
  autoTrade,       // Automatically execute trade
  stopLoss,        // Stop loss order
  takeProfit,      // Take profit order
  trailingStop,    // Trailing stop order
}

enum TradeDirection {
  buy,
  sell,
}

enum EntryCondition {
  priceAbove,      // Trigger when price goes above target
  priceBelow,      // Trigger when price goes below target
  priceEquals,     // Trigger when price equals target (within slippage)
  priceChange,     // Trigger on percentage change
}

// Time window for rule execution
class TimeWindow {
  final DateTime startTime;
  final DateTime endTime;

  TimeWindow({
    required this.startTime,
    required this.endTime,
  });

  bool isActive() {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
    };
  }

  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    return TimeWindow(
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
    );
  }
}

// Extension methods for convenience
extension TradingRuleExtensions on TradingRule {
  bool get canExecute {
    if (!isActive) return false;
    if (timesTriggered >= maxExecutions) return false;
    if (timeWindow != null && !timeWindow!.isActive()) return false;
    return true;
  }

  bool get hasStopLoss => stopLoss != null;
  bool get hasTakeProfit => takeProfit != null;
  bool get hasTrailingStop => trailingStop != null;

  String get displayName {
    final typeStr = type.toString().split('.').last;
    final directionStr = direction.toString().split('.').last;
    return '$typeStr - $directionStr $currencyPair @ $triggerPrice';
  }

  double get netProfit => totalProfit - totalLoss;

  double? get riskRewardRatio {
    if (stopLoss == null || takeProfit == null) return null;
    final risk = (triggerPrice - stopLoss!).abs();
    final reward = (takeProfit! - triggerPrice).abs();
    return reward / risk;
  }
}