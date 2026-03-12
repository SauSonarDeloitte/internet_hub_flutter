import '../../features/dashboard/models/dashboard_data.dart';

/// Abstract repository interface for dashboard data
abstract class DashboardRepository {
  /// Fetch dashboard data for the current user
  Future<DashboardData> getDashboardData();

  /// Mark notification as read
  Future<void> markNotificationAsRead(String notificationId);

  /// Mark all notifications as read
  Future<void> markAllNotificationsAsRead();

  /// Refresh dashboard data
  Future<DashboardData> refreshDashboard();
}
