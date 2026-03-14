import 'package:flutter/material.dart';
import '../models/dashboard_data.dart' as dashboard;
import 'notification_panel.dart';
import 'calendar_widget.dart';

class RightSidebar extends StatelessWidget {
  final List<dashboard.Notification> notifications;

  const RightSidebar({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NotificationPanel(notifications: notifications),
          const SizedBox(height: 16),
          const CalendarWidget(),
        ],
      ),
    );
  }
}
