import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/widgets/layout/app_shell.dart';
import '../../../utils/di/service_locator.dart';
import '../../../core/colors/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../models/dashboard_data.dart';
import '../widgets/activity_feed_widget.dart';
import '../widgets/leave_balance_widget.dart';
import '../widgets/upcoming_events_widget.dart';
import '../widgets/service_grid.dart';
import '../widgets/right_sidebar.dart';

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

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1024) {
                  return _buildWideLayout(context, data);
                } else {
                  return _buildNarrowLayout(context, data);
                }
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<DashboardBloc>().add(const RefreshDashboard());
    await context.read<DashboardBloc>().stream.firstWhere(
          (s) => s is DashboardLoaded || s is DashboardError,
        );
  }

  Widget _buildWideLayout(BuildContext context, DashboardData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: _buildMainContent(context, data),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: RightSidebar(notifications: data.notifications),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context, DashboardData data) {
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainContent(context, data),
            RightSidebar(notifications: data.notifications),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, DashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImportantActionButtons(context),
        const SizedBox(height: 24),
        _buildWelcomeSection(context, data.userSummary),
        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Employee Self-Service'),
        const Divider(),
        const SizedBox(height: 12),
        const ServiceGrid(),
        const SizedBox(height: 24),
        LeaveBalanceWidget(leaveBalance: data.leaveBalance),
        const SizedBox(height: 24),
        UpcomingEventsWidget(events: data.upcomingEvents),
        const SizedBox(height: 24),
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
    );
  }

  Widget _buildWelcomeSection(BuildContext context, UserSummary userSummary) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

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
}
