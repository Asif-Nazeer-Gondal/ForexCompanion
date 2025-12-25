// lib/features/agents/presentation/agent_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forexcompanion/state/providers/agent_provider.dart';
import 'package:forexcompanion/core/utils/app_logger.dart';

class AgentDashboardScreen extends ConsumerWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentsAsyncValue = ref.watch(agentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: agentsAsyncValue.when(
        data: (agents) {
          return ListView.builder(
            itemCount: agents.length,
            itemBuilder: (context, index) {
              final agent = agents[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Agent ID: ${agent.id}', style: Theme.of(context).textTheme.headlineSmall),
                      Text('Type: ${agent.type}'),
                      Text('Status: ${agent.status}'),
                      Text('Risk Tolerance: ${agent.profile['risk_tolerance']}'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement start agent logic (e.g., call backend API)
                              AppLogger.info('Starting agent: ${agent.id}');
                              ref.read(agentProvider.notifier).updateAgentStatus(agent.id, 'active');
                            },
                            child: const Text('Start'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement stop agent logic (e.g., call backend API)
                              AppLogger.info('Stopping agent: ${agent.id}');
                              ref.read(agentProvider.notifier).updateAgentStatus(agent.id, 'inactive');
                            },
                            child: const Text('Stop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement Agent creation wizard navigation
          AppLogger.info('Navigate to Agent Creation Wizard');
          // Example navigation:
          // Navigator.of(context).pushNamed('/agent-creation');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}