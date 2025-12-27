import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../domain/models/portfolio_metrics.dart';

class PortfolioWebSocketService {
  Stream<PortfolioMetrics> connect() {
    // Connect to the Python backend WebSocket
    // Note: Use 10.0.2.2 for Android emulator to access localhost
    final uri = Uri.parse('ws://localhost:8000/ws/portfolio');
    final channel = WebSocketChannel.connect(uri);

    return channel.stream.map((event) {
      final data = jsonDecode(event as String);
      if (data['type'] == 'PORTFOLIO_UPDATE') {
        return PortfolioMetrics.fromJson(data['data']);
      }
      throw Exception('Unknown message type: ${data['type']}');
    });
  }

  Future<void> closePosition(String symbol) async {
    // In a real app, this would make an HTTP DELETE/POST request to the backend
    // e.g., await http.post(Uri.parse('http://localhost:8000/api/v1/positions/$symbol/close'));
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  }

  Future<void> modifyPosition(String symbol, double? stopLoss, double? takeProfit) async {
    // In a real app, this would make an HTTP PUT request
    // e.g., await http.put(Uri.parse('http://localhost:8000/api/v1/positions/$symbol'), body: jsonEncode({...}));
    await Future.delayed(const Duration(seconds: 1));
  }
}

final portfolioWebSocketProvider = Provider<PortfolioWebSocketService>((ref) {
  return PortfolioWebSocketService();
});

final portfolioMetricsProvider = StreamProvider.autoDispose<PortfolioMetrics>((ref) {
  final service = ref.watch(portfolioWebSocketProvider);
  return service.connect();
});