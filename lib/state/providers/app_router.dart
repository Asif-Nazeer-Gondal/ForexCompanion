// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/agents/presentation/agent_dashboard_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/budget/presentation/budget_screen.dart';
import '../../features/news/presentation/news_screen.dart';
import '../../features/news/presentation/news_detail_screen.dart';
import '../../features/news/domain/models/news_article.dart';
import '../../features/forex/presentation/forex_chart_screen.dart';
import '../../features/trading/presentation/trade_execution_screen.dart';
import '../../features/trading/presentation/trade_history_screen.dart';
import '../../features/portfolio/presentation/portfolio_screen.dart';
import '../../features/tools/presentation/risk_calculator_screen.dart';
import '../../features/tools/presentation/currency_converter_screen.dart';
import '../../features/learning/presentation/learning_hub_screen.dart';
import '../../features/backtesting/presentation/backtesting_screen.dart';
import '../../features/jarvis/presentation/chat_screen.dart';
import '../../features/strategy/presentation/strategy_builder_screen.dart';
import '../../features/calendar/presentation/economic_calendar_screen.dart';
import '../../features/alerts/presentation/price_alerts_screen.dart';
import '../../features/learning/presentation/glossary_screen.dart';
import '../../features/tools/presentation/position_size_calculator_screen.dart';
import '../../features/journal/presentation/journal_screen.dart';
import '../../features/tools/presentation/correlation_matrix_screen.dart';
import '../../features/tools/presentation/session_map_screen.dart';
import '../../features/tools/presentation/profit_calculator_screen.dart';
import '../../features/settings/presentation/settings_backup_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const AgentDashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'backup',
            builder: (context, state) => const SettingsBackupScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/budget',
        name: 'budget',
        builder: (context, state) => const BudgetScreen(),
      ),
      GoRoute(
        path: '/news',
        name: 'news',
        builder: (context, state) => const NewsScreen(),
        routes: [
          GoRoute(
            path: 'detail',
            name: 'news_detail',
            builder: (context, state) {
              final article = state.extra as NewsArticle;
              return NewsDetailScreen(article: article);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/chart',
        name: 'chart',
        builder: (context, state) => const ForexChartScreen(),
      ),
      GoRoute(
        path: '/trade',
        name: 'trade',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TradeExecutionScreen(
            symbol: extra['symbol'] as String,
            currentPrice: extra['price'] as double,
          );
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const TradeHistoryScreen(),
      ),
      GoRoute(
        path: '/portfolio',
        name: 'portfolio',
        builder: (context, state) => const PortfolioScreen(),
      ),
      GoRoute(
        path: '/risk-calculator',
        name: 'risk_calculator',
        builder: (context, state) => const RiskCalculatorScreen(),
      ),
      GoRoute(
        path: '/learning',
        name: 'learning',
        builder: (context, state) => const LearningHubScreen(),
      ),
      GoRoute(
        path: '/converter',
        name: 'converter',
        builder: (context, state) => const CurrencyConverterScreen(),
      ),
      GoRoute(
        path: '/backtest',
        name: 'backtest',
        builder: (context, state) => const BacktestingScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/strategy-builder',
        name: 'strategy_builder',
        builder: (context, state) => const StrategyBuilderScreen(),
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const EconomicCalendarScreen(),
      ),
      GoRoute(
        path: '/alerts',
        name: 'alerts',
        builder: (context, state) => const PriceAlertsScreen(),
      ),
      GoRoute(
        path: '/glossary',
        name: 'glossary',
        builder: (context, state) => const GlossaryScreen(),
      ),
      GoRoute(
        path: '/position-size',
        name: 'position_size',
        builder: (context, state) => const PositionSizeCalculatorScreen(),
      ),
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const JournalScreen(),
      ),
      GoRoute(
        path: '/correlation',
        name: 'correlation',
        builder: (context, state) => const CorrelationMatrixScreen(),
      ),
      GoRoute(
        path: '/sessions',
        name: 'sessions',
        builder: (context, state) => const SessionMapScreen(),
      ),
      GoRoute(
        path: '/profit-calculator',
        name: 'profit_calculator',
        builder: (context, state) => const ProfitCalculatorScreen(),
      ),
    ],
  );
});