import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock state for agents - In the future, this will map to the Python backend's JSON response
class AgentState {
  final String name;
  final String role;
  final String status; // Idle, Analyzing, Voting
  final String? lastSignal; // BUY, SELL, NEUTRAL
  final double confidence;
  final IconData icon;
  final Color color;

  AgentState({
    required this.name,
    required this.role,
    this.status = 'Idle',
    this.lastSignal,
    this.confidence = 0.0,
    required this.icon,
    required this.color,
  });
}

class AgentDashboardScreen extends ConsumerStatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  ConsumerState<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends ConsumerState<AgentDashboardScreen> {
  // Mock data representing the "Council"
  final List<AgentState> _agents = [
    AgentState(
      name: 'Technical Analyst',
      role: 'Chart Patterns & Indicators',
      status: 'Analyzing',
      lastSignal: 'BUY',
      confidence: 0.85,
      icon: Icons.show_chart,
      color: Colors.blue,
    ),
    AgentState(
      name: 'Fundamentalist',
      role: 'News & Sentiment',
      status: 'Idle',
      lastSignal: 'NEUTRAL',
      confidence: 0.50,
      icon: Icons.newspaper,
      color: Colors.orange,
    ),
    AgentState(
      name: 'Risk Manager',
      role: 'Position Sizing & Safety',
      status: 'Monitoring',
      lastSignal: 'APPROVE',
      confidence: 1.0,
      icon: Icons.security,
      color: Colors.red,
    ),
    AgentState(
      name: 'The Council (Synthesis)',
      role: 'Final Decision Maker',
      status: 'Waiting for inputs',
      icon: Icons.psychology,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Council of Agents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Trigger refresh from backend
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSystemStatus(),
          const SizedBox(height: 24),
          const Text(
            'Active Agents',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _agents.length,
            itemBuilder: (context, index) {
              return _buildAgentCard(_agents[index]);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Council Decisions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDecisionLog(),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Operational',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Next cycle in 04:32',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.hub, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildAgentCard(AgentState agent) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: agent.color.withOpacity(0.1),
              child: Icon(agent.icon, color: agent.color),
            ),
            const SizedBox(height: 12),
            Text(
              agent.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              agent.role,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Text(
                agent.status,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ),
            if (agent.lastSignal != null) ...[
              const SizedBox(height: 8),
              Text(
                agent.lastSignal!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: agent.lastSignal == 'BUY'
                      ? Colors.green
                      : agent.lastSignal == 'SELL'
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionLog() {
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text('EUR/USD Analysis #${1000 - index}'),
            subtitle: const Text('Council Decision: HOLD'),
            trailing: Text('${index * 15}m ago'),
          );
        },
      ),
    );
  }
}