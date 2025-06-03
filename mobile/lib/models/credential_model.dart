import '../services/database_service.dart';

class Credential {
  final int? id;
  final int userId;
  final String category;
  final String title;
  final String? username;
  final String password; // Şifrelenmiş olarak saklanacak
  final String? email;
  final String? url;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  Credential({
    this.id,
    required this.userId,
    required this.category,
    required this.title,
    this.username,
    required this.password,
    this.email,
    this.url,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Map'ten Credential nesnesi oluştur
  factory Credential.fromMap(Map<String, dynamic> map) {
    return Credential(
      id: map[DatabaseService.columnId],
      userId: map[DatabaseService.columnCredUserId],
      category: map[DatabaseService.columnCredCategory],
      title: map[DatabaseService.columnCredTitle],
      username: map[DatabaseService.columnCredUsername],
      password: map[DatabaseService.columnCredPassword],
      email: map[DatabaseService.columnCredEmail],
      url: map[DatabaseService.columnCredUrl],
      notes: map[DatabaseService.columnCredNotes],
      createdAt: map[DatabaseService.columnCredCreatedAt],
      updatedAt: map[DatabaseService.columnCredUpdatedAt],
    );
  }

  // Credential nesnesinden Map oluştur
  Map<String, dynamic> toMap() {
    return {
      DatabaseService.columnId: id,
      DatabaseService.columnCredUserId: userId,
      DatabaseService.columnCredCategory: category,
      DatabaseService.columnCredTitle: title,
      DatabaseService.columnCredUsername: username,
      DatabaseService.columnCredPassword: password,
      DatabaseService.columnCredEmail: email,
      DatabaseService.columnCredUrl: url,
      DatabaseService.columnCredNotes: notes,
      DatabaseService.columnCredCreatedAt: createdAt,
      DatabaseService.columnCredUpdatedAt: updatedAt,
    };
  }

  // Kopyalama için with metodu
  Credential copyWith({
    int? id,
    int? userId,
    String? category,
    String? title,
    String? username,
    String? password,
    String? email,
    String? url,
    String? notes,
    String? createdAt,
    String? updatedAt,
  }) {
    return Credential(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      url: url ?? this.url,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
