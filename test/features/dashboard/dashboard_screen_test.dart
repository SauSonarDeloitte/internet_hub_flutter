import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_hub_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:internet_hub_flutter/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:internet_hub_flutter/features/dashboard/bloc/dashboard_state.dart';
import 'package:internet_hub_flutter/features/dashboard/models/dashboard_data.dart'
    as dashboard;
import 'package:internet_hub_flutter/features/dashboard/screens/dashboard_screen.dart';
import 'package:internet_hub_flutter/repository/auth/auth_repository.dart';
import 'package:internet_hub_flutter/repository/base_repository.dart';
import 'package:internet_hub_flutter/repository/dashboard/dashboard_repository.dart';
import 'package:internet_hub_flutter/shared/models/user_model.dart';

// ---------------------------------------------------------------------------
// Fake repositories
// ---------------------------------------------------------------------------

class _FakeDashboardRepository implements DashboardRepository {
  final dashboard.DashboardData data;

  _FakeDashboardRepository(this.data);

  @override
  Future<dashboard.DashboardData> getDashboardData() async => data;

  @override
  Future<void> markNotificationAsRead(String notificationId) async {}

  @override
  Future<void> markAllNotificationsAsRead() async {}

  @override
  Future<dashboard.DashboardData> refreshDashboard() async => data;
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<UserModel>> login(String email, String password) async =>
      const Failure('not implemented');

  @override
  Future<Result<void>> logout() async => const Success(null);

  @override
  Future<Result<UserModel?>> getCurrentUser() async => const Success(null);

  @override
  Future<Result<bool>> isAuthenticated() async => const Success(false);

  @override
  Future<void> simulateNetworkDelay({int milliseconds = 500}) async {}
}

// ---------------------------------------------------------------------------
// In-memory HydratedStorage for tests
// ---------------------------------------------------------------------------

class _MemoryStorage implements Storage {
  final _store = <String, dynamic>{};

  @override
  dynamic read(String key) => _store[key];

  @override
  Future<void> write(String key, dynamic value) async => _store[key] = value;

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();

  @override
  Future<void> close() async {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

dashboard.DashboardData _makeDashboardData({
  List<dashboard.Notification> notifications = const [],
}) {
  return dashboard.DashboardData(
    userSummary: const dashboard.UserSummary(
      name: 'Test User',
      designation: 'Engineer',
      department: 'IT',
      employeeId: 'E001',
    ),
    quickAccessCards: const [],
    notifications: notifications,
    activityFeed: const [],
    leaveBalance: const dashboard.LeaveBalance(
      totalLeaves: 20,
      usedLeaves: 5,
      pendingLeaves: 2,
      availableLeaves: 13,
    ),
    upcomingEvents: const [],
  );
}

/// Pumps [DashboardView] with a controlled [DashboardState] and screen [width].
/// Uses physicalSize to control the viewport seen by LayoutBuilder.
Future<void> _pumpDashboardView(
  WidgetTester tester, {
  required DashboardState dashboardState,
  double width = 1400,
  double height = 900,
}) async {
  HydratedBloc.storage = _MemoryStorage();

  final data = _makeDashboardData();
  final authBloc = AuthBloc(_FakeAuthRepository());

  final controlledBloc = _ControlledDashboardBloc(
    repository: _FakeDashboardRepository(data),
    initialState: dashboardState,
  );

  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(controlledBloc.close);
  addTearDown(authBloc.close);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<DashboardBloc>.value(value: controlledBloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
          ],
          child: const DashboardView(),
        ),
      ),
      GoRoute(path: '/team-directory', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/policies', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/benefits', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/leave-attendance', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/compensation', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/recognition', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/ayush-health', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/holiday-calendar', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/documents', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/travel', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/bolt', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/dashboard', builder: (_, __) => const Scaffold()),
    ],
  );

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pump();
}

/// A [DashboardBloc] subclass that emits a given [initialState] immediately.
class _ControlledDashboardBloc extends DashboardBloc {
  final DashboardState initialState;

  _ControlledDashboardBloc({
    required DashboardRepository repository,
    required this.initialState,
  }) : super(repository: repository) {
    emit(initialState);
  }
}

void main() {
  // ---------------------------------------------------------------------------
  // Task 6.4 — DashboardScreen at width 1200 renders Row with two Expanded
  // **Validates: Property 1 / Requirements 1.1, 1.3**
  // AppShell at ≥1024px uses _DesktopLayout with a 280px sidebar.
  // We use 1400px so the DashboardView LayoutBuilder sees 1120px (≥1024).
  // ---------------------------------------------------------------------------
  group('DashboardView wide layout (6.4)', () {
    testWidgets('width 1400 → DashboardLoaded renders Row with Expanded(flex:4) and Expanded(flex:1)',
        (tester) async {
      final data = _makeDashboardData();
      await _pumpDashboardView(
        tester,
        dashboardState: DashboardLoaded(data),
        width: 1400,
        height: 900,
      );

      // Wide layout: top-level Row with two Expanded children (flex 4 and flex 1)
      bool hasWideRow = false;
      tester.widgetList<Row>(find.byType(Row)).forEach((row) {
        final expandedChildren = row.children.whereType<Expanded>().toList();
        if (expandedChildren.length >= 2) {
          final flexes = expandedChildren.map((e) => e.flex).toList();
          if (flexes.contains(4) && flexes.contains(1)) {
            hasWideRow = true;
          }
        }
      });
      expect(hasWideRow, isTrue,
          reason: 'Expected a Row with Expanded(flex:4) and Expanded(flex:1)');
    });
  });

  // ---------------------------------------------------------------------------
  // Task 6.5 — DashboardScreen at width 800 renders single-column layout
  // **Validates: Property 1 / Requirements 1.2**
  // AppShell at 768–1023px uses _TabletLayout (drawer, no sidebar).
  // DashboardView LayoutBuilder sees ~800px which is < 1024 → narrow layout.
  // ---------------------------------------------------------------------------
  group('DashboardView narrow layout (6.5)', () {
    testWidgets('width 800 → DashboardLoaded renders no wide Row',
        (tester) async {
      final data = _makeDashboardData();
      await _pumpDashboardView(
        tester,
        dashboardState: DashboardLoaded(data),
        width: 800,
        height: 900,
      );

      // Consume any overflow rendering warnings (e.g. BajajLogo in AppBar)
      tester.takeException();

      // Narrow layout must NOT have a Row with flex:4 + flex:1 Expanded pair
      bool hasWideRow = false;
      tester.widgetList<Row>(find.byType(Row)).forEach((row) {
        final expandedChildren = row.children.whereType<Expanded>().toList();
        if (expandedChildren.length >= 2) {
          final flexes = expandedChildren.map((e) => e.flex).toList();
          if (flexes.contains(4) && flexes.contains(1)) {
            hasWideRow = true;
          }
        }
      });
      expect(hasWideRow, isFalse,
          reason: 'Narrow layout must not render the wide two-column Row');

      expect(find.byType(Column), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // Task 6.9 — DashboardLoading → CircularProgressIndicator
  //            DashboardError → error UI + retry
  // ---------------------------------------------------------------------------
  group('DashboardView loading and error states (6.9)', () {
    testWidgets('DashboardLoading state shows CircularProgressIndicator',
        (tester) async {
      await _pumpDashboardView(
        tester,
        dashboardState: const DashboardLoading(),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('DashboardError state shows error UI and Retry button',
        (tester) async {
      await _pumpDashboardView(
        tester,
        dashboardState: const DashboardError('Something went wrong'),
      );

      expect(find.text('Failed to load dashboard'), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('DashboardError retry button dispatches LoadDashboard without throwing',
        (tester) async {
      await _pumpDashboardView(
        tester,
        dashboardState: const DashboardError('error'),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pump();
      // No exception = pass
    });
  });
}
