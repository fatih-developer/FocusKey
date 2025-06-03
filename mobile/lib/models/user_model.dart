import '../services/database_service.dart';

class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  // Map'ten User nesnesi oluştur
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[DatabaseService.columnId],
      username: map[DatabaseService.columnUsername],
      email: map[DatabaseService.columnEmail],
      password: map[DatabaseService.columnPassword],
      createdAt: map[DatabaseService.columnCreatedAt],
    );
  }

  // User nesnesinden Map oluştur
  Map<String, dynamic> toMap() {
    return {
      DatabaseService.columnId: id,
      DatabaseService.columnUsername: username,
      DatabaseService.columnEmail: email,
      DatabaseService.columnPassword: password,
      DatabaseService.columnCreatedAt: createdAt,
    };
  }

  // Kopyalama için with metodu
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
