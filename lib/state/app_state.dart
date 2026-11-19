import 'package:flutter/material.dart';
import '../data/curriculum_data.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();

  // Kullanici Istatistikleri (yeni kullanici sifirdan baslar)
  int _xp = 0;
  int _hearts = 5;
  int _streak = 1;
  int _gems = 0;
  int _currentLevelIndex = 0;
  String _currentStage = 'Starter';
  String _userName = 'Star Explorer';
  String _avatarAnimal = 'giraffe';
  int _avatarColor = 0xFFFF8A65;
  String _avatarAccessory = 'crown';
  Map<String, int> _activityStars = {};
  List<String> _learnedWords = [];
  bool _isSoundEnabled = true;
  bool _isMusicEnabled = true;
  bool _isVip = false;
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
  bool get isVip => _isVip;
  // Uygulama su an %100 Ingilizce; Turkce arayuz metinleri kaldirildi.
  // Dil ayari ileride veli paneli icin saklaniyor.
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
    _isVip = _storage.isVip();

    _checkStreak();
    _regenHearts();

    _isLoaded = true;
    notifyListeners();
  }

  // Seri Kontrolu (Gunde bir kez kontrol)
  void _checkStreak() {
    final now = DateTime.now();
    // Gun farki takvim gunu olarak hesaplanir. Eskiden saatli "now" ile
    // gece yarisi tarihi karsilastirildigindan, dun aksam girip bugun
    // sabah girildiginde fark 0 ya da yaz saati kaymasiyla yanlis cikabiliyordu.
    // UTC kullanmak yaz saati (DST) kaymasini da onler.
    final today = DateTime.utc(now.year, now.month, now.day);
    final todayStr = "${now.year}-${now.month}-${now.day}";
    final lastActiveStr = _storage.getLastActiveDate();

    if (lastActiveStr == null) {
      _storage.saveLastActiveDate(todayStr);
    } else if (lastActiveStr != todayStr) {
      try {
        final parts = lastActiveStr.split('-').map(int.parse).toList();
        final lastDate = DateTime.utc(parts[0], parts[1], parts[2]);
        final difference = today.difference(lastDate).inDays;

        if (difference == 1) {
          _streak += 1;
          _storage.saveStreak(_streak);
        } else if (difference > 1) {
          _streak = 1; // 1 günden fazla ara verildiyse sıfırla
          _storage.saveStreak(_streak);
        }
        // Her yeni gun canlar tamamen dolar
        if (difference >= 1) {
          _hearts = maxHearts;
          _storage.saveHearts(_hearts);
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

  static const int maxHearts = 5;
  static const Duration heartRegenTime = Duration(minutes: 20);
  static const int heartRefillCost = 20; // elmas

  /// VIP degilse ve can bittiyse ders oynanamaz.
  bool get canPlay => _isVip || _hearts > 0;

  /// Bir sonraki canin dolmasina kalan sure (canlar doluysa null).
  Duration? get timeToNextHeart {
    if (_hearts >= maxHearts) return null;
    final last = _storage.getHeartsUpdatedAt();
    if (last == null) return null;
    final next = DateTime.fromMillisecondsSinceEpoch(last).add(heartRegenTime);
    final left = next.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Gecen sureye gore canlari yeniler (20 dakikada 1 can).
  /// Eskiden canlar sadece ana ekrandaki kalbe dokununca bedavaya doluyordu.
  void refreshHearts() {
    if (_regenHearts()) notifyListeners();
  }

  bool _regenHearts() {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (_hearts >= maxHearts) {
      _storage.saveHeartsUpdatedAt(nowMs);
      return false;
    }
    final last = _storage.getHeartsUpdatedAt() ?? nowMs;
    final gained = (nowMs - last) ~/ heartRegenTime.inMilliseconds;
    if (gained <= 0) {
      if (_storage.getHeartsUpdatedAt() == null) _storage.saveHeartsUpdatedAt(nowMs);
      return false;
    }
    _hearts = (_hearts + gained).clamp(0, maxHearts);
    _storage.saveHearts(_hearts);
    _storage.saveHeartsUpdatedAt(
      _hearts >= maxHearts ? nowMs : last + gained * heartRegenTime.inMilliseconds,
    );
    return true;
  }

  // Can Yenileme (5 Can)
  void refillHearts() {
    _hearts = maxHearts;
    _storage.saveHearts(_hearts);
    _storage.saveHeartsUpdatedAt(DateTime.now().millisecondsSinceEpoch);
    notifyListeners();
  }

  /// Elmasla can doldurma. Yeterli elmas yoksa false.
  bool refillHeartsWithGems() {
    if (_gems < heartRefillCost) return false;
    _gems -= heartRefillCost;
    _storage.saveGems(_gems);
    refillHearts();
    return true;
  }

  // Can Dusurme (Yanlis cevap)
  void useHeart() {
    if (_isVip) return; // Star Club: sinirsiz can
    _regenHearts();
    if (_hearts > 0) {
      if (_hearts == maxHearts) {
        // Yenilenme sayaci ilk kayiptan itibaren baslar
        _storage.saveHeartsUpdatedAt(DateTime.now().millisecondsSinceEpoch);
      }
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

  // Kelime Kasasi: ogrendim isaretini ac/kapa
  void toggleLearnedWord(String word) {
    if (_learnedWords.contains(word)) {
      _learnedWords.remove(word);
    } else {
      _learnedWords.add(word);
    }
    _storage.saveLearnedWords(_learnedWords);
    notifyListeners();
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

    // Siradaki bolume gecis: sadece su anki (en son acik) Starter dersi
    // bitirildiginde. Eskiden eski bir dersi tekrar oynamak da yeni ders
    // aciyordu (ayni dersi 4 kez oynayan Movers'i aciyordu).
    final starter = CurriculumData.getActivitiesByStage('Starter');
    final idx = starter.indexWhere((a) => a.id == activityId);
    if (idx != -1 && idx == _currentLevelIndex) {
      _currentLevelIndex++;
      _storage.saveCurrentLevelIndex(_currentLevelIndex);
    }

    // Yildiz basina XP ve elmas odulu (1 yildiz = 15 XP + 5 elmas)
    _gems += 5 * stars;
    _storage.saveGems(_gems);
    addXp(15 * stars);
  }

  // --- Gorevler ---
  static const int chestStarGoal = 20;
  bool get isChestOpened => _storage.isChestOpened();
  bool get canOpenChest => !isChestOpened && totalStars >= chestStarGoal;

  /// Sandik sadece hedef yildiza ulasinca ve bir kez acilir.
  /// (Eskiden 0 yildizla acilabiliyor, yeniden baslatinca tekrar aciliyordu.)
  bool openChest() {
    if (!canOpenChest) return false;
    _storage.setChestOpened(true);
    _gems += 50;
    _storage.saveGems(_gems);
    addXp(50);
    return true;
  }

  static String _todayKey() {
    final n = DateTime.now();
    return "${n.year}-${n.month}-${n.day}";
  }

  bool get listenedToday => _storage.getDailyListenDate() == _todayKey();

  void markListenedToday() {
    if (listenedToday) return;
    _storage.saveDailyListenDate(_todayKey());
    notifyListeners();
  }

  bool get hasThreeStarLesson => _activityStars.values.any((v) => v >= 3);

  // VIP (Star Club) uyeligi
  void setVip(bool value) {
    _isVip = value;
    _storage.setVip(value);
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
