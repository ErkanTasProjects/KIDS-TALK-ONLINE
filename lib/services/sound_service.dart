import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Kids Talk Online - Ozel Studyo Ses Motoru
/// Tum sesler YALNIZCA ElevenLabs (Marie) studyo kayitlarindan calar.
/// Sistem cihazinin robotik TTS motoru ve harici tum yabanci sesler tamamen engellenmistir.
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
  final Map<String, String> _voicePack = {
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

  Future<void> init() async {
    try {
      await _speechPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.25);
    } catch (e) {
      debugPrint("SoundService init error: $e");
    }
  }

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

  /// Sadece ve sadece ElevenLabs studyo kayitlarini calar.
  Future<void> speakEnglish(String text, {bool slow = false}) async {
    if (!isSoundEnabled || text.trim().isEmpty) return;

    final normalized = text.trim().toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final direct = text.trim().toLowerCase();

    String? audio = _voicePack[direct] ?? _voicePack[normalized];

    // Cumle icinden anahtar kelime eslesmesi (orn: "One! Delicious Apples!" -> "one")
    if (audio == null) {
      final words = normalized.split(' ');
      for (final w in words) {
        if (_voicePack.containsKey(w)) {
          audio = _voicePack[w];
          break;
        }
      }
    }

    if (audio != null) {
      try {
        await _speechPlayer.stop();
        final effectiveRate = slow ? 0.75 : _currentSpeechRate;
        await _speechPlayer.setPlaybackRate(effectiveRate);
        await _speechPlayer.play(AssetSource('sounds/speech/$audio'));
      } catch (e) {
        debugPrint("Studio audio play error ($audio): $e");
      }
    }
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

  Future<void> setSpeechRate(double rate) async {
    // Slider 0.25 - 0.85 araliginda; bunu 0.65x - 1.45x normal konusma hizina esler
    _currentSpeechRate = (rate * 1.5).clamp(0.5, 2.0);
    try {
      await _speechPlayer.setPlaybackRate(_currentSpeechRate);
    } catch (e) {
      debugPrint("setSpeechRate error: $e");
    }
  }
  Future<void> setPitch(double pitch) async {}

  Future<void> stop() async {
    try {
      await _speechPlayer.stop();
      await _sfxPlayer.stop();
    } catch (_) {}
  }
}
