import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Kids Talk Online - Ozel Studyo Ses Motoru
/// Oncelik ElevenLabs (Marie) studyo kayitlarinda; kaydi olmayan metinler
/// cihazin TTS motoruyla okunur ki hicbir soru sessiz kalmasin.
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _speechPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  bool isSoundEnabled = true;
  bool isMusicEnabled = true;

  // ElevenLabs (Marie - Young & Optimistic) ozel studyo ses haritasi
  static final Map<String, String> _voicePack = {
    // 1. Karakter & Replikler
    "hello! i am gigi! let's explore new english adventures!": "gigi_intro.mp3",
    "hello! i am gigi the giraffe! let's explore english together!": "gigi_intro.mp3",
    "hello! i am gigi! let's learn english together!": "gigi_intro.mp3",
    "great job! you did it!": "great_job.mp3",
    "great job!": "great_job.mp3",
    "awesome job! you earned three stars!": "victory.mp3",
    "try again!": "try_again.mp3",
    "try again": "try_again.mp3",
    "treasure chest opened! you earned 50 xp and a super star badge!": "treasure_chest.mp3",
    "full hearts! ready to play!": "full_hearts.mp3",
    "hearts refilled!": "hearts_refilled.mp3",
    "delicious!": "delicious.mp3",
    "awesome!": "awesome.mp3",

    // 2. Sayilar (Marie)
    "one": "one.mp3",
    "two": "two.mp3",
    "three": "three.mp3",
    "four": "four.mp3",
    "five": "five.mp3",

    // 3. Meyve ve Yiyecek (Marie)
    "apple": "apple.mp3",
    "apples": "apple.mp3",

    // 4. Renkler (Marie)
    "red": "red.mp3",
    "blue": "blue.mp3",
    "green": "green.mp3",
    "yellow": "yellow.mp3",
    "purple": "purple.mp3",
    "orange": "colors_group.mp3",
    "pink": "colors_group.mp3",
    "brown": "colors_group.mp3",

    // 5. Hayvanlar & Okul Esyalari & Aile
    "cat": "cat.mp3",
    "dog": "dog.mp3",
    "bird": "bird.mp3",
    "fish": "fish.mp3",
    "rabbit": "rabbit.mp3",
    "book": "book.mp3",
    "this is my book": "this_is_my_book.mp3",
    "bag": "bag.mp3",
    "this is my bag": "this_is_my_bag.mp3",
    "school bag": "bag.mp3",
    "pencil": "pencil.mp3",
    "eraser": "eraser.mp3",
    "ruler": "ruler.mp3",
    "draw": "draw.mp3",
    "i draw": "i_draw.mp3",
    "father": "father.mp3",
    "mother": "mother.mp3",
    "brother": "brother.mp3",
    "sister": "sister.mp3",
    "grandmother": "grandmother.mp3",
    "hello": "hello.mp3",
    "goodbye": "goodbye.mp3",
    "good morning": "good_morning.mp3",
    "good afternoon": "good_afternoon.mp3",
    "how": "how.mp3",
    "how are you": "how_are_you.mp3",
    "nice to meet you": "nice_to_meet_you.mp3",
    "see you later": "see_you_later.mp3",
    "have a nice day": "have_a_nice_day.mp3",
    "hi there": "hi_there.mp3",
    "hi there!": "hi_there.mp3",

    // 6. Gunluk Rutinler & Okul & Cumleler
    "i wake up at 7": "i_wake_up_at_7.mp3",
    "i wake up at 7.": "i_wake_up_at_7.mp3",
    "i get up at 7": "i_get_up_at_7.mp3",
    "i brush my teeth": "i_brush_my_teeth.mp3",
    "i brush my teeth.": "i_brush_my_teeth.mp3",
    "i eat breakfast": "i_eat_breakfast.mp3",
    "i eat breakfast.": "i_eat_breakfast.mp3",
    "i eat breakfast at 8": "i_eat_breakfast_at_8.mp3",
    "i eat breakfast at 8.": "i_eat_breakfast_at_8.mp3",
    "i go to school": "i_go_to_school.mp3",
    "i go to school.": "i_go_to_school.mp3",
    "i go to school by bus": "i_go_to_school_by_bus.mp3",
    "i go to school by bus.": "i_go_to_school_by_bus.mp3",
    "i play in the park": "i_play_in_the_park.mp3",
    "i play in the park.": "i_play_in_the_park.mp3",
    "i go to bed at 9": "i_go_to_bed_at_9.mp3",
    "i go to bed at 9.": "i_go_to_bed_at_9.mp3",
    "i do my homework after school": "i_do_my_homework_after_school.mp3",
    "i read a book": "i_read_a_book.mp3",
    "read a book": "read_a_book.mp3",
    "i drink cold milk": "i_drink_cold_milk.mp3",
    "we eat fresh bread": "we_eat_fresh_bread.mp3",
    "bananas are sweet": "bananas_are_sweet.mp3",
    "i like red apples": "i_like_red_apples.mp3",
    "i like playing football": "i_like_playing_football.mp3",
    "i love playing football": "i_like_playing_football.mp3",
    "football": "i_like_playing_football.mp3",
    "i live in a city": "i_live_in_a_city.mp3",
    "city picture": "i_live_in_a_city.mp3",
    "my name is alex": "my_name_is_alex.mp3",
    "name badge": "my_name_is_alex.mp3",
    "birthday cake": "delicious.mp3",
    "i am ten years old": "i_am_ten_years_old.mp3",

    // 7. Okul Dersleri
    "i have english on monday": "i_have_english_on_monday.mp3",
    "i have english on monday.": "i_have_english_on_monday.mp3",
    "math is my favorite subject": "math_is_my_favorite_subject.mp3",
    "math is my favorite subject.": "math_is_my_favorite_subject.mp3",
    "i like english": "i_like_english.mp3",
    "i like english.": "i_like_english.mp3",
    "i have science today": "i_have_science_today.mp3",
    "i have science today.": "i_have_science_today.mp3",
    "art is fun": "art_is_fun.mp3",
    "art is fun.": "art_is_fun.mp3",
    "i have pe on friday": "i_have_pe_on_friday.mp3",
    "i have pe on friday.": "i_have_pe_on_friday.mp3",

    "amazing": "amazing.mp3",
    "fantastic": "fantastic.mp3",
    "well done": "well_done.mp3",
    "super": "super.mp3",
  };

  final FlutterTts _tts = FlutterTts();
  bool _ttsReady = false;

  AppLifecycleListener? _lifecycle;
  bool _bgmWasPlaying = false;

  /// Uygulama arka plana gidince tum sesleri durdurur, geri gelince muzigi
  /// kaldigi yerden surdurur. (Eskiden uygulamadan cikinca muzik ve konusma
  /// arkada calmaya devam ediyordu.)
  void _listenLifecycle() {
    _lifecycle ??= AppLifecycleListener(
      onHide: _onAppHidden,
      onShow: _onAppShown,
      onDetach: _onAppHidden,
    );
  }

  Future<void> _onAppHidden() async {
    _bgmWasPlaying = _bgmPlayer.state == PlayerState.playing;
    await _stopSpeech();
    try {
      await _sfxPlayer.stop();
    } catch (_) {}
    try {
      await _bgmPlayer.pause();
    } catch (_) {}
  }

  Future<void> _onAppShown() async {
    if (_bgmWasPlaying && isMusicEnabled) {
      try {
        await _bgmPlayer.resume();
      } catch (_) {}
    }
    _bgmWasPlaying = false;
  }

  Future<void> init() async {
    _listenLifecycle();
    try {
      await _speechPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.25);
      // Android'de varsayilan "gain" odagi, bir oynatici baslayinca digerini
      // susturuyordu (efekt sesi soruyu kesiyor, konusma muzigi durduruyordu).
      // Tum oynaticilar birlikte calabilsin:
      final ctx = AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build();
      await AudioPlayer.global.setAudioContext(ctx);
      for (final p in [_speechPlayer, _sfxPlayer, _bgmPlayer]) {
        await p.setAudioContext(ctx);
      }
    } catch (e) {
      debugPrint("SoundService init error: $e");
    }
    await _initTts();
  }

  /// Studyo kaydi olmayan cumleler icin yedek ses motoru (cihaz TTS).
  /// Boylece hicbir soru sessiz kalmaz.
  Future<void> _initTts() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
        );
      }
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.15);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(false);
      _ttsReady = true;
    } catch (e) {
      debugPrint("TTS init error: $e");
    }
  }

  /// Metin icin birebir studyo kaydi varsa dosya adini, yoksa null dondurur.
  /// (Kelime kelime "tahmin" yapilmaz; yanlis ses calmaktansa TTS okunur.)
  @visibleForTesting
  static String? studioFileFor(String text) =>
      _voicePack[text.trim().toLowerCase()] ?? _voicePack[_normalize(text)];

  @visibleForTesting
  static Iterable<String> get studioFiles => _voicePack.values.toSet();

  /// Metni ses dosyasi anahtarina cevirir: "This is my bag." -> "this is my bag"
  static String _normalize(String text) => text
      .trim()
      .toLowerCase()
      .replaceAll('’', "'")
      .replaceAll(RegExp(r"[^\w\s']"), '')
      .replaceAll("'", '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// Emoji ve sembolleri TTS'ten once temizler (cihaz emojileri okumaya calismasin).
  static String _cleanForTts(String text) => text
      .replaceAll(RegExp(r'[^\x20-\x7E’]'), ' ')
      .replaceAll('___', ' blank ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  void setAudioSettings({required bool soundEnabled, required bool musicEnabled}) {
    isSoundEnabled = soundEnabled;
    isMusicEnabled = musicEnabled;

    if (!isSoundEnabled) {
      stop();
    }
    if (!isMusicEnabled) {
      stopBgm();
    } else {
      startBgm();
    }
  }

  Future<void> startBgm() async {
    if (!isMusicEnabled) return;
    try {
      await _bgmPlayer.play(AssetSource('sounds/bgm.wav'));
    } catch (e) {
      debugPrint("BGM error: $e");
    }
  }

  Future<void> stopBgm() async {
    try {
      await _bgmPlayer.stop();
    } catch (_) {}
  }

  double _currentSpeechRate = 1.0;

  /// Once ElevenLabs studyo kaydini calar; birebir kayit yoksa cihaz TTS ile okur.
  /// (Eskiden kayit bulunamayan sorular tamamen sessiz kaliyordu, kelime
  /// eslestirmesi de yanlis ses caliyordu: "How's it going?" -> "how".)
  Future<void> speakEnglish(String text, {bool slow = false}) async {
    if (!isSoundEnabled || text.trim().isEmpty) return;

    final audio = studioFileFor(text);

    await _stopSpeech();

    if (audio != null) {
      try {
        await _speechPlayer.play(AssetSource('sounds/speech/$audio'));
        // Her seferinde ayarla: yavas oynatmadan sonra hiz 0.75'te kalmasin
        final effectiveRate = slow ? 0.75 : _currentSpeechRate;
        try {
          await _speechPlayer.setPlaybackRate(effectiveRate);
        } catch (_) {}
        return;
      } catch (e) {
        debugPrint("Studio audio play error ($audio): $e -> TTS fallback");
      }
    }

    await _speakTts(text, slow: slow);
  }

  Future<void> _speakTts(String text, {bool slow = false}) async {
    if (!_ttsReady) await _initTts();
    final clean = _cleanForTts(text);
    if (clean.isEmpty) return;
    try {
      // _currentSpeechRate 0.5-2.0 araliginda -> TTS 0.25-0.6
      final double rate = slow ? 0.28 : (0.42 * _currentSpeechRate).clamp(0.25, 0.6).toDouble();
      await _tts.setSpeechRate(rate);
      await _tts.speak(clean);
    } catch (e) {
      debugPrint("TTS speak error: $e");
    }
  }

  Future<void> _stopSpeech() async {
    try {
      await _speechPlayer.stop();
    } catch (_) {}
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> speakEnglishSlow(String text) async {
    await speakEnglish(text, slow: true);
  }

  Future<void> speakTurkish(String text) async {}

  // UI Ses Efektleri
  void _playSfx(String fileName) async {
    if (!isSoundEnabled) return;
    try {
      await _sfxPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint("SFX error ($fileName): $e");
    }
  }

  void playPop() => _playSfx('pop.wav');
  void playCorrect() => _playSfx('correct.wav');
  void playVictory() => _playSfx('victory.wav');
  void playWrong() => _playSfx('wrong.wav');
  void playWhoosh() => _playSfx('whoosh.wav');
  void playTap() => _playSfx('tap.wav');

  /// Profil ekranindaki kaydiricinin son konumu (ekran her acildiginda
  /// sifirlanmasin diye burada tutulur). 0.48 = Normal.
  double speechSliderValue = 0.48;

  Future<void> setSpeechRate(double sliderValue) async {
    // Kaydirici 0.25 (yavas) - 0.48 (normal) - 0.85 (hizli) -> 0.6x - 1.0x - 1.4x.
    // Eskiden "rate * 1.5" kullaniliyordu: kaydiricinin alt yarisi hic
    // fark yaratmiyor, "Normal" konumu gercekte 0.72x caliyordu.
    speechSliderValue = sliderValue;
    final v = sliderValue.clamp(0.25, 0.85).toDouble();
    _currentSpeechRate = v < 0.48
        ? 1.0 - (0.48 - v) / 0.23 * 0.4
        : 1.0 + (v - 0.48) / 0.37 * 0.4;
    try {
      await _speechPlayer.setPlaybackRate(_currentSpeechRate);
    } catch (e) {
      debugPrint("setSpeechRate error: $e");
    }
  }
  Future<void> setPitch(double pitch) async {}

  Future<void> stop() async {
    await _stopSpeech();
    try {
      await _sfxPlayer.stop();
    } catch (_) {}
  }
}
