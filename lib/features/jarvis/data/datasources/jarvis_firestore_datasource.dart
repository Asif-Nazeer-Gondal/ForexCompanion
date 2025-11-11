// lib/features/jarvis/data/datasources/jarvis_firestore_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/chat_message.dart';

/// Abstract contract for data source operations.
abstract class JarvisDataSource {
  /// Streams the entire conversation history for the current user.
  Stream<List<ChatMessage>> getMessageHistory();

  /// Saves a new ChatMessage to the history.
  Future<void> saveMessage(ChatMessage message);
}

/// Firestore implementation for Jarvis data persistence.
class JarvisFirestoreDataSource implements JarvisDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final String _appId;

  // Collection paths defined by the environment constraints
  static const String _publicPath = 'public/data/jarvis_conversations';

  JarvisFirestoreDataSource(this._firestore, this._auth, this._appId);

  // Helper to get the conversation collection path based on the authenticated user.
  CollectionReference _getCollection() {
    // Determine the user ID (authenticated or anonymous fallback)
    final userId = _auth.currentUser?.uid ?? 'anonymous_user';
    // Construct the mandated Firestore path
    final path = 'artifacts/$_appId/$_publicPath/$userId/messages';
    return _firestore.collection(path);
  }

  @override
  Stream<List<ChatMessage>> getMessageHistory() {
    // Stream messages ordered by timestamp for chronological display
    return _getCollection()
        .orderBy('timestamp', descending: false) // Oldest first
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Data mapping from Firestore object to Domain Model
        return ChatMessage(
          id: data['id'] as String,
          role: data['role'] as String,
          text: data['text'] as String,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    final docRef = _getCollection().doc(message.id);

    await docRef.set({
      'id': message.id,
      'role': message.role,
      'text': message.text,
      'timestamp': Timestamp.fromDate(message.timestamp),
    }).catchError((e) {
      if (kDebugMode) {
        print('Firestore Save Error: $e');
      }
      throw Exception('Failed to save message history.');
    });
  }
}