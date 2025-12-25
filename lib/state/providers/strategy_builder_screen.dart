// lib/features/strategy/presentation/strategy_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../state/providers/strategy_provider.dart';
import '../domain/models/custom_strategy.dart';

class StrategyBuilderScreen extends ConsumerStatefulWidget {
  const StrategyBuilderScreen({super.key});

  @override
  ConsumerState<StrategyBuilderScreen> createState() => _StrategyBuilderScreenState();
}

class _StrategyBuilderScreenState extends ConsumerState<StrategyBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fastPeriodController = TextEditingController(text: '9');
  final _slowPeriodController = TextEditingController(text: '21');

  @override
  void dispose() {
    _nameController.dispose();
    _fastPeriodController.dispose();
    _slowPeriodController.dispose();
    super.dispose();
  }

  void _saveStrategy() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final fast = int.parse(_fastPeriodController.text);
      final slow = int.parse(_slowPeriodController.text);

      if (fast >= slow) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fast period must be smaller than slow period')),
        );
        return;
      }

      final strategy = CustomStrategy(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        fastPeriod: fast,
        slowPeriod: slow,
      );

      ref.read(strategyProvider.notifier).addStrategy(strategy);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Strategy saved successfully')),
      );
      
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final strategies = ref.watch(strategyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Strategy Builder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Builder Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create MA Crossover Strategy', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Strategy Name',
                          hintText: 'e.g., Golden Cross 9/21',
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _fastPeriodController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Fast Period'),
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _slowPeriodController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Slow Period'),
                              validator: (v) => v?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _saveStrategy,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Strategy'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Saved Strategies List
            Text('Saved Strategies', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            if (strategies.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: Text('No strategies saved yet.')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: strategies.length,
                itemBuilder: (context, index) {
                  final strategy = strategies[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(strategy.name),
                      subtitle: Text('MA Crossover: ${strategy.fastPeriod} / ${strategy.slowPeriod}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          ref.read(strategyProvider.notifier).removeStrategy(strategy.id);
                        },
                      ),
                      onTap: () {
                        // TODO: Navigate to backtest with this strategy
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}