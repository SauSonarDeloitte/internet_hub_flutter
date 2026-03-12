import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/layout/app_shell.dart';
import '../../../utils/di/service_locator.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/quick_access_card_widget.dart';
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
                    // Welcome section
                    _buildWelcomeSection(context, data.userSummary),
                    const SizedBox(height: 24),

                    // Quick access cards
                    _buildSectionTitle(context, 'Quick Access'),
                    const SizedBox(height: 12),
                    _buildQuickAccessGrid(context, data.quickAccessCards),
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

  Widget _buildQuickAccessGrid(BuildContext context, List quickAccessCards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: quickAccessCards.length,
          itemBuilder: (context, index) {
            return QuickAccessCardWidget(card: quickAccessCards[index]);
          },
        );
      },
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
}

