import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:internet_hub_flutter/features/dashboard/widgets/calendar_widget.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Task 6.2 — CalendarWidget month navigation (Property 7)
  // Next then prev returns to original month
  // **Validates: Requirements 7**
  // ---------------------------------------------------------------------------
  group('CalendarWidget month navigation (6.2)', () {
    testWidgets('next then prev returns to original month', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: CalendarWidget()),
          ),
        ),
      );
      await tester.pump();

      // Capture the initial month label
      final now = DateTime.now();
      final initialLabel = DateFormat('MMMM yyyy').format(
        DateTime(now.year, now.month, 1),
      );

      expect(find.text(initialLabel), findsOneWidget);

      // Tap next month (chevron_right)
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();

      final nextMonth = DateTime(now.year, now.month + 1, 1);
      final nextLabel = DateFormat('MMMM yyyy').format(nextMonth);
      expect(find.text(nextLabel), findsOneWidget);

      // Tap prev month (chevron_left) — should return to original
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();

      expect(find.text(initialLabel), findsOneWidget);
    });

    testWidgets('multiple next/prev navigations return to original month',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: CalendarWidget()),
          ),
        ),
      );
      await tester.pump();

      final now = DateTime.now();
      final initialLabel = DateFormat('MMMM yyyy').format(
        DateTime(now.year, now.month, 1),
      );

      // Go forward 3 months
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump();
      }

      // Go back 3 months
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.chevron_left));
        await tester.pump();
      }

      expect(find.text(initialLabel), findsOneWidget);
    });
  });
}
