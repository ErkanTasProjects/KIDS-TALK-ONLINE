import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kids_talk_online/data/curriculum_data.dart';
import 'package:kids_talk_online/services/sound_service.dart';
import 'package:kids_talk_online/services/storage_service.dart';
import 'package:kids_talk_online/state/app_state.dart';

/// AppState yuklenene kadar bekler (constructor async storage okur).
Future<AppState> _loadedState() async {
  final state = AppState();
  for (var i = 0; i < 50 && !state.isLoaded; i++) {
    await Future<void>.delayed(Duration.zero);
  }
  expect(state.isLoaded, isTrue);
  return state;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CurriculumData', () {
    test('aktivite id leri benzersiz', () {
      final ids = CurriculumData.activities.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('her aktivite turunun gerekli verisi var', () {
      const requiredKey = {
        'matching': 'pairs',
        'drag_drop': 'targets',
        'schedule_drag': 'targets',
        'trace': 'letters',
        'listen_choose': 'questions',
        'balloon_pop': 'rounds',
        'sentence_builder': 'sentences',
        'memory': 'cards',
        'hidden_object': 'objects',
        'fill_blank': 'questions',
        'speak_record': 'prompts',
        'color_train': 'cars',
      };
      for (final a in CurriculumData.activities) {
        final key = requiredKey[a.activityType];
        if (key == null) continue;
        final list = a.gameData[key];
        expect(list, isA<List>(), reason: '${a.id} icin "$key" eksik');
        expect((list as List).isNotEmpty, isTrue, reason: '${a.id} "$key" bos');
      }
    });

    test('dinle-sec ve balon sorularinda dogru cevap seceneklerde var', () {
      for (final a in CurriculumData.activities) {
        if (a.activityType == 'listen_choose') {
          for (final q in a.gameData['questions'] as List) {
            final names = (q['options'] as List).map((o) => o['name']).toList();
            expect(names, contains(q['target']), reason: a.id);
            expect((q['soundText'] as String).trim(), isNotEmpty, reason: a.id);
          }
        }
        if (a.activityType == 'balloon_pop') {
          for (final r in a.gameData['rounds'] as List) {
            expect(r['options'] as List, contains(r['target']), reason: a.id);
          }
        }
      }
    });
  });

  group('SoundService', () {
    test('noktalama ve buyuk harf farki studyo kaydini bulur', () {
      expect(SoundService.studioFileFor('This is my bag.'), 'this_is_my_bag.mp3');
      expect(SoundService.studioFileFor('  Good Morning! '), 'good_morning.mp3');
      expect(SoundService.studioFileFor('I wake up at 7.'), 'i_wake_up_at_7.mp3');
    });

    test('kaydi olmayan cumlede yanlis kelime sesi calmaz (TTS e duser)', () {
      // Eskiden "How's it going?" -> "how.mp3", "My brother likes..." -> "brother.mp3"
      expect(SoundService.studioFileFor("How's it going?"), isNull);
      expect(SoundService.studioFileFor('My brother likes playing computer games.'), isNull);
      expect(SoundService.studioFileFor('This is my notebook.'), isNull);
    });

    test('haritadaki tum ses dosyalari assets icinde mevcut', () {
      for (final f in SoundService.studioFiles) {
        expect(File('assets/sounds/speech/$f').existsSync(), isTrue, reason: f);
      }
      for (final f in ['pop.wav', 'correct.wav', 'wrong.wav', 'victory.wav', 'tap.wav', 'whoosh.wav', 'bgm.wav']) {
        expect(File('assets/sounds/$f').existsSync(), isTrue, reason: f);
      }
    });
  });

  group('AppState', () {
    setUp(() {
      SharedPreferences.resetStatic();
      SharedPreferences.setMockInitialValues({});
      StorageService().resetForTesting();
    });

    test('yeni kullanici sifir ilerlemeyle baslar', () async {
      final s = await _loadedState();
      expect(s.xp, 0);
      expect(s.gems, 0);
      expect(s.totalStars, 0);
      expect(s.learnedWords, isEmpty);
      expect(s.currentLevelIndex, 0);
      expect(s.isVip, isFalse);
    });

    test('sadece mevcut ders bitince yeni ders acilir', () async {
      final s = await _loadedState();
      final starter = CurriculumData.getActivitiesByStage('Starter');

      s.completeActivity(starter[0].id, 3);
      expect(s.currentLevelIndex, 1);

      // Eski dersi tekrar oynamak yeni ders acmamali
      s.completeActivity(starter[0].id, 3);
      expect(s.currentLevelIndex, 1);

      s.completeActivity(starter[1].id, 2);
      expect(s.currentLevelIndex, 2);
      expect(s.getStarsFor(starter[1].id), 2);
    });

    test('yanlis cevap can dusurur, VIP te dusurmez', () async {
      final s = await _loadedState();
      s.useHeart();
      expect(s.hearts, 4);
      s.setVip(true);
      s.useHeart();
      expect(s.hearts, 4);
    });

    test('can bitince oynanamaz, elmasla dolar', () async {
      final s = await _loadedState();
      for (var i = 0; i < AppState.maxHearts; i++) {
        s.useHeart();
      }
      expect(s.hearts, 0);
      expect(s.canPlay, isFalse);
      expect(s.refillHeartsWithGems(), isFalse); // 0 elmas

      // 4 ders x 3 yildiz = 60 elmas
      for (final a in CurriculumData.getActivitiesByStage('Starter')) {
        s.completeActivity(a.id, 3);
      }
      expect(s.gems, 60);
      expect(s.refillHeartsWithGems(), isTrue);
      expect(s.hearts, AppState.maxHearts);
      expect(s.gems, 60 - AppState.heartRefillCost);
    });

    test('sandik yildiz hedefine ulasmadan acilmaz, bir kez acilir', () async {
      final s = await _loadedState();
      expect(s.openChest(), isFalse);
      for (final a in CurriculumData.activities.take(7)) {
        s.completeActivity(a.id, 3); // 21 yildiz
      }
      expect(s.canOpenChest, isTrue);
      expect(s.openChest(), isTrue);
      expect(s.openChest(), isFalse);
    });

    test('ogrenilen kelime ac/kapa', () async {
      final s = await _loadedState();
      s.toggleLearnedWord('Cat');
      expect(s.learnedWords, contains('Cat'));
      s.toggleLearnedWord('Cat');
      expect(s.learnedWords, isNot(contains('Cat')));
    });
  });
}
