import '../../features/dashboard/models/dashboard_data.dart';
import '../../mock/mock_data.dart';
import '../../mock/mock_dashboard.dart';
import 'dashboard_repository.dart';

/// Mock implementation of DashboardRepository
class MockDashboardRepository implements DashboardRepository {
  // Simulated current user data
  final String _userName = 'Demo User';
  final String _userDesignation = 'Senior Software Engineer';
  final String _userDepartment = 'Engineering';
  final String _employeeId = 'EMP001';

  @override
  Future<DashboardData> getDashboardData() async {
    // Simulate network delay
    await MockData.simulateDelay();

    // Simulate random errors (10% chance)
    // MockData.simulateRandomError(errorRate: 0.1);

    return MockDashboard.generateDashboardData(
      userName: _userName,
      userDesignation: _userDesignation,
      userDepartment: _userDepartment,
      employeeId: _employeeId,
    );
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    // Simulate network delay
    await MockData.simulateDelay(minMs: 100, maxMs: 300);

    // In a real implementation, this would update the backend
    // For mock, we just simulate the delay
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    // Simulate network delay
    await MockData.simulateDelay(minMs: 200, maxMs: 500);

    // In a real implementation, this would update the backend
    // For mock, we just simulate the delay
  }

  @override
  Future<DashboardData> refreshDashboard() async {
    // Same as getDashboardData but could have different logic
    return getDashboardData();
  }
}
