import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/route/route_names.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../features/auth/bloc/auth_event.dart';
import '../../../features/auth/bloc/auth_state.dart';
import '../../../utils/debug/debug_utils.dart';
import '../menu/app_drawer.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String title;

  const AppShell({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1024;

        if (isDesktop) {
          return _DesktopLayout(title: title, child: child);
        } else if (isTablet) {
          return _TabletLayout(title: title, child: child);
        } else {
          return _MobileLayout(title: title, child: child);
        }
      },
    );
  }
}

/// Desktop layout with permanent sidebar
class _DesktopLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const _DesktopLayout({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Permanent sidebar
          SizedBox(
            width: 280,
            child: AppDrawer(),
          ),
          VerticalDivider(
            width: 1,
            thickness: 0,
            color: Colors.transparent,
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                _AppBar(title: title, showMenuButton: false),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tablet layout with rail navigation
class _TabletLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const _TabletLayout({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: const [_UserProfileButton()],
      ),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}

/// Mobile layout with drawer
class _MobileLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const _MobileLayout({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: const [_UserProfileButton()],
      ),
      drawer: const AppDrawer(),
      body: child,
    );
  }
}

/// Common app bar for layouts
class _AppBar extends StatelessWidget {
  final String title;
  final bool showMenuButton;

  const _AppBar({
    required this.title,
    this.showMenuButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenuButton)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          const SizedBox(width: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Spacer(),
          // Debug button (only visible in debug mode)
          if (DebugUtils.isDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              tooltip: 'Developer Logs',
              onPressed: () {
                context.push(RouteNames.talkerScreen);
              },
            ),
          const _UserProfileButton(),
        ],
      ),
    );
  }
}

/// User profile button in app bar
class _UserProfileButton extends StatelessWidget {
  const _UserProfileButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        
        return PopupMenuButton<String>(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  user?.name ?? 'User',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'logout') {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            }
            // TODO: Handle profile and settings navigation
          },
        );
      },
    );
  }
}
