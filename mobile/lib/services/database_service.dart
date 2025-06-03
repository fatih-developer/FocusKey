import 'dart:io';
import 'package:flutter/foundation.dart' hide Category;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/category_model.dart';
import '../models/credential_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // Kullanıcılar tablosu
  static const String tableUsers = 'users';
  static const String columnId = 'id';
  static const String columnUsername = 'username';
  static const String columnEmail = 'email';
  static const String columnPassword = 'password';
  static const String columnCreatedAt = 'created_at';

  // Credentials tablosu
  static const String tableCredentials = 'credentials';
  static const String columnCredUserId = 'user_id'; // Foreign key to users table
  static const String columnCredCategory = 'category';
  static const String columnCredTitle = 'title';
  static const String columnCredUsername = 'username';
  static const String columnCredPassword = 'password';
  static const String columnCredEmail = 'email';
  static const String columnCredUrl = 'url';
  static const String columnCredNotes = 'notes';
  static const String columnCredCreatedAt = 'created_at';
  static const String columnCredUpdatedAt = 'updated_at';

  // Category tablosu
  static const String tableCategories = 'categories';
  static const String columnCategoryId = 'id';
  static const String columnCategoryName = 'name';
  static const String columnCategoryIcon = 'icon';
  static const String columnCategoryColor = 'color';

  // Veritabanı bağlantısını başlat
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Veritabanını başlat
  Future<Database> _initDatabase() async {
    try {
      // Belgeler klasörünü al
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      
      // Hata ayıklama için belgeler klasörünü yazdır
      debugPrint('Belgeler klasörü: ${documentsDirectory.path}');
      
      // FocusKey klasörünün yolunu oluştur
      Directory appDir = Directory('${documentsDirectory.path}/FocusKey');
      
      // Hata ayıklama için klasör durumunu yazdır
      debugPrint('FocusKey klasörü var mı? ${await appDir.exists()}');
      
      // Eğer klasör yoksa oluştur
      if (!await appDir.exists()) {
        debugPrint('Klasör oluşturuluyor: ${appDir.path}');
        await appDir.create(recursive: true);
        debugPrint('Klasör oluşturuldu');
      }
      
      // Veritabanı dosya yolu
      String path = '${appDir.path}/focuskey.db';
      debugPrint('Veritabanı yolu: $path');
      
      // Klasör içeriğini listele (hata ayıklama için)
      try {
        final files = await Directory(documentsDirectory.path).list().toList();
        debugPrint('Belgeler klasörü içeriği:');
        for (var file in files) {
          debugPrint(' - ${file.path}');
        }
      } catch (e) {
        debugPrint('Klasör listeleme hatası: $e');
      }
      
      return await openDatabase(
        path,
        version: 3, // Versiyon yükseltildi
        onCreate: _onCreate,
        onUpgrade: _onUpgrade, // Migration desteği eklendi
      );
    } catch (e) {
      debugPrint('Veritabanı başlatma hatası: $e');
      rethrow;
    }
  }

  // Migration (versiyon yükseltme)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // v2 ile credentials tablosu ekleniyor
      await db.execute('''
        CREATE TABLE $tableCredentials (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnCredUserId INTEGER NOT NULL,
          $columnCredCategory TEXT NOT NULL,
          $columnCredTitle TEXT NOT NULL,
          $columnCredUsername TEXT,
          $columnCredPassword TEXT NOT NULL,
          $columnCredEmail TEXT,
          $columnCredUrl TEXT,
          $columnCredNotes TEXT,
          $columnCredCreatedAt TEXT NOT NULL,
          $columnCredUpdatedAt TEXT NOT NULL,
          FOREIGN KEY ($columnCredUserId) REFERENCES $tableUsers ($columnId) ON DELETE CASCADE
        )
      ''');
      debugPrint('Migration: credentials tablosu eklendi.');
    }
    if (oldVersion < 3) {
      // v3 ile categories tablosu ekleniyor
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableCategories (
          $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnCategoryName TEXT NOT NULL UNIQUE,
          $columnCategoryIcon TEXT NOT NULL,
          $columnCategoryColor TEXT NOT NULL
        )
      ''');
      debugPrint('Migration: categories tablosu eklendi.');
    }
    // Eski kurulumda tablo varsa alter ile kolon ekle
    try {
      await db.execute("ALTER TABLE $tableCategories ADD COLUMN $columnCategoryIcon TEXT;");
      await db.execute("ALTER TABLE $tableCategories ADD COLUMN $columnCategoryColor TEXT;");
    } catch (e) {
      debugPrint('Migration: icon/color kolonları zaten var veya eklenemedi: $e');
    }
  }

  // Tabloları oluştur
  Future<void> _onCreate(Database db, int version) async {
    debugPrint('Veritabanı oluşturuluyor (_onCreate çağrıldı)... Tablo $tableUsers oluşturulacak.');
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUsername TEXT NOT NULL,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL
      )
    ''');

    // Category tablosunu oluştur
    await db.execute('''
      CREATE TABLE $tableCategories (
        $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategoryName TEXT NOT NULL UNIQUE,
        $columnCategoryIcon TEXT NOT NULL,
        $columnCategoryColor TEXT NOT NULL
      )
    ''');
    debugPrint('$tableCategories tablosu oluşturuldu.');

    // Credentials tablosunu oluştur
    await db.execute('''
      CREATE TABLE $tableCredentials (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCredUserId INTEGER NOT NULL,
        $columnCredCategory TEXT NOT NULL,
        $columnCredTitle TEXT NOT NULL,
        $columnCredUsername TEXT,
        $columnCredPassword TEXT NOT NULL,
        $columnCredEmail TEXT,
        $columnCredUrl TEXT,
        $columnCredNotes TEXT,
        $columnCredCreatedAt TEXT NOT NULL,
        $columnCredUpdatedAt TEXT NOT NULL,
        FOREIGN KEY ($columnCredUserId) REFERENCES $tableUsers ($columnId) ON DELETE CASCADE
      )
    ''');
    debugPrint('$tableCredentials tablosu oluşturuldu.');
  }

  // Kullanıcı ekle
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(tableUsers, user);
  }

  // Email'e göre kullanıcı getir
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map> result = await db.query(
      tableUsers,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    
    if (result.isNotEmpty) {
      return result.first as Map<String, dynamic>;
    }
    return null;
  }

  // Kullanıcı giriş kontrolü
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    Database db = await database;
    List<Map> result = await db.query(
      tableUsers,
      where: '$columnEmail = ? AND $columnPassword = ?',
      whereArgs: [email, password],
    );
    
    if (result.isNotEmpty) {
      return result.first as Map<String, dynamic>;
    }
    return null;
  }

  // Kullanıcı adı kontrolü
  Future<bool> isUsernameTaken(String username) async {
    Database db = await database;
    List<Map> result = await db.query(
      tableUsers,
      where: '$columnUsername = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // Email kontrolü
  Future<bool> isEmailTaken(String email) async {
    Database db = await database;
    List<Map> result = await db.query(
      tableUsers,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Veritabanını sil (geliştirme amaçlı)
  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/FocusKey/focuskey.db';
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  // --- Category CRUD Operasyonları ---

  Future<int> insertCategory(Map<String, dynamic> category) async {
    Database db = await database;
    return await db.insert(tableCategories, category);
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    Database db = await database;
    return await db.query(tableCategories, orderBy: '$columnCategoryName ASC');
  }

  Future<int> updateCategory(int id, Map<String, dynamic> category) async {
    Database db = await database;
    return await db.update(tableCategories, category, where: '$columnCategoryId = ?', whereArgs: [id]);
  }

  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete(tableCategories, where: '$columnCategoryId = ?', whereArgs: [id]);
  }

  Future<Category?> getCategoryByName(String name) async {
    Database db = await database;
    final result = await db.query(tableCategories, where: '$columnCategoryName = ?', whereArgs: [name]);
    if (result.isNotEmpty) {
      return Category.fromMap(result.first);
    }
    return null;
  }

// --- Credentials CRUD Operasyonları ---

  /// Kullanıcı, kategori ve arama filtresiyle credential listesi getirir
  Future<List<Credential>> getCredentials({
    required int userId,
    String? category,
    String? search,
  }) async {
    List<Map<String, dynamic>> result;

    if (search != null && search.isNotEmpty) {
      result = await searchCredentials(userId, search);
      if (category != null && category.isNotEmpty) {
        result = result.where((e) => e['category'] == category).toList();
      }
    } else if (category != null && category.isNotEmpty) {
      result = await getCredentialsByUserIdAndCategory(userId, category);
    } else {
      result = await getCredentialsByUserId(userId);
    }
    return result.map((e) => Credential.fromMap(e)).toList();
  }

  // Yeni kimlik bilgisi ekle
  Future<int> insertCredential(Map<String, dynamic> credential) async {
    Database db = await database;
    return await db.insert(tableCredentials, credential);
  }

  // Kullanıcıya ait tüm kimlik bilgilerini getir
  Future<List<Map<String, dynamic>>> getCredentialsByUserId(int userId) async {
    Database db = await database;
    return await db.query(
      tableCredentials,
      where: '$columnCredUserId = ?',
      whereArgs: [userId],
      orderBy: '$columnCredUpdatedAt DESC', // En son güncellenenler üstte
    );
  }

  // Kullanıcıya ait ve kategoriye göre kimlik bilgilerini getir
  Future<List<Map<String, dynamic>>> getCredentialsByUserIdAndCategory(int userId, String category) async {
    Database db = await database;
    return await db.query(
      tableCredentials,
      where: '$columnCredUserId = ? AND $columnCredCategory = ?',
      whereArgs: [userId, category],
      orderBy: '$columnCredUpdatedAt DESC',
    );
  }

  // Kimlik bilgilerinde arama yap
  Future<List<Map<String, dynamic>>> searchCredentials(int userId, String query) async {
    Database db = await database;
    String searchQuery = '%$query%';
    return await db.query(
      tableCredentials,
      where: '$columnCredUserId = ? AND ' 
             '($columnCredTitle LIKE ? OR ' 
             '$columnCredUsername LIKE ? OR ' 
             '$columnCredEmail LIKE ? OR ' 
             '$columnCredUrl LIKE ? OR ' 
             '$columnCredNotes LIKE ?)',
      whereArgs: [userId, searchQuery, searchQuery, searchQuery, searchQuery, searchQuery],
      orderBy: '$columnCredUpdatedAt DESC',
    );
  }

  // Kimlik bilgisini güncelle
  Future<int> updateCredential(Map<String, dynamic> credential) async {
    Database db = await database;
    int id = credential[columnId];
    return await db.update(
      tableCredentials,
      credential,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Kimlik bilgisini sil
  Future<int> deleteCredential(int id) async {
    Database db = await database;
    return await db.delete(
      tableCredentials,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
