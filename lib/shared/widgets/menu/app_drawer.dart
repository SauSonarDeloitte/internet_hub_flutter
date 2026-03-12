import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/menu/menu_config.dart';
import '../../../core/route/route_names.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../features/auth/bloc/auth_event.dart';
import '../../../features/auth/bloc/auth_state.dart';
import '../../../utils/debug/debug_utils.dart';
import 'menu_item_widget.dart';
import 'menu_section_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // User profile header
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final user = state is AuthAuthenticated ? state.user : null;
                
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        fontSize: 32,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  accountName: Text(
                    user?.name ?? 'User',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                );
              },
            ),

            // Dashboard item
            MenuItemWidget(
              item: MenuConfig.dashboardItem,
              isSelected: currentRoute == RouteNames.dashboard,
            ),
            const Divider(),

            // Menu sections
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: MenuConfig.getAllSections()
                    .map(
                      (section) => MenuSectionWidget(
                        section: section,
                        currentRoute: currentRoute,
                      ),
                    )
                    .toList(),
              ),
            ),

            // Logout button
            const Divider(),
            
            // Debug section (only visible in debug mode)
            if (DebugUtils.isDebugMode) ...[
              ListTile(
                leading: const Icon(Icons.terminal),
                title: const Text('Developer Logs'),
                onTap: () {
                  // Close drawer using Scaffold.closeDrawer() instead of Navigator.pop()
                  // This avoids conflicts with GoRouter's navigation stack
                  Scaffold.of(context).closeDrawer();
                  // Then navigate after the current frame completes
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.push(RouteNames.talkerScreen);
                  });
                },
              ),
              const Divider(),
            ],
            
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Don't call Navigator.pop() - GoRouter will handle navigation via redirect
                // Just trigger logout and let the router redirect to login automatically
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
}
