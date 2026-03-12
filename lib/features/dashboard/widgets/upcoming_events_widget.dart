import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_data.dart';

class UpcomingEventsWidget extends StatelessWidget {
  final List<UpcomingEvent> events;

  const UpcomingEventsWidget({
    super.key,
    required this.events,
  });

  IconData _getIconForType(EventType type) {
    switch (type) {
      case EventType.holiday:
        return Icons.celebration;
      case EventType.birthday:
        return Icons.cake;
      case EventType.anniversary:
        return Icons.emoji_events;
      case EventType.meeting:
        return Icons.meeting_room;
      case EventType.deadline:
        return Icons.alarm;
      case EventType.other:
        return Icons.event;
    }
  }

  Color _getColorForType(EventType type) {
    switch (type) {
      case EventType.holiday:
        return Colors.red;
      case EventType.birthday:
        return Colors.pink;
      case EventType.anniversary:
        return Colors.amber;
      case EventType.meeting:
        return Colors.blue;
      case EventType.deadline:
        return Colors.orange;
      case EventType.other:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference < 7) {
      return 'in $difference days';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Events',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length > 5 ? 5 : events.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final event = events[index];
                final iconColor = _getColorForType(event.type);

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: iconColor.withValues(alpha: 0.2),
                      child: Icon(
                        _getIconForType(event.type),
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: theme.textTheme.titleSmall,
                          ),
                          if (event.description != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              event.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      _formatDate(event.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
