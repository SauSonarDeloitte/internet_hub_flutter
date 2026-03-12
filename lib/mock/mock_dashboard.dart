import '../features/dashboard/models/dashboard_data.dart';
import '../core/route/route_names.dart';

class MockDashboard {
  /// Generate mock dashboard data
  static DashboardData generateDashboardData({
    required String userName,
    required String userDesignation,
    required String userDepartment,
    required String employeeId,
  }) {
    return DashboardData(
      userSummary: UserSummary(
        name: userName,
        designation: userDesignation,
        department: userDepartment,
        employeeId: employeeId,
      ),
      quickAccessCards: _generateQuickAccessCards(),
      notifications: _generateNotifications(),
      activityFeed: _generateActivityFeed(),
      leaveBalance: _generateLeaveBalance(),
      upcomingEvents: _generateUpcomingEvents(),
    );
  }

  static List<QuickAccessCard> _generateQuickAccessCards() {
    return [
      QuickAccessCard(
        id: '1',
        title: 'Apply Leave',
        subtitle: 'Request time off',
        icon: 'event_available',
        route: RouteNames.leaveAttendance,
        badgeCount: null,
      ),
      QuickAccessCard(
        id: '2',
        title: 'Team Directory',
        subtitle: 'Find colleagues',
        icon: 'people',
        route: RouteNames.teamDirectory,
      ),
      QuickAccessCard(
        id: '3',
        title: 'Policies',
        subtitle: '3 pending reviews',
        icon: 'policy',
        route: RouteNames.policies,
        badgeCount: 3,
      ),
      QuickAccessCard(
        id: '4',
        title: 'Documents',
        subtitle: 'View & upload',
        icon: 'folder',
        route: RouteNames.documents,
      ),
      QuickAccessCard(
        id: '5',
        title: 'Travel',
        subtitle: 'Book & manage',
        icon: 'flight',
        route: RouteNames.travel,
      ),
      QuickAccessCard(
        id: '6',
        title: 'Benefits',
        subtitle: 'Explore perks',
        icon: 'card_giftcard',
        route: RouteNames.benefits,
      ),
    ];
  }

  static List<Notification> _generateNotifications() {
    final now = DateTime.now();
    return [
      Notification(
        id: '1',
        title: 'Leave Approved',
        message: 'Your leave request for March 15-17 has been approved.',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: NotificationType.success,
        isRead: false,
        actionRoute: RouteNames.leaveAttendance,
      ),
      Notification(
        id: '2',
        title: 'New Policy Update',
        message: 'Remote Work Policy has been updated. Please review.',
        timestamp: now.subtract(const Duration(hours: 5)),
        type: NotificationType.info,
        isRead: false,
        actionRoute: RouteNames.policies,
      ),
      Notification(
        id: '3',
        title: 'Upcoming Holiday',
        message: 'Office will be closed on March 20 for Holi.',
        timestamp: now.subtract(const Duration(days: 1)),
        type: NotificationType.announcement,
        isRead: true,
        actionRoute: RouteNames.holidayCalendar,
      ),
      Notification(
        id: '4',
        title: 'Travel Request Pending',
        message: 'Your travel request to Mumbai requires additional approval.',
        timestamp: now.subtract(const Duration(days: 2)),
        type: NotificationType.warning,
        isRead: true,
        actionRoute: RouteNames.travel,
      ),
      Notification(
        id: '5',
        title: 'Recognition Received',
        message: 'You received a "Team Player" badge from Sarah Johnson!',
        timestamp: now.subtract(const Duration(days: 3)),
        type: NotificationType.success,
        isRead: true,
        actionRoute: RouteNames.recognition,
      ),
    ];
  }

  static List<ActivityItem> _generateActivityFeed() {
    final now = DateTime.now();
    return [
      ActivityItem(
        id: '1',
        title: 'Leave Approved',
        description: 'Your leave request for March 15-17 was approved by John Smith',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: ActivityType.leave,
        actorName: 'John Smith',
      ),
      ActivityItem(
        id: '2',
        title: 'New Document Uploaded',
        description: 'Q4 2025 Performance Review document is now available',
        timestamp: now.subtract(const Duration(hours: 4)),
        type: ActivityType.document,
      ),
      ActivityItem(
        id: '3',
        title: 'Policy Acknowledged',
        description: 'You acknowledged the Remote Work Policy v2.0',
        timestamp: now.subtract(const Duration(hours: 6)),
        type: ActivityType.policy,
      ),
      ActivityItem(
        id: '4',
        title: 'Recognition Received',
        description: 'Sarah Johnson gave you a "Team Player" badge',
        timestamp: now.subtract(const Duration(days: 1)),
        type: ActivityType.recognition,
        actorName: 'Sarah Johnson',
      ),
      ActivityItem(
        id: '5',
        title: 'Travel Booked',
        description: 'Flight to Mumbai on March 25 has been confirmed',
        timestamp: now.subtract(const Duration(days: 2)),
        type: ActivityType.travel,
      ),
      ActivityItem(
        id: '6',
        title: 'Company Announcement',
        description: 'All-hands meeting scheduled for March 30 at 10 AM',
        timestamp: now.subtract(const Duration(days: 3)),
        type: ActivityType.announcement,
      ),
      ActivityItem(
        id: '7',
        title: 'Leave Applied',
        description: 'You applied for leave on March 15-17',
        timestamp: now.subtract(const Duration(days: 5)),
        type: ActivityType.leave,
      ),
    ];
  }

  static LeaveBalance _generateLeaveBalance() {
    return const LeaveBalance(
      totalLeaves: 24.0,
      usedLeaves: 8.5,
      pendingLeaves: 2.0,
      availableLeaves: 13.5,
    );
  }

  static List<UpcomingEvent> _generateUpcomingEvents() {
    final now = DateTime.now();
    return [
      UpcomingEvent(
        id: '1',
        title: 'Holi',
        date: DateTime(now.year, 3, 20),
        type: EventType.holiday,
        description: 'Public Holiday',
      ),
      UpcomingEvent(
        id: '2',
        title: 'Sarah Johnson\'s Birthday',
        date: DateTime(now.year, 3, 18),
        type: EventType.birthday,
      ),
      UpcomingEvent(
        id: '3',
        title: 'Q1 Review Meeting',
        date: DateTime(now.year, 3, 25),
        type: EventType.meeting,
        description: 'Quarterly performance review',
      ),
      UpcomingEvent(
        id: '4',
        title: 'Project Deadline',
        date: DateTime(now.year, 3, 28),
        type: EventType.deadline,
        description: 'HR Portal Phase 3 completion',
      ),
      UpcomingEvent(
        id: '5',
        title: 'All-Hands Meeting',
        date: DateTime(now.year, 3, 30),
        type: EventType.meeting,
        description: 'Company-wide update',
      ),
    ];
  }
}
