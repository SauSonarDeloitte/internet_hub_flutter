import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_hub_flutter/features/dashboard/widgets/service_grid.dart';

/// Pumps ServiceGrid with a specific logical width by setting the test surface size.
Future<void> _pumpServiceGrid(
  WidgetTester tester, {
  double width = 1200,
  double height = 2000,
}) async {
  // Set the surface size so LayoutBuilder inside ServiceGrid sees the right width.
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: const ServiceGrid(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  // ---------------------------------------------------------------------------
  // Task 6.1 — ServiceGrid filter: empty query, partial match, no match
  // ---------------------------------------------------------------------------
  group('ServiceGrid filter (6.1)', () {
    testWidgets('empty query returns all 12 tiles', (tester) async {
      await _pumpServiceGrid(tester);

      // 12 service tiles — each is an InkWell inside the GridView
      final gridFinder = find.byType(GridView);
      expect(gridFinder, findsOneWidget);
      final inkWells = tester
          .widgetList<InkWell>(
            find.descendant(of: gridFinder, matching: find.byType(InkWell)),
          )
          .toList();
      expect(inkWells.length, 12);
    });

    testWidgets('partial match "leave" returns subset', (tester) async {
      await _pumpServiceGrid(tester);

      await tester.enterText(find.byType(TextField), 'leave');
      await tester.pump();

      expect(find.text('Leave/Attendance'), findsOneWidget);

      final gridFinder = find.byType(GridView);
      expect(gridFinder, findsOneWidget);
      final inkWells = tester
          .widgetList<InkWell>(
            find.descendant(of: gridFinder, matching: find.byType(InkWell)),
          )
          .toList();
      expect(inkWells.length, lessThan(12));
    });

    testWidgets('no match returns empty state', (tester) async {
      await _pumpServiceGrid(tester);

      await tester.enterText(find.byType(TextField), 'zzznomatch');
      await tester.pump();

      expect(find.text('No services found'), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // Task 6.6 — ServiceGrid crossAxisCount at 320, 650, 950
  // ---------------------------------------------------------------------------
  group('ServiceGrid crossAxisCount (6.6)', () {
    Future<int> getCrossAxisCount(WidgetTester tester, double width) async {
      await _pumpServiceGrid(tester, width: width);

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate
          as SliverGridDelegateWithFixedCrossAxisCount;
      return delegate.crossAxisCount;
    }

    testWidgets('width 320 → crossAxisCount 2', (tester) async {
      final count = await getCrossAxisCount(tester, 320);
      expect(count, 2);
    });

    testWidgets('width 650 → crossAxisCount 3', (tester) async {
      final count = await getCrossAxisCount(tester, 650);
      expect(count, 3);
    });

    testWidgets('width 950 → crossAxisCount 4', (tester) async {
      final count = await getCrossAxisCount(tester, 950);
      expect(count, 4);
    });
  });

  // ---------------------------------------------------------------------------
  // Task 6.7 — Search filter property: displayed tiles match query (case-insensitive)
  // **Validates: Requirements 3**
  // ---------------------------------------------------------------------------
  group('ServiceGrid search filter property (6.7)', () {
    final queries = ['team', 'pol', 'LEAVE', 'Travel', 'bolt', 'doc'];

    for (final query in queries) {
      testWidgets(
          'query "$query" — all displayed tiles contain it (case-insensitive)',
          (tester) async {
        await _pumpServiceGrid(tester);

        await tester.enterText(find.byType(TextField), query);
        await tester.pump();

        final gridFinder = find.byType(GridView);
        if (gridFinder.evaluate().isEmpty) {
          // No match — acceptable (empty result)
          return;
        }

        final textWidgets = tester
            .widgetList<Text>(
              find.descendant(of: gridFinder, matching: find.byType(Text)),
            )
            .toList();

        expect(textWidgets, isNotEmpty);
        for (final textWidget in textWidgets) {
          expect(
            textWidget.data!.toLowerCase().contains(query.toLowerCase()),
            isTrue,
            reason:
                'Tile label "${textWidget.data}" does not contain query "$query"',
          );
        }
      });
    }
  });

  // ---------------------------------------------------------------------------
  // Task 6.10 — Tapping Documents tile shows download dialog
  // ---------------------------------------------------------------------------
  group('ServiceGrid Documents dialog (6.10)', () {
    testWidgets('tapping Documents tile shows AlertDialog with download options',
        (tester) async {
      // Use a large surface so Documents tile is visible and tappable
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 1200,
                  child: const ServiceGrid(),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/team-directory',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/policies',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/benefits',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/leave-attendance',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/compensation',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/recognition',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/ayush-health',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/holiday-calendar',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/documents',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/travel',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/bolt',
            builder: (context, state) => const Scaffold(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Scaffold(),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pump();

      await tester.tap(find.text('Documents'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('About Bajaj Auto'), findsOneWidget);
      expect(find.text('Code of Conduct'), findsOneWidget);
    });
  });
}
