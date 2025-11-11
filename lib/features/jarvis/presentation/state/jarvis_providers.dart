// lib/features/jarvis/jarvis_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'data/repositories/jarvis_repository_impl.dart';
import 'data/services/jarvis_service.dart';
import 'domain/repositories/jarvis_repository.dart';
import 'domain/use_cases/send_chat_message_use_case.dart';
import 'presentation/state/jarvis_notifier.dart';
import 'presentation/state/jarvis_state.dart';

// 1. External Dependencies (Utility/Helper)
final uuidProvider = Provider((ref) => const Uuid());

// 2. Data Layer Providers (Service and Repository Implementation)
final jarvisServiceProvider = Provider<JarvisService>((ref) {
  // Returns the concrete implementation of the Service
  return JarvisServiceImpl();
});

final jarvisRepositoryProvider = Provider<JarvisRepository>((ref) {
  // The Repository Implementation depends on the Service
  final service = ref.watch(jarvisServiceProvider);
  // Note: We are using the correct implementation class here
  return JarvisRepositoryImpl(service);
});


// 3. Domain Layer Providers (Use Cases)
final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>((ref) {
  // The Use Case depends on the Repository Contract
  final repository = ref.watch(jarvisRepositoryProvider);
  return SendChatMessageUseCase(repository);
});


// 4. Presentation Layer Provider (State Notifier)
final jarvisNotifierProvider = StateNotifierProvider<JarvisNotifier, JarvisState>((ref) {
  // The Notifier depends on the Use Case and Uuid (for message IDs)
  final useCase = ref.watch(sendChatMessageUseCaseProvider);
  final uuid = ref.watch(uuidProvider);
  return JarvisNotifier(useCase, uuid);
});