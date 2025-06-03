import 'package:flutter/material.dart';
import '../models/credential_model.dart';
import '../services/database_service.dart';
import '../services/encryption_service.dart';

class AddCredentialScreen extends StatefulWidget {
  final int userId;

  const AddCredentialScreen({super.key, required this.userId});

  @override
  State<AddCredentialScreen> createState() => _AddCredentialScreenState();
}

class _AddCredentialScreenState extends State<AddCredentialScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _dbService = DatabaseService();

  // Form alanları için controller'lar
  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _urlController = TextEditingController();
  final _notesController = TextEditingController();

  List<String> _categories = [];
  String? _selectedCategory;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final cats = await _dbService.getAllCategories();
    setState(() {
      _categories = cats.map<String>((e) => e['name'] as String).toList();
      if (_categories.isNotEmpty && _selectedCategory == null) {
        _selectedCategory = _categories.first;
      }
    });
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _urlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveCredential() async {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now().toIso8601String();
      final encryptedPassword = await EncryptionService.encrypt(_passwordController.text);
      final newCredential = Credential(
        userId: widget.userId,
        category: _selectedCategory ?? '',
        title: _titleController.text,
        username: _usernameController.text,
        password: encryptedPassword, // Şifrelenmiş olarak kaydediliyor
        email: _emailController.text,
        url: _urlController.text,
        notes: _notesController.text,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _dbService.insertCredential(newCredential.toMap());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Yeni kimlik bilgisi kaydedildi!')),
          );
          Navigator.pop(context, true); // Başarılı kayıttan sonra true döndür
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kaydedilirken hata oluştu: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Şifre Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Kategori seçiniz' : null,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (value) => value == null || value.isEmpty ? 'Başlık boş olamaz' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) => value == null || value.isEmpty ? 'Şifre boş olamaz' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-posta'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(labelText: 'Web Adresi (URL)'),
                keyboardType: TextInputType.url,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notlar'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCredential,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
