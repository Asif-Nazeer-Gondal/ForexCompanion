// lib/state/providers/agent_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Agent {
  final String id;
  final String type;
  final String status; // e.g., 'active', 'inactive', 'error'
  final Map<String, dynamic> profile;

  Agent({required this.id, required this.type, required this.status, required this.profile});

  Agent copyWith({String? id, String? type, String? status, Map<String, dynamic>? profile}) {
    return Agent(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      profile: profile ?? this.profile,
    );
  }
}

class AgentNotifier extends StateNotifier<AsyncValue<List<Agent>>> {
  AgentNotifier() : super(const AsyncValue.loading()) {
    _fetchAgents();
  }

  Future<void> _fetchAgents() async {
    state = const AsyncValue.loading();
    try {
      // Simulate fetching data from backend
      await Future.delayed(const Duration(seconds: 1));
      final agents = [
        Agent(id: 'con_agent_1', type: 'Conservative', status: 'inactive', profile: {'risk_tolerance': 'low'}),
        Agent(id: 'agg_agent_1', type: 'Aggressive', status: 'inactive', profile: {'risk_tolerance': 'high'}),
      ];
      state = AsyncValue.data(agents);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateAgentStatus(String agentId, String newStatus) {
    if (state.hasValue) {
      final updatedAgents = state.value!.map((agent) {
        if (agent.id == agentId) {
          return agent.copyWith(status: newStatus);
        }
        return agent;
      }).toList();
      state = AsyncValue.data(updatedAgents);
    }
  }

  void addAgent(Agent newAgent) {
    if (state.hasValue) {
      state = AsyncValue.data([...state.value!, newAgent]);
    }
  }
}

final agentProvider = StateNotifierProvider<AgentNotifier, AsyncValue<List<Agent>>>((ref) {
  return AgentNotifier();
});

