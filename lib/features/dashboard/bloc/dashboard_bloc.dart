import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/dashboard/dashboard_repository.dart';
import '../../../utils/logger/talker_config.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({required DashboardRepository repository})
      : _repository = repository,
        super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<MarkNotificationRead>(_onMarkNotificationRead);
    on<MarkAllNotificationsRead>(_onMarkAllNotificationsRead);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(const DashboardLoading());
      TalkerConfig.info('Loading dashboard data...');

      final data = await _repository.getDashboardData();
      
      TalkerConfig.info('Dashboard data loaded successfully');
      emit(DashboardLoaded(data));
    } catch (e, stackTrace) {
      TalkerConfig.error('Failed to load dashboard: $e', stackTrace);
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      // If we have data, show refreshing state
      if (state is DashboardLoaded) {
        final currentData = (state as DashboardLoaded).data;
        emit(DashboardRefreshing(currentData));
      } else {
        emit(const DashboardLoading());
      }

      TalkerConfig.info('Refreshing dashboard data...');
      final data = await _repository.refreshDashboard();
      
      TalkerConfig.info('Dashboard data refreshed successfully');
      emit(DashboardLoaded(data));
    } catch (e, stackTrace) {
      TalkerConfig.error('Failed to refresh dashboard: $e', stackTrace);
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onMarkNotificationRead(
    MarkNotificationRead event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      TalkerConfig.info('Marking notification ${event.notificationId} as read');
      await _repository.markNotificationAsRead(event.notificationId);
      
      // Reload dashboard to reflect changes
      add(const LoadDashboard());
    } catch (e, stackTrace) {
      TalkerConfig.error('Failed to mark notification as read: $e', stackTrace);
      // Don't emit error state for this, just log it
    }
  }

  Future<void> _onMarkAllNotificationsRead(
    MarkAllNotificationsRead event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      TalkerConfig.info('Marking all notifications as read');
      await _repository.markAllNotificationsAsRead();
      
      // Reload dashboard to reflect changes
      add(const LoadDashboard());
    } catch (e, stackTrace) {
      TalkerConfig.error('Failed to mark all notifications as read: $e', stackTrace);
      // Don't emit error state for this, just log it
    }
  }
}
