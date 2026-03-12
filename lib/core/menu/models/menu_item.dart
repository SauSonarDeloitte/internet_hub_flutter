import 'package:flutter/material.dart';

/// Represents a single menu item in the navigation
class MenuItem {
  final String id;
  final String label;
  final IconData icon;
  final String route;
  final int? badgeCount;
  final bool isEnabled;

  const MenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.badgeCount,
    this.isEnabled = true,
  });

  MenuItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? route,
    int? badgeCount,
    bool? isEnabled,
  }) {
    return MenuItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      badgeCount: badgeCount ?? this.badgeCount,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
