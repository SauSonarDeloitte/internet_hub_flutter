import 'package:equatable/equatable.dart';

/// Dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Load dashboard data
class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

/// Refresh dashboard data
class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

/// Mark notification as read
class MarkNotificationRead extends DashboardEvent {
  final String notificationId;

  const MarkNotificationRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read
class MarkAllNotificationsRead extends DashboardEvent {
  const MarkAllNotificationsRead();
}
