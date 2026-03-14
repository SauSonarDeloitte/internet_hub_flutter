import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/dashboard_data.dart' as dashboard;
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import 'notification_widget.dart';

class NotificationPanel extends StatelessWidget {
  final List<dashboard.Notification> notifications;

  const NotificationPanel({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final displayedNotifications = notifications.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Notifications',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (notifications.isEmpty)
          const Center(child: Text('No new notifications'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedNotifications.length,
            itemBuilder: (context, index) {
              final notification = displayedNotifications[index];
              return NotificationWidget(
                notification: notification,
                onTap: () {
                  context
                      .read<DashboardBloc>()
                      .add(MarkNotificationRead(notification.id));
                },
              );
            },
          ),
        if (notifications.length > 10)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('View all'),
            ),
          ),
      ],
    );
  }
}
