import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Assuming you have a file that holds navigation routes
import 'package:forex_companion/routes/app_router.dart';

// Import local Jarvis components and state
import '../presentation/state/jarvis_notifier.dart'; // Should be correct path now
import '../presentation/state/jarvis_state.dart';   // Should be correct path now
import '../presentation/widgets/chat_input_field.dart';
import '../presentation/widgets/chat_bubble.dart';

// Import necessary feature models (assuming these paths are resolved)
import '../../domain/models/transaction_tool_model.dart';
import '../../domain/models/trading_recommendation_model.dart';

// --- Placeholder for Jarvis Provider ---
// NOTE: Assuming this provider is correctly defined in lib/features/jarvis/presentation/state/jarvis_providers.dart
final jarvisNotifierProvider = StateNotifierProvider<JarvisNotifier, JarvisState>(
      (ref) => throw UnimplementedError(),
);
// ----------------------------------------


class JarvisPage extends ConsumerWidget {
  const JarvisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. LISTEN FOR TOOL ACTIONS (The Dispatcher Logic)
    ref.listen<ToolAction?>(
      jarvisNotifierProvider.select((notifier) => notifier.toolAction),
          (previous, next) {
        if (next == null) return; // Action consumed or none available

        // Consume the action immediately to prevent re-triggering on rebuilds
        ref.read(jarvisNotifierProvider.notifier).consumeToolAction();

        // Dispatch logic based on the action type
        switch (next.type) {
          case ToolActionType.logTransaction:
            _handleLogTransaction(context, next.data as TransactionToolModel);
            break;
          case ToolActionType.showTradingRecommendation:
            _showTradingRecommendation(context, next.data as TradingRecommendationModel);
            break;
          case ToolActionType.none:
            break;
        }
      },
    );

    final state = ref.watch(jarvisNotifierProvider);
    final notifier = ref.read(jarvisNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jarvis AI Companion'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // 2. Chat History List
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 8.0),
              itemCount: state.chatHistory.length,
              itemBuilder: (context, index) {
                final message = state.chatHistory.reversed.toList()[index];
                return ChatBubble(
                  message: message,
                  // You might need to adjust the appearance based on the tool signal later
                );
              },
            ),
          ),
          // 3. Loading Indicator
          if (state.isLoading)
            const LinearProgressIndicator(),

          // 4. Chat Input Field
          ChatInputField(
            onSend: notifier.sendUserMessage,
            isEnabled: !state.isLoading,
          ),
        ],
      ),
    );
  }

  // --- UI Action Handlers ---

  void _handleLogTransaction(BuildContext context, TransactionToolModel model) {
    // Goal: Navigate to the Budget Input screen and pass the pre-filled model data.
    // NOTE: This assumes your GoRouter setup (AppRoutes.budgetInput) can accept
    // an extra object to pre-fill the form.

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('AI action: Pre-filling Budget form for ${model.category}.')),
    );

    // Example navigation to the budget input screen
    // The model data needs to be passed, either via a GoRouter extra parameter
    // or by updating a shared Riverpod state before navigation.
    GoRouter.of(context).goNamed(
      AppRoutes.budgetInput.name,
      extra: model, // Passing the model for pre-filling
    );
  }

  void _showTradingRecommendation(BuildContext context, TradingRecommendationModel model) {
    // Goal: Show a modal or a floating card with the delicate investing recommendation.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
              'Trading Signal: ${model.signal.name.toUpperCase()}',
              style: TextStyle(color: model.signal == TradingSignal.buy ? Colors.green.shade700 : Colors.red.shade700)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Currency Pair: ${model.currencyPair} @ ${model.currentRate.toStringAsFixed(4)}'),
              const SizedBox(height: 12),
              const Text('Reasoning:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(model.reasoning),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Understood'),
            ),
          ],
        );
      },
    );
  }
}

// Placeholder for GoRouter route names
enum AppRoutes {
  jarvis,
  budgetInput
}