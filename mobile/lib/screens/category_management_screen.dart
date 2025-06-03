import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/database_service.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Category> _categories = [];
  final TextEditingController _controller = TextEditingController();
  String _selectedIcon = 'lock';
  String _selectedColor = '#607D8B'; // Varsayılan renk blueGrey

  final List<String> _iconOptions = [
    'lock', 'language', 'account_balance', 'storage', 'vpn_key', 'credit_card', 'person', 'email', 'phone', 'wifi', 'cloud', 'home', 'settings', 'key', 'security', 'account_circle', 'shopping_cart', 'attach_money', 'work', 'school',
  ];

  final List<String> _colorOptions = [
    '#607D8B', // BlueGrey
    '#2196F3', // Blue
    '#4CAF50', // Green
    '#F44336', // Red
    '#FF9800', // Orange
    '#9C27B0', // Purple
    '#FFC107', // Amber
    '#009688', // Teal
    '#795548', // Brown
    '#E91E63', // Pink
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final cats = await _dbService.getAllCategories();
    setState(() {
      _categories = cats.map((e) => Category.fromMap(e)).toList();
    });
  }

  Future<void> _addCategory() async {
    if (_controller.text.trim().isEmpty) return;
    await _dbService.insertCategory({
      'name': _controller.text.trim(),
      'icon': _selectedIcon,
      'color': _selectedColor,
    });
    _controller.clear();
    setState(() {
      _selectedIcon = 'lock';
      _selectedColor = '#607D8B';
    });
    await _fetchCategories();
  }

  Future<void> _deleteCategory(int id) async {
    await _dbService.deleteCategory(id);
    await _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Yönetimi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(labelText: 'Yeni Kategori'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCategory,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('İkon: '),
                    DropdownButton<String>(
                      value: _selectedIcon,
                      items: _iconOptions.map((iconName) {
                        return DropdownMenuItem(
                          value: iconName,
                          child: Row(
                            children: [
                              Icon(_iconFromString(iconName)),
                              const SizedBox(width: 8),
                              Text(iconName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedIcon = val!;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    const Text('Renk: '),
                    DropdownButton<String>(
                      value: _selectedColor,
                      items: _colorOptions.map((colorHex) {
                        return DropdownMenuItem(
                          value: colorHex,
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: Color(_hexToInt(colorHex)), radius: 10),
                              const SizedBox(width: 8),
                              Text(colorHex),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedColor = val!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(_hexToInt(cat.color)),
                    child: Icon(_iconFromString(cat.icon), color: Colors.white),
                  ),
                  title: Text(cat.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCategory(cat.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hex renk kodunu int'e çevir
  int _hexToInt(String hex) {
    hex = hex.replaceAll('#', '');
    return int.parse('FF$hex', radix: 16);
  }

  // String'den Material IconData
  IconData _iconFromString(String iconName) {
    final Map<String, IconData> icons = {
      'lock': Icons.lock,
      'language': Icons.language,
      'account_balance': Icons.account_balance,
      'storage': Icons.storage,
      'vpn_key': Icons.vpn_key,
      'credit_card': Icons.credit_card,
      'person': Icons.person,
      'email': Icons.email,
      'phone': Icons.phone,
      'wifi': Icons.wifi,
      'cloud': Icons.cloud,
      'home': Icons.home,
      'settings': Icons.settings,
      'key': Icons.key,
      'security': Icons.security,
      'account_circle': Icons.account_circle,
      'shopping_cart': Icons.shopping_cart,
      'attach_money': Icons.attach_money,
      'work': Icons.work,
      'school': Icons.school,
    };
    return icons[iconName] ?? Icons.lock;
  }
}
