import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import '../services/database_service.dart';
import '../models/category_model.dart';
import '../models/credential_model.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  final VoidCallback logout;
  const HomeScreen({Key? key, required this.userId, required this.logout}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  final SideMenuController _sideMenuController = SideMenuController();
  bool _menuOpen = false;
  List<Credential> _credentials = [];
  List<Category> _categories = [];
  Category? _selectedCategory;
  String _searchText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadCredentials();
  }

  Future<void> _loadCategories() async {
    final catMaps = await _dbService.getAllCategories();
    setState(() {
      _categories = catMaps.map((e) => Category.fromMap(e)).toList();
    });
  }

  Future<void> _loadCredentials() async {
    setState(() { _isLoading = true; });
    final creds = await _dbService.getCredentials(
      userId: widget.userId,
      category: _selectedCategory?.name,
      search: _searchText,
    );
    setState(() {
      _credentials = creds;
      _isLoading = false;
    });
  }

  int _safeHexToInt(String hex) {
    try {
      return int.parse(hex.replaceFirst('#', '0xff'));
    } catch (_) {
      return 0xFF546E7A; // fallback renk
    }
  }

  IconData _iconFromString(String iconName) {
    // Sık kullanılan iconlar için örnek eşleme
    switch (iconName) {
      case 'work': return Icons.work;
      case 'home': return Icons.home;
      case 'school': return Icons.school;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'security': return Icons.security;
      case 'credit_card': return Icons.credit_card;
      case 'wifi': return Icons.wifi;
      case 'mail': return Icons.mail;
      case 'person': return Icons.person;
      case 'lock': return Icons.lock;
      default: return Icons.category;
    }
  }

  void _onSearchChanged(String val) {
    setState(() {
      _searchText = val;
    });
    _loadCredentials();
  }

  void _onCategoryChanged(Category? cat) {
    setState(() {
      _selectedCategory = cat;
    });
    _loadCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Parola Yöneticisi'),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                setState(() { _menuOpen = !_menuOpen; });
              },
            ),
          ),
          body: _buildBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.of(context).pushNamed('/add-credential');
              if (result == true) {
                _loadCredentials();
              }
            },
            tooltip: 'Yeni Kayıt',
            child: const Icon(Icons.add),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          top: 0,
          bottom: 0,
          left: _menuOpen ? 0 : -220,
          child: SizedBox(
            width: 220,
            child: SideMenu(
              controller: _sideMenuController,
              style: SideMenuStyle(
                displayMode: SideMenuDisplayMode.auto,
                openSideMenuWidth: 220,
                compactSideMenuWidth: 56,
                hoverColor: Colors.blueGrey.shade100,
                selectedColor: Colors.blueGrey.shade300,
                selectedIconColor: Colors.white,
                unselectedIconColor: Colors.blueGrey.shade400,
                backgroundColor: Colors.white,
              ),
              title: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Menü', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              items: [
                SideMenuItem(
                  title: 'Kategoriler',
                  onTap: (i, _) {
                    setState(() { _menuOpen = false; });
                    Navigator.of(context).pushNamed('/category');
                  },
                  icon: Icon(Icons.category),
                ),
                SideMenuItem(
                  title: 'Çıkış',
                  onTap: (i, _) {
                    setState(() { _menuOpen = false; });
                    widget.logout();
                  },
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Ara...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: DropdownButton<Category?>(
            isExpanded: true,
            value: _selectedCategory,
            items: [
              const DropdownMenuItem<Category?>(value: null, child: Text('Hepsi')),
              ..._categories.map((cat) => DropdownMenuItem<Category?>(
                value: cat,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(_safeHexToInt(cat.color)),
                      radius: 10,
                      child: Icon(_iconFromString(cat.icon), size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(cat.name),
                  ],
                ),
              ))
            ],
            onChanged: _onCategoryChanged,
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _credentials.isEmpty
                  ? const Center(child: Text('Kayıt yok'))
                  : ListView.builder(
                      itemCount: _credentials.length,
                      itemBuilder: (context, idx) {
                        final cred = _credentials[idx];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF232634)
                              : const Color(0xFFF9FAFB),
                          child: ListTile(
                            leading: FutureBuilder<Category?>(
                              future: _dbService.getCategoryByName(cred.category),
                              builder: (context, snapshot) {
                                final cat = snapshot.data;
                                return CircleAvatar(
                                  backgroundColor: cat != null ? Color(_safeHexToInt(cat.color)) : Colors.blueGrey,
                                  child: Icon(_iconFromString(cat?.icon ?? 'lock'), color: Colors.white),
                                );
                              },
                            ),
                            title: Text(cred.title, style: Theme.of(context).textTheme.titleMedium),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kategori: ${cred.category}'),
                                if (cred.username != null && cred.username!.isNotEmpty)
                                  Text('Kullanıcı Adı: ${cred.username}'),
                                Text('Şifre: ********'),
                              ],
                            ),
                            onTap: () {
                              // Şifre gösterme modalı burada açılabilir
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
