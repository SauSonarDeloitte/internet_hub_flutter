import 'package:equatable/equatable.dart';
import '../models/dashboard_data.dart';

/// Dashboard state
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// Loading state
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// Loaded state with data
class DashboardLoaded extends DashboardState {
  final DashboardData data;

  const DashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

/// Error state
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Refreshing state (data already loaded, but refreshing)
class DashboardRefreshing extends DashboardState {
  final DashboardData data;

  const DashboardRefreshing(this.data);

  @override
  List<Object?> get props => [data];
}
