class MenuGroup {
  final int id;
  final String content;

  MenuGroup({required this.id, required this.content});

  factory MenuGroup.fromJson(Map<String, dynamic> json) {
    print('Parsing MenuGroup json: $json');
    return MenuGroup(
      id: json['id'] as int,
      content:
          json['content']?.toString() ??
          json['name']?.toString() ??
          json['title']?.toString() ??
          '',
    );
  }
}

class MenuItem {
  final int id;
  final String code;
  final String title;
  final int price;
  final int? menuGroupId;

  MenuItem({
    required this.id,
    required this.code,
    required this.title,
    required this.price,
    this.menuGroupId,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    print('Parsing MenuItem json: $json');
    return MenuItem(
      id: json['id'] as int? ?? 0,
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      price: json['price'] == null
          ? 0
          : (json['price'] is num
                ? (json['price'] as num).toInt()
                : double.tryParse(json['price'].toString())?.toInt() ?? 0),
      menuGroupId: json['group_id'] as int? ?? json['menu_group_id'] as int?,
    );
  }
}
