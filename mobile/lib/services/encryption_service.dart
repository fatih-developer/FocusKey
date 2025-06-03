import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const _keyStorageKey = 'encryption_key';
  static final _secureStorage = const FlutterSecureStorage();

  // Uygulama için tek bir anahtar üret ve güvenli sakla
  static Future<Key> getOrCreateKey() async {
    String? base64Key = await _secureStorage.read(key: _keyStorageKey);
    if (base64Key == null) {
      final key = Key.fromSecureRandom(32); // AES-256 için 32 byte
      base64Key = key.base64;
      await _secureStorage.write(key: _keyStorageKey, value: base64Key);
      return key;
    }
    return Key.fromBase64(base64Key);
  }

  static Future<String> encrypt(String plainText) async {
    final key = await getOrCreateKey();
    final iv = IV.fromSecureRandom(16); // AES için 16 byte IV
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // IV ile birlikte base64 olarak sakla
    return '${iv.base64}:${encrypted.base64}';
  }

  static Future<String> decrypt(String encryptedText) async {
    final key = await getOrCreateKey();
    final parts = encryptedText.split(':');
    if (parts.length != 2) throw Exception('Şifre çözme formatı hatalı!');
    final iv = IV.fromBase64(parts[0]);
    final encrypted = Encrypted.fromBase64(parts[1]);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
