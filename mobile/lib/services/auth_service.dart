import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService();
  
  // Kullanıcı kayıt işlemi
  Future<User?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Kullanıcı adı kontrolü
      final isUsernameTaken = await _dbService.isUsernameTaken(username);
      if (isUsernameTaken) {
        throw 'Bu kullanıcı adı zaten kullanılıyor';
      }

      // Email kontrolü
      final isEmailTaken = await _dbService.isEmailTaken(email);
      if (isEmailTaken) {
        throw 'Bu e-posta adresi zaten kayıtlı';
      }

      // Yeni kullanıcı oluştur
      final newUser = User(
        username: username,
        email: email,
        password: password, // Şifre şifrelenmeli (gerçek uygulamada)
        createdAt: DateTime.now().toIso8601String(),
      );

      // Veritabanına ekle
      final id = await _dbService.insertUser(newUser.toMap());
      
      return newUser.copyWith(id: id);
    } catch (e) {
      debugPrint('Kayıt hatası: $e');
      rethrow;
    }
  }

  // Kullanıcı giriş işlemi
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userMap = await _dbService.loginUser(email, password);
      
      if (userMap != null) {
        return User.fromMap(userMap);
      }
      
      throw 'E-posta veya şifre hatalı';
    } catch (e) {
      debugPrint('Giriş hatası: $e');
      rethrow;
    }
  }

  // Kullanıcı çıkış işlemi
  Future<void> logout() async {
    // Oturum bilgilerini temizle
    // Örneğin: SharedPreferences veya diğer state yönetim araçlarıyla saklanan bilgiler
  }

  // Kullanıcı oturum kontrolü
  Future<bool> isLoggedIn() async {
    // Kullanıcının oturum açık mı kontrol et
    // Örneğin: SharedPreferences'ta token kontrolü
    return false;
  }
}
