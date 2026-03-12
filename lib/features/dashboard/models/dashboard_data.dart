import 'package:equatable/equatable.dart';

/// Dashboard data model containing all dashboard information
class DashboardData extends Equatable {
  final UserSummary userSummary;
  final List<QuickAccessCard> quickAccessCards;
  final List<Notification> notifications;
  final List<ActivityItem> activityFeed;
  final LeaveBalance leaveBalance;
  final List<UpcomingEvent> upcomingEvents;

  const DashboardData({
    required this.userSummary,
    required this.quickAccessCards,
    required this.notifications,
    required this.activityFeed,
    required this.leaveBalance,
    required this.upcomingEvents,
  });

  @override
  List<Object?> get props => [
        userSummary,
        quickAccessCards,
        notifications,
        activityFeed,
        leaveBalance,
        upcomingEvents,
      ];
}

/// User summary information
class UserSummary extends Equatable {
  final String name;
  final String designation;
  final String department;
  final String employeeId;
  final String? avatarUrl;

  const UserSummary({
    required this.name,
    required this.designation,
    required this.department,
    required this.employeeId,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, designation, department, employeeId, avatarUrl];
}

/// Quick access card model
class QuickAccessCard extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String route;
  final int? badgeCount;

  const QuickAccessCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.badgeCount,
  });

  @override
  List<Object?> get props => [id, title, subtitle, icon, route, badgeCount];
}

/// Notification model
class Notification extends Equatable {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionRoute;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionRoute,
  });

  @override
  List<Object?> get props => [id, title, message, timestamp, type, isRead, actionRoute];
}

enum NotificationType {
  info,
  success,
  warning,
  error,
  announcement,
}

/// Activity feed item
class ActivityItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final String? actorName;
  final String? actorAvatar;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.actorName,
    this.actorAvatar,
  });

  @override
  List<Object?> get props => [id, title, description, timestamp, type, actorName, actorAvatar];
}

enum ActivityType {
  leave,
  travel,
  recognition,
  policy,
  document,
  announcement,
  other,
}

/// Leave balance summary
class LeaveBalance extends Equatable {
  final double totalLeaves;
  final double usedLeaves;
  final double pendingLeaves;
  final double availableLeaves;

  const LeaveBalance({
    required this.totalLeaves,
    required this.usedLeaves,
    required this.pendingLeaves,
    required this.availableLeaves,
  });

  @override
  List<Object?> get props => [totalLeaves, usedLeaves, pendingLeaves, availableLeaves];
}

/// Upcoming event model
class UpcomingEvent extends Equatable {
  final String id;
  final String title;
  final DateTime date;
  final EventType type;
  final String? description;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, date, type, description];
}

enum EventType {
  holiday,
  birthday,
  anniversary,
  meeting,
  deadline,
  other,
}
