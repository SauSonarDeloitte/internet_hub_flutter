import 'package:flutter/material.dart';
import '../route/route_names.dart';
import 'models/menu_item.dart';
import 'models/menu_section.dart';

/// Central configuration for the app menu structure
class MenuConfig {
  static const MenuItem dashboardItem = MenuItem(
    id: 'dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard,
    route: RouteNames.dashboard,
  );

  static final MenuSection employeeServicesSection = MenuSection(
    id: 'employee_services',
    title: 'Employee Services',
    items: [
      const MenuItem(
        id: 'team_directory',
        label: 'Team Directory',
        icon: Icons.people,
        route: RouteNames.teamDirectory,
      ),
      const MenuItem(
        id: 'policies',
        label: 'Policies',
        icon: Icons.policy,
        route: RouteNames.policies,
      ),
      const MenuItem(
        id: 'benefits',
        label: 'Benefits',
        icon: Icons.card_giftcard,
        route: RouteNames.benefits,
      ),
      const MenuItem(
        id: 'travel',
        label: 'Travel',
        icon: Icons.flight,
        route: RouteNames.travel,
      ),
      const MenuItem(
        id: 'leave_attendance',
        label: 'Leave/Attendance',
        icon: Icons.calendar_today,
        route: RouteNames.leaveAttendance,
      ),
      const MenuItem(
        id: 'compensation',
        label: 'Compensation',
        icon: Icons.attach_money,
        route: RouteNames.compensation,
      ),
      const MenuItem(
        id: 'recognition',
        label: 'Recognition',
        icon: Icons.emoji_events,
        route: RouteNames.recognition,
      ),
      const MenuItem(
        id: 'bolt',
        label: 'Bolt',
        icon: Icons.bolt,
        route: RouteNames.bolt,
      ),
      const MenuItem(
        id: 'ayush_health',
        label: 'Ayush Health',
        icon: Icons.health_and_safety,
        route: RouteNames.ayushHealth,
      ),
      const MenuItem(
        id: 'holiday_calendar',
        label: 'Holiday Calendar',
        icon: Icons.event,
        route: RouteNames.holidayCalendar,
      ),
      const MenuItem(
        id: 'documents',
        label: 'Documents',
        icon: Icons.folder,
        route: RouteNames.documents,
      ),
    ],
  );

  static final MenuSection companyResourcesSection = MenuSection(
    id: 'company_resources',
    title: 'Company Resources',
    items: [
      const MenuItem(
        id: 'it_resources',
        label: 'IT Resources',
        icon: Icons.computer,
        route: RouteNames.itResources,
      ),
      const MenuItem(
        id: 'map',
        label: 'Map',
        icon: Icons.map,
        route: RouteNames.map,
      ),
      const MenuItem(
        id: 'emergency_contacts',
        label: 'Emergency Contacts',
        icon: Icons.emergency,
        route: RouteNames.emergencyContacts,
      ),
      const MenuItem(
        id: 'company_overview',
        label: 'Company Overview',
        icon: Icons.business,
        route: RouteNames.companyOverview,
      ),
    ],
  );

  /// Get all menu sections
  static List<MenuSection> getAllSections() {
    return [
      employeeServicesSection,
      companyResourcesSection,
    ];
  }

  /// Get all menu items (flattened)
  static List<MenuItem> getAllItems() {
    return [
      dashboardItem,
      ...employeeServicesSection.items,
      ...companyResourcesSection.items,
    ];
  }
}
