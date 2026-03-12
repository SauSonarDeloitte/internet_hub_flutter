import 'menu_item.dart';

/// Represents a section in the menu containing multiple items
class MenuSection {
  final String id;
  final String title;
  final List<MenuItem> items;
  final bool isExpanded;

  const MenuSection({
    required this.id,
    required this.title,
    required this.items,
    this.isExpanded = true,
  });

  MenuSection copyWith({
    String? id,
    String? title,
    List<MenuItem>? items,
    bool? isExpanded,
  }) {
    return MenuSection(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
