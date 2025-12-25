// lib/services/websocket_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart'; // For non-web platforms

// Define an abstract class for WebSocket service to allow for mocking/testing
abstract class WebSocketService {
  Stream<dynamic> get stream;
  void sendMessage(String message);
  void dispose();
}

class WebSocketServiceImpl implements WebSocketService {
  WebSocketChannel? _channel;
  final String _url;

  WebSocketServiceImpl(this._url) {
    _connect();
  }

  void _connect() {
    try {
      _channel = IOWebSocketChannel.connect(_url); // Use IOWebSocketChannel for non-web
      print('WebSocket connected to $_url');
    } catch (e) {
      print('WebSocket connection error: $e');
      // Implement reconnection logic here
    }
  }

  @override
  Stream<dynamic> get stream => _channel!.stream;

  @override
  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  @override
  void dispose() {
    _channel?.sink.close();
    print('WebSocket disconnected from $_url');
  }
}

// Provider for WebSocketService
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  // Replace with your actual WebSocket URL
  const wsUrl = 'ws://127.0.0.1:8000/ws'; 
  final service = WebSocketServiceImpl(wsUrl);
  ref.onDispose(() => service.dispose());
  return service;
});