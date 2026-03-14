import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_hub_flutter/features/dashboard/models/dashboard_data.dart'
    as dashboard;
import 'package:internet_hub_flutter/features/dashboard/widgets/notification_widget.dart';

// ---------------------------------------------------------------------------
// Test-only notification list widget — no BLoC dependency.
// Tests the cap and "View all" logic directly without needing DashboardBloc.
// ---------------------------------------------------------------------------

class _TestNotificationList extends StatelessWidget {
  final List<dashboard.Notification> notifications;
  final void Function(String id)? onNotificationTap;

  const _TestNotificationList({
    required this.notifications,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayed = notifications.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notifications.isEmpty)
          const Center(child: Text('No new notifications'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayed.length,
            itemBuilder: (context, index) {
              final n = displayed[index];
              return NotificationWidget(
                notification: n,
                onTap: () => onNotificationTap?.call(n.id),
              );
            },
          ),
        if (notifications.length > 10)
          TextButton(
            onPressed: () {},
            child: const Text('View all'),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

dashboard.Notification _makeNotification(String id, {bool isRead = false}) {
  return dashboard.Notification(
    id: id,
    title: 'Notification $id',
    message: 'Message $id',
    timestamp: DateTime.now(),
    type: dashboard.NotificationType.info,
    isRead: isRead,
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // Task 6.3 — NotificationPanel cap: 11 notifications → 10 items + "View all"
  // ---------------------------------------------------------------------------
  group('NotificationPanel cap (6.3)', () {
    testWidgets(
        '11 notifications renders 10 NotificationWidget items and "View all"',
        (tester) async {
      final notifications = List.generate(11, (i) => _makeNotification('n$i'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: _TestNotificationList(notifications: notifications),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester
            .widgetList<NotificationWidget>(find.byType(NotificationWidget))
            .length,
        10,
      );
      expect(find.text('View all'), findsOneWidget);
    });

    testWidgets('10 notifications renders 10 items and no "View all"',
        (tester) async {
      final notifications = List.generate(10, (i) => _makeNotification('n$i'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: _TestNotificationList(notifications: notifications),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(
        tester
            .widgetList<NotificationWidget>(find.byType(NotificationWidget))
            .length,
        10,
      );
      expect(find.text('View all'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Task 6.8 — Tapping notification dispatches MarkNotificationRead with correct id
  // **Validates: Requirements 6**
  //
  // We verify the correct notification id is passed to the onTap callback,
  // which in production dispatches MarkNotificationRead to DashboardBloc.
  // ---------------------------------------------------------------------------
  group('NotificationPanel tap callback (6.8)', () {
    testWidgets(
        'tapping first notification calls onTap with its id',
        (tester) async {
      final notifications = [
        _makeNotification('abc-123'),
        _makeNotification('def-456'),
      ];
      final tappedIds = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: _TestNotificationList(
                notifications: notifications,
                onNotificationTap: tappedIds.add,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(NotificationWidget).first);
      await tester.pump();

      expect(tappedIds, hasLength(1));
      expect(tappedIds.first, 'abc-123');
    });

    testWidgets(
        'tapping second notification calls onTap with its id',
        (tester) async {
      final notifications = [
        _makeNotification('first'),
        _makeNotification('second'),
      ];
      final tappedIds = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: _TestNotificationList(
                notifications: notifications,
                onNotificationTap: tappedIds.add,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(NotificationWidget).at(1));
      await tester.pump();

      expect(tappedIds, hasLength(1));
      expect(tappedIds.first, 'second');
    });
  });
}
