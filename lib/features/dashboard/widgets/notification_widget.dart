import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_data.dart' as dashboard;

class NotificationWidget extends StatelessWidget {
  final dashboard.Notification notification;
  final VoidCallback? onTap;

  const NotificationWidget({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData _getIconForType(dashboard.NotificationType type) {
    switch (type) {
      case dashboard.NotificationType.success:
        return Icons.check_circle;
      case dashboard.NotificationType.warning:
        return Icons.warning;
      case dashboard.NotificationType.error:
        return Icons.error;
      case dashboard.NotificationType.announcement:
        return Icons.campaign;
      case dashboard.NotificationType.info:
        return Icons.info;
    }
  }

  Color _getColorForType(dashboard.NotificationType type, ColorScheme colorScheme) {
    switch (type) {
      case dashboard.NotificationType.success:
        return Colors.green;
      case dashboard.NotificationType.warning:
        return Colors.orange;
      case dashboard.NotificationType.error:
        return colorScheme.error;
      case dashboard.NotificationType.announcement:
        return Colors.blue;
      case dashboard.NotificationType.info:
        return colorScheme.primary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconColor = _getColorForType(notification.type, colorScheme);

    return Card(
      elevation: notification.isRead ? 0 : 1,
      color: notification.isRead ? null : colorScheme.primaryContainer.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () {
          onTap?.call();
          if (notification.actionRoute != null) {
            context.go(notification.actionRoute!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _getIconForType(notification.type),
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
