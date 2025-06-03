class Category {
  final int? id;
  final String name;
  final String icon; // Material icon adı
  final String color; // Hex renk kodu

  Category({this.id, required this.name, required this.icon, required this.color});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'] ?? 'lock',
      color: map['color'] ?? '#607D8B', // Varsayılan renk: blueGrey
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }
}
