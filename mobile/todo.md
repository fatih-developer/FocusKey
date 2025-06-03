# FocusKey Mobil Uygulama Yapılacaklar Listesi

## 1. Proje Kurulumu
- [ ] Flutter projesi oluşturma
- [ ] Gerekli paketlerin yüklenmesi:
  - flutter_secure_storage
  - sqflite ve sqlcipher_flutter_libs
  - local_auth
  - encrypt
  - path_provider
  - uuid
  - share_plus
  - clipboard_manager
  - flutter_windowmanager

## 2. Güvenlik Altyapısı
- [ ] Ana parola yönetimi
  - [ ] PBKDF2, scrypt veya Argon2 ile anahtar türetme
  - [ ] Ana parola doğrulama
  - [ ] Biyometrik kimlik doğrulama entegrasyonu

- [ ] Veri Şifreleme
  - [ ] AES-256 şifreleme uygulaması
  - [ ] Şifrelenmiş veritabanı yapılandırması
  - [ ] Bellek yönetimi ve hassas verilerin güvenli temizliği

## 3. Veritabanı Yönetimi
- [ ] SQLCipher ile şifreli SQLite veritabanı kurulumu
- [ ] Temel CRUD işlemleri için modüller
- [ ] Veri yedekleme ve geri yükleme mekanizması

## 4. Kullanıcı Arayüzü
### Giriş ve Güvenlik
- [ ] Ana giriş ekranı (ana parola/biyometrik)
- [ ] Otomatik kilit mekanizması
- [ ] Yanlış giriş denemesi yönetimi

### Ana Ekran
- [ ] Hesap listesi görünümü
- [ ] Arama ve filtreleme özellikleri
- [ ] Kategori/klasör yönetimi

### Hesap Yönetimi
- [ ] Yeni hesap ekleme formu
- [ ] Hesap detay görünümü
- [ ] Hesap düzenleme ve silme işlemleri

### Parola Üretici
- [ ] Rastgele parola oluşturucu
- [ ] Parola güç göstergesi
- [ ] Özelleştirilebilir parola ayarları

## 5. Diğer Özellikler
- [ ] Pano yönetimi (otomatik temizleme)
- [ ] Uygulama ayarları
- [ ] Karanlık/aydınlık tema desteği
- [ ] Çoklu dil desteği

## 6. Testler
- [ ] Birim testleri
- [ ] Widget testleri
- [ ] Entegrasyon testleri
- [ ] Güvenlik testleri

## 7. Dağıtım Öncesi
- [ ] Performans optimizasyonları
- [ ] Güvenlik denetimi
- [ ] Gizlilik politikası hazırlama
- [ ] Uygulama mağazası için gerekli dokümantasyon

## 8. Dokümantasyon
- [ ] Kullanım kılavuzu
- [ ] Geliştirici dokümantasyonu
- [ ] Sürüm notları
