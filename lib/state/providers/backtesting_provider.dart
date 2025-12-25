// lib/state/providers/backtesting_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/backtesting/domain/services/backtesting_service.dart';

final backtestingServiceProvider = Provider<BacktestingService>((ref) {
  return BacktestingService();
});