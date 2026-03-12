import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../core/route/route_names.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/team_directory/screens/team_directory_screen.dart';
import '../../features/policies/screens/policies_screen.dart';
import '../../features/benefits/screens/benefits_screen.dart';
import '../../features/travel/screens/travel_screen.dart';
import '../../features/leave_attendance/screens/leave_attendance_screen.dart';
import '../../features/compensation/screens/compensation_screen.dart';
import '../../features/recognition/screens/recognition_screen.dart';
import '../../features/bolt/screens/bolt_screen.dart';
import '../../features/ayush_health/screens/ayush_health_screen.dart';
import '../../features/holiday_calendar/screens/holiday_calendar_screen.dart';
import '../../features/documents/screens/documents_screen.dart';
import '../../features/it_resources/screens/it_resources_screen.dart';
import '../../features/map/screens/map_screen.dart';
import '../../features/emergency_contacts/screens/emergency_contacts_screen.dart';
import '../../features/company_overview/screens/company_overview_screen.dart';
import '../logger/talker_config.dart';
import '../debug/debug_utils.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: RouteNames.dashboard,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isGoingToLogin = state.matchedLocation == RouteNames.login;
        final isGoingToTalker = state.matchedLocation == RouteNames.talkerScreen;

        TalkerConfig.debug(
          'Router redirect - Auth: $isAuthenticated, Location: ${state.matchedLocation}',
        );

        // Allow access to Talker screen in debug mode without authentication
        if (isGoingToTalker && DebugUtils.isDebugMode) {
          TalkerConfig.debug('Allowing access to Talker screen (debug mode)');
          return null;
        }

        // If not authenticated and not going to login, redirect to login
        if (!isAuthenticated && !isGoingToLogin) {
          TalkerConfig.debug('Redirecting to login');
          return RouteNames.login;
        }

        // If authenticated and going to login, redirect to dashboard
        if (isAuthenticated && isGoingToLogin) {
          TalkerConfig.debug('Redirecting to dashboard');
          return RouteNames.dashboard;
        }

        // No redirect needed
        return null;
      },
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      routes: [
        // Auth routes
        GoRoute(
          path: RouteNames.login,
          name: 'login',
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
        ),
        
        // Dashboard (home)
        GoRoute(
          path: RouteNames.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        
        // Employee Services
        GoRoute(
          path: RouteNames.teamDirectory,
          name: 'team_directory',
          builder: (context, state) => const TeamDirectoryScreen(),
        ),
        GoRoute(
          path: RouteNames.policies,
          name: 'policies',
          builder: (context, state) => const PoliciesScreen(),
        ),
        GoRoute(
          path: RouteNames.benefits,
          name: 'benefits',
          builder: (context, state) => const BenefitsScreen(),
        ),
        GoRoute(
          path: RouteNames.travel,
          name: 'travel',
          builder: (context, state) => const TravelScreen(),
        ),
        GoRoute(
          path: RouteNames.leaveAttendance,
          name: 'leave_attendance',
          builder: (context, state) => const LeaveAttendanceScreen(),
        ),
        GoRoute(
          path: RouteNames.compensation,
          name: 'compensation',
          builder: (context, state) => const CompensationScreen(),
        ),
        GoRoute(
          path: RouteNames.recognition,
          name: 'recognition',
          builder: (context, state) => const RecognitionScreen(),
        ),
        GoRoute(
          path: RouteNames.bolt,
          name: 'bolt',
          builder: (context, state) => const BoltScreen(),
        ),
        GoRoute(
          path: RouteNames.ayushHealth,
          name: 'ayush_health',
          builder: (context, state) => const AyushHealthScreen(),
        ),
        GoRoute(
          path: RouteNames.holidayCalendar,
          name: 'holiday_calendar',
          builder: (context, state) => const HolidayCalendarScreen(),
        ),
        GoRoute(
          path: RouteNames.documents,
          name: 'documents',
          builder: (context, state) => const DocumentsScreen(),
        ),
        
        // Company Resources
        GoRoute(
          path: RouteNames.itResources,
          name: 'it_resources',
          builder: (context, state) => const ItResourcesScreen(),
        ),
        GoRoute(
          path: RouteNames.map,
          name: 'map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: RouteNames.emergencyContacts,
          name: 'emergency_contacts',
          builder: (context, state) => const EmergencyContactsScreen(),
        ),
        GoRoute(
          path: RouteNames.companyOverview,
          name: 'company_overview',
          builder: (context, state) => const CompanyOverviewScreen(),
        ),
        
        // Debug routes (only accessible in debug mode)
        if (DebugUtils.isDebugMode)
          GoRoute(
            path: RouteNames.talkerScreen,
            name: 'talker_screen',
            builder: (context, state) => TalkerScreen(
              talker: TalkerConfig.instance,
              theme: const TalkerScreenTheme(
                backgroundColor: Color(0xFF1E1E1E),
                textColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

/// Helper class to refresh GoRouter when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
