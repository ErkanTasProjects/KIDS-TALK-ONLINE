import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();

  // Kullanici Istatistikleri
  int _xp = 45;
  int _hearts = 5;
  int _streak = 1;
  int _gems = 128;
  int _currentLevelIndex = 0;
  String _currentStage = 'Starter';
  String _userName = 'Star Explorer';
  String _avatarAnimal = 'giraffe';
  int _avatarColor = 0xFFFF8A65;
  String _avatarAccessory = 'crown';
  Map<String, int> _activityStars = {'starter_1_2': 3};
  List<String> _learnedWords = ['Hello', 'Morning', 'Cat', 'Apple', 'Book'];
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  String _language = 'en'; // 'en' (default 100% English) or 'tr' (optional in parent settings)

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int get xp => _xp;
  int get hearts => _hearts;
  int get streak => _streak;
  int get gems => _gems;
  int get currentLevelIndex => _currentLevelIndex;
  String get currentStage => _currentStage;
  String get userName => _userName;
  String get avatarAnimal => _avatarAnimal;
  int get avatarColor => _avatarColor;
  String get avatarAccessory => _avatarAccessory;
  Map<String, int> get activityStars => _activityStars;
  List<String> get learnedWords => _learnedWords;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isMusicEnabled => _isMusicEnabled;
  String get language => _language;
  bool get isTurkish => false;

  int get totalStars => _activityStars.values.fold(0, (a, b) => a + b);

  AppState() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    await _storage.init();
    _xp = _storage.getXp();
    _hearts = _storage.getHearts();
    _streak = _storage.getStreak();
    _gems = _storage.getGems();
    _currentLevelIndex = _storage.getCurrentLevelIndex();
    _currentStage = _storage.getCurrentStage();
    _activityStars = _storage.getActivityStars();
    _learnedWords = _storage.getLearnedWords();
    _userName = _storage.getUserName();
    _avatarAnimal = _storage.getAvatarAnimal();
    _avatarColor = _storage.getAvatarColor();
    _avatarAccessory = _storage.getAvatarAccessory();
    _isSoundEnabled = _storage.isSoundEnabled();
    _isMusicEnabled = _storage.isMusicEnabled();
    _language = _storage.getLanguage();

    _checkStreak();

    _isLoaded = true;
    notifyListeners();
  }

  // Seri Kontrolu (Gunde bir kez kontrol)
  void _checkStreak() {
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastActiveStr = _storage.getLastActiveDate();

    if (lastActiveStr == null) {
      _storage.saveLastActiveDate(todayStr);
    } else if (lastActiveStr != todayStr) {
      try {
        final parts = lastActiveStr.split('-').map(int.parse).toList();
        final lastDate = DateTime(parts[0], parts[1], parts[2]);
        final difference = now.difference(lastDate).inDays;

        if (difference == 1) {
          _streak += 1;
          _storage.saveStreak(_streak);
        } else if (difference > 1) {
          _streak = 1; // 1 günden fazla ara verildiyse sıfırla
          _storage.saveStreak(_streak);
        }
      } catch (_) {}
      _storage.saveLastActiveDate(todayStr);
    }
  }

  int getStarsFor(String activityId) {
    return _activityStars[activityId] ?? 0;
  }

  // XP Kazanma
  void addXp(int amount) {
    _xp += amount;
    _storage.saveXp(_xp);
    notifyListeners();
  }

  // Can Yenileme (5 Can)
  void refillHearts() {
    _hearts = 5;
    _storage.saveHearts(_hearts);
    notifyListeners();
  }

  // Can Dusurme (Yanlis cevap)
  void useHeart() {
    if (_hearts > 0) {
      _hearts--;
      _storage.saveHearts(_hearts);
      notifyListeners();
    }
  }

  // Seviye/Asama Degistirme (Starter, Movers, Flyers)
  void setCurrentStage(String stage) {
    if (_currentStage != stage) {
      _currentStage = stage;
      _storage.saveCurrentStage(stage);
      notifyListeners();
    }
  }

  // Kullanici Adi Guncelleme
  void setUserName(String name) {
    _userName = name;
    _storage.saveUserName(name);
    notifyListeners();
  }

  // Yeni Kelime Ekleme
  void addLearnedWord(String word) {
    if (!_learnedWords.contains(word)) {
      _learnedWords.add(word);
      _storage.saveLearnedWords(_learnedWords);
      notifyListeners();
    }
  }

  // Ses & Muzik Ac / Kapa
  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    _storage.setSoundEnabled(_isSoundEnabled);
    notifyListeners();
  }

  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    _storage.setMusicEnabled(_isMusicEnabled);
    notifyListeners();
  }

  // Dil Degistirme (Sadece veli ayarlarindan degistirilebilir)
  void setLanguage(String lang) {
    if (_language != lang) {
      _language = lang;
      _storage.saveLanguage(lang);
      notifyListeners();
    }
  }

  // Aktiviteyi Yildizlarla Tamamlama & Ilerlemeyi Kaydetme
  void completeActivity(String activityId, int stars) {
    final currentStars = _activityStars[activityId] ?? 0;
    if (stars > currentStars) {
      _activityStars[activityId] = stars;
      _storage.saveActivityStars(_activityStars);
    }

    // Siradaki bolume gecis
    _currentLevelIndex++;
    _storage.saveCurrentLevelIndex(_currentLevelIndex);

    // Yildiz basina XP odulu (1 yildiz = 15 XP, 3 yildiz = 45 XP)
    addXp(15 * stars);

    notifyListeners();
  }

  // Kasif Avatar Guncelleme (Seyyah / Traveler)
  void setExplorer({required String animal, required int color, required String accessory}) {
    _avatarAnimal = animal;
    _avatarColor = color;
    _avatarAccessory = accessory;
    _storage.saveAvatarAnimal(animal);
    _storage.saveAvatarColor(color);
    _storage.saveAvatarAccessory(accessory);
    notifyListeners();
  }

  // Elmas Ekleme
  void addGems(int amount) {
    _gems += amount;
    _storage.saveGems(_gems);
    notifyListeners();
  }
}
