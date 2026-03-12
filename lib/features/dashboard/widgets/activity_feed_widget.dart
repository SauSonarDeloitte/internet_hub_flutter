import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_data.dart';

class ActivityFeedWidget extends StatelessWidget {
  final List<ActivityItem> activities;

  const ActivityFeedWidget({
    super.key,
    required this.activities,
  });

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.leave:
        return Icons.event_available;
      case ActivityType.travel:
        return Icons.flight;
      case ActivityType.recognition:
        return Icons.emoji_events;
      case ActivityType.policy:
        return Icons.policy;
      case ActivityType.document:
        return Icons.description;
      case ActivityType.announcement:
        return Icons.campaign;
      case ActivityType.other:
        return Icons.info;
    }
  }

  Color _getColorForType(ActivityType type) {
    switch (type) {
      case ActivityType.leave:
        return Colors.blue;
      case ActivityType.travel:
        return Colors.purple;
      case ActivityType.recognition:
        return Colors.amber;
      case ActivityType.policy:
        return Colors.teal;
      case ActivityType.document:
        return Colors.orange;
      case ActivityType.announcement:
        return Colors.red;
      case ActivityType.other:
        return Colors.grey;
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

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final activity = activities[index];
        final iconColor = _getColorForType(activity.type);

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.2),
            child: Icon(
              _getIconForType(activity.type),
              color: iconColor,
              size: 20,
            ),
          ),
          title: Text(
            activity.title,
            style: theme.textTheme.titleSmall,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                activity.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(activity.timestamp),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
