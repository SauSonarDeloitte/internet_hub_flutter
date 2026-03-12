import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/dashboard_data.dart';

class QuickAccessCardWidget extends StatelessWidget {
  final QuickAccessCard card;

  const QuickAccessCardWidget({
    super.key,
    required this.card,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'event_available':
        return Icons.event_available;
      case 'people':
        return Icons.people;
      case 'policy':
        return Icons.policy;
      case 'folder':
        return Icons.folder;
      case 'flight':
        return Icons.flight;
      case 'card_giftcard':
        return Icons.card_giftcard;
      default:
        return Icons.dashboard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.go(card.route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    _getIconData(card.icon),
                    size: 40,
                    color: colorScheme.primary,
                  ),
                  if (card.badgeCount != null && card.badgeCount! > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          card.badgeCount.toString(),
                          style: TextStyle(
                            color: colorScheme.onError,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                card.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                card.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
