import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/layout/app_shell.dart';
import '../../../utils/di/service_locator.dart';
import '../../../core/route/route_names.dart';
import '../../../core/colors/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/notification_widget.dart';
import '../widgets/activity_feed_widget.dart';
import '../widgets/leave_balance_widget.dart';
import '../widgets/upcoming_events_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>()..add(const LoadDashboard()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Dashboard',
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load dashboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<DashboardBloc>().add(const LoadDashboard());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded || state is DashboardRefreshing) {
            final data = state is DashboardLoaded
                ? state.data
                : (state as DashboardRefreshing).data;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(const RefreshDashboard());
                // Wait for the refresh to complete
                await context.read<DashboardBloc>().stream.firstWhere(
                      (state) => state is DashboardLoaded || state is DashboardError,
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Important Action Buttons
                    _buildImportantActionButtons(context),
                    const SizedBox(height: 24),

                    // Welcome section
                    _buildWelcomeSection(context, data.userSummary),
                    const SizedBox(height: 24),

                    // Employee Self-Service Section
                    _buildSectionTitle(context, 'Employee Self-Service'),
                    const SizedBox(height: 12),
                    _buildEmployeeSelfServiceGrid(context),
                    const SizedBox(height: 24),

                    // Leave balance
                    LeaveBalanceWidget(leaveBalance: data.leaveBalance),
                    const SizedBox(height: 24),

                    // Notifications
                    _buildSectionTitle(context, 'Notifications'),
                    const SizedBox(height: 12),
                    _buildNotifications(context, data.notifications),
                    const SizedBox(height: 24),

                    // Upcoming events
                    UpcomingEventsWidget(events: data.upcomingEvents),
                    const SizedBox(height: 24),

                    // Activity feed
                    _buildSectionTitle(context, 'Recent Activity'),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ActivityFeedWidget(activities: data.activityFeed),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, userSummary) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final hour = now.hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                userSummary.name.substring(0, 1).toUpperCase(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    userSummary.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${userSummary.designation} • ${userSummary.department}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildNotifications(BuildContext context, List notifications) {
    final unreadNotifications = notifications.where((n) => !n.isRead).toList();
    final displayNotifications = unreadNotifications.isEmpty
        ? notifications.take(3).toList()
        : unreadNotifications.take(3).toList();

    if (displayNotifications.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 8),
                Text(
                  'No notifications',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...displayNotifications.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: NotificationWidget(
              notification: notification,
              onTap: () {
                context
                    .read<DashboardBloc>()
                    .add(MarkNotificationRead(notification.id));
              },
            ),
          ),
        ),
        if (notifications.length > 3)
          TextButton(
            onPressed: () {
              // TODO: Navigate to all notifications screen
            },
            child: const Text('View all notifications'),
          ),
      ],
    );
  }

  Widget _buildImportantActionButtons(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildActionButton(
              context,
              label: 'Integrity Matters! - Ethics Helpline',
              icon: Icons.security,
              onTap: () {
                // TODO: Navigate to Ethics Helpline or show dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ethics Helpline - Coming Soon')),
                );
              },
              isFullWidth: isSmallScreen,
            ),
            _buildActionButton(
              context,
              label: 'POSH (Prevention Of Sexual Harassment)',
              icon: Icons.shield,
              onTap: () {
                // TODO: Navigate to POSH or show dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('POSH - Coming Soon')),
                );
              },
              isFullWidth: isSmallScreen,
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brightWhite,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildEmployeeSelfServiceGrid(BuildContext context) {
    final services = [
      _ServiceOption(
        icon: Icons.people,
        label: 'Team Directory',
        route: RouteNames.teamDirectory,
      ),
      _ServiceOption(
        icon: Icons.policy,
        label: 'Policies',
        route: RouteNames.policies,
      ),
      _ServiceOption(
        icon: Icons.card_giftcard,
        label: 'Benefits',
        route: RouteNames.benefits,
      ),
      _ServiceOption(
        icon: Icons.event_available,
        label: 'Leave/Attendance',
        route: RouteNames.leaveAttendance,
      ),
      _ServiceOption(
        icon: Icons.attach_money,
        label: 'Compensation',
        route: RouteNames.compensation,
      ),
      _ServiceOption(
        icon: Icons.emoji_events,
        label: 'Recognition - GEM',
        route: RouteNames.recognition,
      ),
      _ServiceOption(
        icon: Icons.favorite,
        label: 'Health & Wellness',
        route: RouteNames.ayushHealth,
      ),
      _ServiceOption(
        icon: Icons.calendar_today,
        label: 'Holiday Calendar',
        route: RouteNames.holidayCalendar,
      ),
      _ServiceOption(
        icon: Icons.folder,
        label: 'Documents',
        route: RouteNames.documents,
        hasDownloadOptions: true,
      ),
      _ServiceOption(
        icon: Icons.flight,
        label: 'Travel',
        route: RouteNames.travel,
      ),
      _ServiceOption(
        icon: Icons.school,
        label: 'BOLT - Start Learning!',
        route: RouteNames.bolt,
      ),
      _ServiceOption(
        icon: Icons.lightbulb,
        label: 'Idea Management Portal',
        route: RouteNames.dashboard, // TODO: Add proper route
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return _buildServiceOptionCard(context, service);
          },
        );
      },
    );
  }

  Widget _buildServiceOptionCard(BuildContext context, _ServiceOption service) {
    return InkWell(
      onTap: () {
        if (service.hasDownloadOptions) {
          _showDocumentDownloadDialog(context);
        } else {
          context.go(service.route);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              service.icon,
              size: 48,
              color: AppColors.blue,
            ),
            const SizedBox(height: 12),
            Text(
              service.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Documents'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.blue),
              title: const Text('About Bajaj Auto'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading About Bajaj Auto...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.blue),
              title: const Text('Code of Conduct'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading Code of Conduct...')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ServiceOption {
  final IconData icon;
  final String label;
  final String route;
  final bool hasDownloadOptions;

  _ServiceOption({
    required this.icon,
    required this.label,
    required this.route,
    this.hasDownloadOptions = false,
  });
}

