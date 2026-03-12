import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/menu/models/menu_item.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final bool isSelected;

  const MenuItemWidget({
    super.key,
    required this.item,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        item.label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: item.badgeCount != null && item.badgeCount! > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.badgeCount! > 99 ? '99+' : '${item.badgeCount}',
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      selected: isSelected,
      enabled: item.isEnabled,
      onTap: item.isEnabled
          ? () {
              context.go(item.route);
              // Close drawer on mobile
              if (Scaffold.of(context).hasDrawer) {
                Navigator.of(context).pop();
              }
            }
          : null,
    );
  }
}
