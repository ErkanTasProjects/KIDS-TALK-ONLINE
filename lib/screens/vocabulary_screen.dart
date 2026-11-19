import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/kids_theme.dart';

class VocabularyItem {
  final String english;
  final String meaningLabel; // Visual Concept / Context in English (NO Turkish translations!)
  final String phonetic;
  final String category;
  final String emoji;

  const VocabularyItem({
    required this.english,
    required this.meaningLabel,
    required this.phonetic,
    required this.category,
    required this.emoji,
  });
}

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    '👋 Greetings',
    '👨‍👩‍👧 Family',
    '🎒 School',
    '🎨 Colors',
    '🔢 Numbers',
    '⏰ Routines',
  ];

  final List<VocabularyItem> _vocabList = const [
    VocabularyItem(english: 'Hello', meaningLabel: 'Friendly Wave', phonetic: '/həˈloʊ/', category: '👋 Greetings', emoji: '👋'),
    VocabularyItem(english: 'Good morning', meaningLabel: 'Morning Sun', phonetic: '/ɡʊd ˈmɔːrnɪŋ/', category: '👋 Greetings', emoji: '☀️'),
    VocabularyItem(english: 'Good afternoon', meaningLabel: 'Sunny Sky', phonetic: '/ɡʊd ˌæftərˈnuːn/', category: '👋 Greetings', emoji: '🌤️'),
    VocabularyItem(english: 'How are you', meaningLabel: 'Happy Smile', phonetic: '/haʊ ɑːr juː/', category: '👋 Greetings', emoji: '😊'),
    VocabularyItem(english: 'Goodbye', meaningLabel: 'Wave Goodbye', phonetic: '/ɡʊdˈbaɪ/', category: '👋 Greetings', emoji: '🙋‍♂️'),

    VocabularyItem(english: 'Mother', meaningLabel: 'Mom', phonetic: '/ˈmʌðər/', category: '👨‍👩‍👧 Family', emoji: '👩'),
    VocabularyItem(english: 'Father', meaningLabel: 'Dad', phonetic: '/ˈfɑːðər/', category: '👨‍👩‍👧 Family', emoji: '👨'),
    VocabularyItem(english: 'Brother', meaningLabel: 'Young Boy', phonetic: '/ˈbrʌðər/', category: '👨‍👩‍👧 Family', emoji: '👦'),
    VocabularyItem(english: 'Sister', meaningLabel: 'Young Girl', phonetic: '/ˈsɪstər/', category: '👨‍👩‍👧 Family', emoji: '👧'),
    VocabularyItem(english: 'Grandmother', meaningLabel: 'Grandma', phonetic: '/ˈɡrænmʌðər/', category: '👨‍👩‍👧 Family', emoji: '👵'),

    VocabularyItem(english: 'Pencil', meaningLabel: 'Writing Pencil', phonetic: '/ˈpensl/', category: '🎒 School', emoji: '✏️'),
    VocabularyItem(english: 'Book', meaningLabel: 'Story Book', phonetic: '/bʊk/', category: '🎒 School', emoji: '📖'),
    VocabularyItem(english: 'Eraser', meaningLabel: 'Rubber Eraser', phonetic: '/ɪˈreɪsər/', category: '🎒 School', emoji: '🧼'),
    VocabularyItem(english: 'Ruler', meaningLabel: 'Measuring Ruler', phonetic: '/ˈruːlər/', category: '🎒 School', emoji: '📏'),
    VocabularyItem(english: 'Bag', meaningLabel: 'School Backpack', phonetic: '/bæɡ/', category: '🎒 School', emoji: '🎒'),

    VocabularyItem(english: 'Red', meaningLabel: 'Apple Red', phonetic: '/red/', category: '🎨 Colors', emoji: '🔴'),
    VocabularyItem(english: 'Blue', meaningLabel: 'Ocean Blue', phonetic: '/bluː/', category: '🎨 Colors', emoji: '🔵'),
    VocabularyItem(english: 'Green', meaningLabel: 'Forest Green', phonetic: '/ɡriːn/', category: '🎨 Colors', emoji: '🟢'),
    VocabularyItem(english: 'Yellow', meaningLabel: 'Sunshine Yellow', phonetic: '/ˈjeloʊ/', category: '🎨 Colors', emoji: '🟡'),
    VocabularyItem(english: 'Purple', meaningLabel: 'Grape Purple', phonetic: '/ˈpɜːrpl/', category: '🎨 Colors', emoji: '🟣'),

    VocabularyItem(english: 'One', meaningLabel: 'Number 1', phonetic: '/wʌn/', category: '🔢 Numbers', emoji: '1️⃣'),
    VocabularyItem(english: 'Two', meaningLabel: 'Number 2', phonetic: '/tuː/', category: '🔢 Numbers', emoji: '2️⃣'),
    VocabularyItem(english: 'Three', meaningLabel: 'Number 3', phonetic: '/θriː/', category: '🔢 Numbers', emoji: '3️⃣'),
    VocabularyItem(english: 'Four', meaningLabel: 'Number 4', phonetic: '/fɔːr/', category: '🔢 Numbers', emoji: '4️⃣'),
    VocabularyItem(english: 'Five', meaningLabel: 'Number 5', phonetic: '/faɪv/', category: '🔢 Numbers', emoji: '5️⃣'),

    VocabularyItem(english: 'I wake up at 7', meaningLabel: 'Morning Alarm', phonetic: '/aɪ weɪk ʌp/', category: '⏰ Routines', emoji: '⏰'),
    VocabularyItem(english: 'I brush my teeth', meaningLabel: 'Toothbrushing', phonetic: '/aɪ brʌʃ maɪ tiːθ/', category: '⏰ Routines', emoji: '🪥'),
    VocabularyItem(english: 'I eat breakfast', meaningLabel: 'Pancake Breakfast', phonetic: '/aɪ iːt ˈbrekfəst/', category: '⏰ Routines', emoji: '🥞'),
    VocabularyItem(english: 'I go to school', meaningLabel: 'Walk to School', phonetic: '/aɪ ɡoʊ tuː skuːl/', category: '⏰ Routines', emoji: '🎒'),
    VocabularyItem(english: 'I play in the park', meaningLabel: 'Park Fun Slide', phonetic: '/aɪ pleɪ ɪn ðə pɑːrk/', category: '⏰ Routines', emoji: '🛝'),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedCategory == 'All'
        ? _vocabList
        : _vocabList.where((item) => item.category == _selectedCategory).toList();
    // Ogrenilen kelimeler artik AppState'te kalici (eskiden ekrana gomulu sabit listeydi)
    final appState = context.watch<AppState>();
    final learned = appState.learnedWords.toSet();

    final masteredCount = _vocabList.where((v) => learned.contains(v.english)).length;

    return Scaffold(
      backgroundColor: Colors.white,
      // Ust kisim renkli baslik (diger ekranlarla ayni dil); alt bosluk menude
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Column(
              children: [
                KidsHeader(
                  title: 'Word Vault',
                  subtitle: 'Tap, listen and collect words!',
                  color: KidsColors.gem,
                  image: 'assets/images/gigi_thinking.png',
                  trailing: SizedBox(
                    width: 200,
                    child: FatProgressBar(
                      value: masteredCount / _vocabList.length,
                      label: '$masteredCount / ${_vocabList.length} mastered',
                      color: KidsColors.gold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Kategori Cipleri (Yatay Liste)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          SoundService().playTap();
                          setState(() => _selectedCategory = cat);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF8E24AA) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF8E24AA) : Colors.purple.shade100,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: isSelected ? 0.25 : 0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : const Color(0xFF4A148C),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Kart Listesi
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isLearned = learned.contains(item.english);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isLearned ? Colors.green.shade300 : Colors.purple.shade100,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            // Emoji Rozeti
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3E5F5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Kelime Bilgileri (Gorsel Etiket + Ingilizce + Fonetik)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.english,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF263238),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.amber.shade200),
                                        ),
                                        child: Text(
                                          item.meaningLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown.shade700,
                                          ),
                                        ),
                                      ),
                                      ),
                                      if (item.phonetic.isNotEmpty) ...[
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            item.phonetic,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.purple.shade400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Dinleme Butonu
                            GestureDetector(
                              onTap: () {
                                SoundService().speakEnglish(item.english);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.purple.shade200, width: 1.5),
                                ),
                                child: const Icon(Icons.volume_up_rounded, color: Color(0xFF8E24AA), size: 22),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Ogrendim Isareti
                            GestureDetector(
                              onTap: () {
                                SoundService().playCorrect();
                                appState.toggleLearnedWord(item.english);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isLearned ? Colors.green.shade50 : Colors.grey.shade50,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isLearned ? Colors.green : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  isLearned ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: isLearned ? Colors.green : Colors.grey.shade400,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
