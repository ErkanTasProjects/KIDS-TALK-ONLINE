# Kids Talk Online 🦒

Çocuklar için oyunlaştırılmış İngilizce öğrenme uygulaması (Flutter).
Cambridge YLE seviyelerine göre (Starter / Movers / Flyers) Duolingo tarzı bir harita üzerinde
mini oyunlar: eşleştirme, sürükle-bırak, harf çizme, dinle-seç, balon patlatma, cümle kurma,
hafıza kartları, gizli nesne, boşluk doldurma, konuşma.

## Çalıştırma

```bash
flutter pub get
flutter run            # bağlı cihaz / emülatör
flutter test           # birim testleri
flutter build apk      # Android APK
```

## Klasör yapısı

| Yol | İçerik |
| --- | --- |
| `lib/data/curriculum_data.dart` | Tüm dersler ve oyun verileri |
| `lib/screens/` | Ekranlar (`lesson_screen.dart` tüm mini oyunları içerir) |
| `lib/services/sound_service.dart` | Ses motoru: önce stüdyo kaydı (`assets/sounds/speech`), yoksa cihaz TTS |
| `lib/services/storage_service.dart` | `shared_preferences` ile kalıcı veri |
| `lib/state/app_state.dart` | XP, can, seri, yıldız, VIP durumu (Provider) |
| `assets/` | Görseller, efekt sesleri, ElevenLabs konuşma kayıtları |
| `tools/` | Tek seferlik geliştirme scriptleri (uygulamaya dahil değil) |
| `docs/` | Proje dokümanı |
| `web-app/` | Ayrı Vite + Capacitor web sürümü |

## Ses

`SoundService.speakEnglish(text)` metni normalize edip (`"This is my bag."` → `this is my bag`)
`_voicePack` haritasında stüdyo kaydı arar. Birebir kayıt yoksa cihazın İngilizce TTS motoruyla okur,
böylece hiçbir soru sessiz kalmaz. Yeni bir kayıt eklemek için mp3'ü `assets/sounds/speech/` içine koyup
haritaya ekleyin. Eksik kayıtların listesi: `tools/missing_speech.txt`.

## Bilinen eksikler

- **Ödeme yok:** Star Club ekranı ebeveyn kilidinden sonra VIP'i cihazda yerel olarak açar.
  Gerçek abonelik için `in_app_purchase` veya RevenueCat entegrasyonu gerekli.
- **Konuşma oyunu** mikrofonu gerçekten dinlemiyor, 3 saniye sonra başarılı sayıyor.
