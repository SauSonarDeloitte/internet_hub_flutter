import 'package:flutter/material.dart';
import '../../../core/menu/models/menu_section.dart';
import 'menu_item_widget.dart';

class MenuSectionWidget extends StatefulWidget {
  final MenuSection section;
  final String? currentRoute;

  const MenuSectionWidget({
    super.key,
    required this.section,
    this.currentRoute,
  });

  @override
  State<MenuSectionWidget> createState() => _MenuSectionWidgetState();
}

class _MenuSectionWidgetState extends State<MenuSectionWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.section.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            widget.section.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          ...widget.section.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: MenuItemWidget(
                item: item,
                isSelected: widget.currentRoute == item.route,
              ),
            ),
          ),
        const Divider(),
      ],
    );
  }
}
