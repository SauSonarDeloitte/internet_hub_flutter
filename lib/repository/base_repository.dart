import 'package:equatable/equatable.dart';

/// Base result type for repository operations
sealed class Result<T> extends Equatable {
  const Result();
}

/// Success result with data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  List<Object?> get props => [data];
}

/// Error result with message and optional error object
class Failure<T> extends Result<T> {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.error, this.stackTrace});

  @override
  List<Object?> get props => [message, error, stackTrace];
}

/// Base repository interface
abstract class BaseRepository {
  /// Simulates network delay for mock repositories
  Future<void> simulateNetworkDelay({int milliseconds = 500}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
