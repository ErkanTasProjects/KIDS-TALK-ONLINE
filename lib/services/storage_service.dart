import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kids Talk Online - Yerel Veri Kaydetme ve Kalicilik Servisi
/// Kullanicinin XP, Can, Seri (Streak), Tamamlanan Dersler ve Ayarlarini kalici olarak saklar.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _keyXp = 'kids_talk_xp';
  static const String _keyHearts = 'kids_talk_hearts';
  static const String _keyStreak = 'kids_talk_streak';
  static const String _keyLastActiveDate = 'kids_talk_last_active_date';
  static const String _keyCurrentLevelIndex = 'kids_talk_current_level';
  static const String _keyCurrentStage = 'kids_talk_current_stage';
  static const String _keyActivityStars = 'kids_talk_activity_stars';
  static const String _keyLearnedWords = 'kids_talk_learned_words';
  static const String _keyUserName = 'kids_talk_user_name';
  static const String _keyMusicEnabled = 'kids_talk_music_enabled';
  static const String _keySoundEnabled = 'kids_talk_sound_enabled';
  static const String _keyLanguage = 'kids_talk_language';
  static const String _keyAvatarAnimal = 'kids_talk_avatar_animal';
  static const String _keyAvatarColor = 'kids_talk_avatar_color';
  static const String _keyAvatarAccessory = 'kids_talk_avatar_accessory';
  static const String _keyGems = 'kids_talk_gems';
  static const String _keyVip = 'kids_talk_vip';
  static const String _keyChestOpened = 'kids_talk_chest_opened';
  static const String _keyListenDate = 'kids_talk_daily_listen_date';
  static const String _keyHeartsUpdatedAt = 'kids_talk_hearts_updated_at';

  SharedPreferences? _prefs;

  /// Testler arasinda onbellegi temizler.
  @visibleForTesting
  void resetForTesting() => _prefs = null;

  Future<void> init() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      debugPrint("StorageService başarıyla hazırlandı.");
    } catch (e) {
      debugPrint("StorageService başlatma hatası: $e");
    }
  }

  // --- XP ---
  int getXp() {
    return _prefs?.getInt(_keyXp) ?? 0;
  }

  Future<void> saveXp(int xp) async {
    await _prefs?.setInt(_keyXp, xp);
  }

  // --- CANLAR (Hearts) ---
  int getHearts() {
    return _prefs?.getInt(_keyHearts) ?? 5;
  }

  Future<void> saveHearts(int hearts) async {
    await _prefs?.setInt(_keyHearts, hearts);
  }

  // --- SERI (Streak) ---
  int getStreak() {
    return _prefs?.getInt(_keyStreak) ?? 1;
  }

  Future<void> saveStreak(int streak) async {
    await _prefs?.setInt(_keyStreak, streak);
  }

  // --- SON AKTIF GUN ---
  String? getLastActiveDate() {
    return _prefs?.getString(_keyLastActiveDate);
  }

  Future<void> saveLastActiveDate(String dateIso) async {
    await _prefs?.setString(_keyLastActiveDate, dateIso);
  }

  // --- ACIK OLAN BOLUM (Current Level Index) ---
  int getCurrentLevelIndex() {
    return _prefs?.getInt(_keyCurrentLevelIndex) ?? 0;
  }

  Future<void> saveCurrentLevelIndex(int level) async {
    await _prefs?.setInt(_keyCurrentLevelIndex, level);
  }

  // --- SEVIYE / DUNYA (Stage) ---
  String getCurrentStage() {
    return _prefs?.getString(_keyCurrentStage) ?? 'Starter';
  }

  Future<void> saveCurrentStage(String stage) async {
    await _prefs?.setString(_keyCurrentStage, stage);
  }

  // --- KAZANILAN YILDIZLAR (Activity Stars Map) ---
  Map<String, int> getActivityStars() {
    try {
      final jsonStr = _prefs?.getString(_keyActivityStars);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        return decoded.map((k, v) => MapEntry(k, v as int));
      }
    } catch (e) {
      debugPrint("Yıldızlar okunurken hata: $e");
    }
    return {}; // Yeni kullanici: henuz yildiz yok
  }

  Future<void> saveActivityStars(Map<String, int> stars) async {
    try {
      final jsonStr = jsonEncode(stars);
      await _prefs?.setString(_keyActivityStars, jsonStr);
    } catch (e) {
      debugPrint("Yıldızlar kaydedilirken hata: $e");
    }
  }

  // --- OGRENILEN KELIMELER ---
  List<String> getLearnedWords() {
    return _prefs?.getStringList(_keyLearnedWords) ?? <String>[];
  }

  Future<void> saveLearnedWords(List<String> words) async {
    await _prefs?.setStringList(_keyLearnedWords, words);
  }

  // --- KULLANICI ADI ---
  String getUserName() {
    return _prefs?.getString(_keyUserName) ?? 'Star Explorer';
  }

  Future<void> saveUserName(String name) async {
    await _prefs?.setString(_keyUserName, name);
  }

  // --- SES VE MUZIK AYARLARI ---
  bool isMusicEnabled() {
    return _prefs?.getBool(_keyMusicEnabled) ?? true;
  }

  Future<void> setMusicEnabled(bool enabled) async {
    await _prefs?.setBool(_keyMusicEnabled, enabled);
  }

  bool isSoundEnabled() {
    return _prefs?.getBool(_keySoundEnabled) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  // --- DIL AYARI (Varsayilan: 'en' %100 Ingilizce) ---
  String getLanguage() {
    return _prefs?.getString(_keyLanguage) ?? 'en';
  }

  Future<void> saveLanguage(String lang) async {
    await _prefs?.setString(_keyLanguage, lang);
  }

  // --- KASIF / SEYYAH AVATAR AYARLARI ---
  String getAvatarAnimal() {
    return _prefs?.getString(_keyAvatarAnimal) ?? 'giraffe';
  }

  Future<void> saveAvatarAnimal(String animal) async {
    await _prefs?.setString(_keyAvatarAnimal, animal);
  }

  int getAvatarColor() {
    return _prefs?.getInt(_keyAvatarColor) ?? 0xFFFF8A65;
  }

  Future<void> saveAvatarColor(int colorValue) async {
    await _prefs?.setInt(_keyAvatarColor, colorValue);
  }

  String getAvatarAccessory() {
    return _prefs?.getString(_keyAvatarAccessory) ?? 'crown';
  }

  Future<void> saveAvatarAccessory(String accessory) async {
    await _prefs?.setString(_keyAvatarAccessory, accessory);
  }

  // --- ELMASLAR (Gems) ---
  int getGems() {
    return _prefs?.getInt(_keyGems) ?? 0;
  }

  Future<void> saveGems(int gems) async {
    await _prefs?.setInt(_keyGems, gems);
  }

  // --- VIP (Star Club) ---
  bool isVip() {
    return _prefs?.getBool(_keyVip) ?? false;
  }

  Future<void> setVip(bool value) async {
    await _prefs?.setBool(_keyVip, value);
  }

  // --- CAN YENILENME ZAMANI (ms) ---
  int? getHeartsUpdatedAt() {
    return _prefs?.getInt(_keyHeartsUpdatedAt);
  }

  Future<void> saveHeartsUpdatedAt(int ms) async {
    await _prefs?.setInt(_keyHeartsUpdatedAt, ms);
  }

  // --- HAZINE SANDIGI / GUNLUK DINLEME GOREVI ---
  bool isChestOpened() => _prefs?.getBool(_keyChestOpened) ?? false;

  Future<void> setChestOpened(bool v) async {
    await _prefs?.setBool(_keyChestOpened, v);
  }

  String? getDailyListenDate() => _prefs?.getString(_keyListenDate);

  Future<void> saveDailyListenDate(String d) async {
    await _prefs?.setString(_keyListenDate, d);
  }

  // --- Genel amacli anahtarlar (gunluk gorevler, diyar sandiklari) ---
  String? readString(String key) => _prefs?.getString('kids_talk_$key');
  Future<void> writeString(String key, String v) async => _prefs?.setString('kids_talk_$key', v);
  int readInt(String key) => _prefs?.getInt('kids_talk_$key') ?? 0;
  Future<void> writeInt(String key, int v) async => _prefs?.setInt('kids_talk_$key', v);
  List<String> readList(String key) => _prefs?.getStringList('kids_talk_$key') ?? <String>[];
  Future<void> writeList(String key, List<String> v) async => _prefs?.setStringList('kids_talk_$key', v);
}
