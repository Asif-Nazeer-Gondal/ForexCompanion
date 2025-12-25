// lib/features/backtesting/presentation/backtesting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../state/providers/backtesting_provider.dart';
import '../../../../state/providers/watchlist_provider.dart';
import '../../domain/services/backtesting_service.dart';
import '../../../trading/domain/models/trade_order.dart';

class BacktestingScreen extends ConsumerStatefulWidget {
  const BacktestingScreen({super.key});

  @override
  ConsumerState<BacktestingScreen> createState() => _BacktestingScreenState();
}

class _BacktestingScreenState extends ConsumerState<BacktestingScreen> {
  bool _isLoading = false;
  BacktestResult? _result;
  String? _error;
  final _currencyFormat = NumberFormat.currency(symbol: '\$');

  Future<void> _runBacktest() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      // 1. Fetch Historical Data (e.g., EUR/USD for last 90 days)
      final repository = ref.read(forexRepositoryProvider);
      final endDate = DateTime.now();
      final startDate = endDate.subtract(const Duration(days: 90));

      final dataResult = await repository.getHistoricalRates(
        currency: 'EUR/USD',
        startDate: startDate,
        endDate: endDate,
      );

      dataResult.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        },
        (rates) {
          if (rates.isEmpty) {
            setState(() {
              _error = "No historical data available";
              _isLoading = false;
            });
            return;
          }

          // 2. Run Backtest
          final service = ref.read(backtestingServiceProvider);
          // Using a simple SMA strategy for demonstration
          final strategy = SimpleMovingAverageStrategy(period: 5);

          final result = service.runBacktest(
            data: rates,
            strategy: strategy,
            initialBalance: 10000,
            tradeAmount: 2000,
          );

          setState(() {
            _result = result;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Strategy Backtesting'),
      ),
      body: Column(
        children: [
          // Control Panel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _runBacktest,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.play_arrow),
                label: const Text('Run Backtest (EUR/USD - SMA 5)'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Error Display
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),

          // Results
          if (_result != null) ...[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Metrics Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildMetricCard(context, 'Total Profit',
                          _currencyFormat.format(_result!.totalProfit),
                          color: _result!.totalProfit >= 0 ? Colors.green : Colors.red),
                      _buildMetricCard(context, 'ROI',
                          '${_result!.returnOnInvestment.toStringAsFixed(2)}%'),
                      _buildMetricCard(context, 'Win Rate',
                          '${_result!.winRate.toStringAsFixed(1)}%'),
                      _buildMetricCard(context, 'Max Drawdown',
                          '${_result!.maxDrawdown.toStringAsFixed(2)}%',
                          color: Colors.red),
                      _buildMetricCard(context, 'Total Trades',
                          '${_result!.totalTrades}'),
                      _buildMetricCard(context, 'Final Balance',
                          _currencyFormat.format(_result!.finalBalance)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Trade Log', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  ..._result!.trades.map((trade) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            trade.type == TradeType.buy
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: trade.type == TradeType.buy
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(
                              '${trade.type.name.toUpperCase()} ${trade.symbol}'),
                          subtitle: Text(DateFormat.yMMMd().format(trade.timestamp)),
                          trailing: Text(
                            '@ ${trade.price.toStringAsFixed(5)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String label, String value,
      {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}