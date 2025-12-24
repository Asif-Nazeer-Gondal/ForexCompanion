import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final String? message;
  const ServerFailure([this.message]);
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  final String? message;
  const NetworkFailure([this.message]);
  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ForexApiFailure extends Failure {
  final String? message;
  const ForexApiFailure([this.message]);
  @override
  List<Object?> get props => [message];
}
