import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/curriculum_data.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../widgets/bouncy_button.dart';
import '../widgets/kids_characters.dart';
import '../widgets/victory_dialog.dart';

class LessonScreen extends StatefulWidget {
  final ActivityItem activity;

  const LessonScreen({super.key, required this.activity});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with TickerProviderStateMixin {
  int _currentStepIndex = 0;
  bool _isStepCompleted = false;
  bool _showCelebration = false;
  String _characterFeedback = '';

  // Eslestirme (Matching) durumu: Karisik gorsel ve Ingilizce listeler
  late List<dynamic> _shuffledVisualPairs;
  late List<dynamic> _shuffledEnglishPairs;
  String? _selectedEnglish;
  String? _selectedVisualId;
  final Set<String> _matchedPairs = {};

  // Surukle & Birak durumu
  final Map<int, String> _placedTargets = {};
  String? _selectedSentence;

  // Harf Cizme durumu
  final List<Offset?> _tracePoints = [];
  bool _isLetterCompleted = false;

  // Cumle Kurma durumu
  List<String> _builtWords = [];

  // Hafiza Oyunu durumu
  final List<int> _flippedIndices = [];
  final Set<int> _matchedIndices = {};

  // Gizli Nesne durumu
  final Set<int> _foundObjects = {};

  // Konusma durumu
  bool _isRecording = false;

  // Sayi & Meyve Besleme Oyunu Durumu (Feed Gigi)
  int _fedCount = 0;

  // Renkli Vagon Treni Oyunu Durumu
  final List<String> _placedTrainCars = [];
  List<String> _shuffledSentenceWords = [];
  int _lastSentenceIndex = -1;

  // Balon Patlatma durumu (Gercek Patlama & Titreme animasyonu)
  int? _poppedBalloonIndex;
  int? _wrongBalloonIndex;

  // Adim basina karistirilmis secenekler haritasi (Adim indeksine gore sabit/karisik liste)
  final Map<int, List<dynamic>> _shuffledListenChooseOptions = {};
  final Map<int, List<dynamic>> _shuffledBalloonPopOptions = {};
  final Map<int, List<dynamic>> _shuffledFillBlankOptions = {};

  // Hata sayisi -> yildiz (eskiden her ders hatasiz da hatali da 3 yildizdi)
  int _mistakes = 0;
  int get _earnedStars => _mistakes == 0 ? 3 : (_mistakes <= 2 ? 2 : 1);
  bool _outOfHeartsShown = false;

  // Sorular arasi gecis geri bildirimi
  bool _isAdvancing = false;
  String? _correctChoice;
  String? _wrongChoice;

  @override
  void initState() {
    super.initState();
    _characterFeedback = widget.activity.characterQuote;

    // Eslestirme kartlarinin rastgele siralanmasi (Gorsel ve Ingilizce)
    if (widget.activity.activityType == 'matching') {
      final pairs = List.from(widget.activity.gameData['pairs'] as List<dynamic>);
      _shuffledVisualPairs = List.from(pairs)..shuffle(Random());
      _shuffledEnglishPairs = List.from(pairs)..shuffle(Random());
    } else {
      _shuffledVisualPairs = [];
      _shuffledEnglishPairs = [];
    }

    // Ilk soruyu seslendir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playInitialAudio();
    });
  }

  void _playInitialAudio() {
    if (widget.activity.activityType == 'listen_choose') {
      final questions = widget.activity.gameData['questions'] as List<dynamic>;
      final currentQ = questions[_currentStepIndex];
      SoundService().speakEnglish(currentQ['soundText'] as String);
    } else if (widget.activity.activityType == 'balloon_pop') {
      final rounds = widget.activity.gameData['rounds'] as List<dynamic>;
      final currentRound = rounds[_currentStepIndex];
      SoundService().speakEnglish(currentRound['target'] as String);
    }
  }

  void _triggerSuccess() {
    if (_isStepCompleted) return;
    SoundService().playCorrect();
    setState(() {
      _isStepCompleted = true;
      _showCelebration = true;
      _characterFeedback = 'Awesome! You completed all challenges! 🎉';
    });

    SoundService().speakEnglish("Great job! You did it!");

    // Kutlama perdesi kisa bir sure gorunup kalksin (eskiden hic kalkmiyor,
    // oyunun ustunde sari perde + dev emoji olarak kaliyordu)
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _showCelebration = false);
    });
  }

  /// Dogru cevaptan sonra kisa bir "dogru!" anini gosterip sonraki soruya gecer.
  /// Eskiden yeni soru aninda beliriyor, cocuk dogru bildigini goremiyordu.
  void _advanceAfterCorrect({required int total, VoidCallback? onNext}) {
    _isAdvancing = true;
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        _isAdvancing = false;
        _correctChoice = null;
        _wrongChoice = null;
        if (_currentStepIndex < total - 1) {
          _currentStepIndex++;
          onNext?.call();
        } else {
          _triggerSuccess();
        }
      });
    });
  }

  void _flashWrong(String choice) {
    setState(() => _wrongChoice = choice);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && _wrongChoice == choice) setState(() => _wrongChoice = null);
    });
  }

  bool _isFinishing = false;

  /// Yanlis cevap: can dusur, hata say, can bittiyse dersi durdur.
  void _registerMistake() {
    final appState = context.read<AppState>();
    appState.useHeart();
    setState(() => _mistakes++);
    if (!appState.canPlay && !_outOfHeartsShown) {
      _outOfHeartsShown = true;
      _showOutOfHeartsDialog();
    }
  }

  Future<void> _showOutOfHeartsDialog() async {
    final appState = context.read<AppState>();
    final wait = appState.timeToNextHeart;
    final mins = wait == null ? 0 : (wait.inSeconds / 60).ceil();
    final canBuy = appState.gems >= AppState.heartRefillCost;

    final refilled = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("💔 Out of hearts!", textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
          mins > 0
              ? "Take a little break! A new heart comes in $mins min."
              : "Take a little break and come back soon!",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("EXIT"),
          ),
          if (canBuy)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ACC1),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.read<AppState>().refillHeartsWithGems();
                Navigator.of(ctx).pop(true);
              },
              child: Text("REFILL 💎 ${AppState.heartRefillCost}"),
            ),
        ],
      ),
    );
    if (!mounted) return;
    if (refilled == true) {
      _outOfHeartsShown = false;
      SoundService().speakEnglish("Hearts refilled!");
    } else {
      SoundService().stop();
      Navigator.of(context).pop();
    }
  }

  void _finishActivity() {
    if (_isFinishing) return; // cift tiklamada iki diyalog/cift odul olmasin
    _isFinishing = true;
    SoundService().playVictory();
    final stars = _earnedStars;
    // Odul tek yerden: completeActivity 15 XP x yildiz verir. Eskiden ayrica
    // +15 XP daha ekleniyordu ve diyalogda yazan XP ile verilen tutmuyordu.
    context.read<AppState>().completeActivity(widget.activity.id, stars);
    VictoryCelebrationDialog.show(
      context: context,
      characterName: widget.activity.characterName,
      activityTitle: widget.activity.title,
      stars: stars,
      xpEarned: 15 * stars,
      onContinue: () {
        Navigator.of(context).pop();
      },
    );
  }

  double _getProgress() {
    if (_isStepCompleted) return 1.0;
    switch (widget.activity.activityType) {
      case 'matching':
        final pairs = widget.activity.gameData['pairs'] as List<dynamic>;
        return (_matchedPairs.length / pairs.length).clamp(0.08, 1.0);
      case 'drag_drop':
      case 'schedule_drag':
        final targets = widget.activity.gameData['targets'] as List<dynamic>;
        return (_placedTargets.length / targets.length).clamp(0.08, 1.0);
      case 'memory':
        final cards = widget.activity.gameData['cards'] as List<dynamic>;
        return (_matchedIndices.length / cards.length).clamp(0.08, 1.0);
      case 'hidden_object':
        final objects = widget.activity.gameData['objects'] as List<dynamic>;
        return (_foundObjects.length / objects.length).clamp(0.08, 1.0);
      case 'trace':
        final letters = widget.activity.gameData['letters'] as List<dynamic>;
        return ((_currentStepIndex + (_isLetterCompleted ? 1 : 0)) / letters.length).clamp(0.08, 1.0);
      case 'count_feed':
        final targetNum = widget.activity.gameData['targetNumber'] as int? ?? 5;
        return (_fedCount / targetNum).clamp(0.08, 1.0);
      case 'color_train':
        final cars = widget.activity.gameData['cars'] as List<dynamic>? ?? [];
        return (_placedTrainCars.length / (cars.isNotEmpty ? cars.length : 1)).clamp(0.08, 1.0);
      default:
        int total = 5;
        if (widget.activity.gameData['questions'] != null) {
          total = (widget.activity.gameData['questions'] as List).length;
        } else if (widget.activity.gameData['rounds'] != null) {
          total = (widget.activity.gameData['rounds'] as List).length;
        } else if (widget.activity.gameData['sentences'] != null) {
          total = (widget.activity.gameData['sentences'] as List).length;
        } else if (widget.activity.gameData['prompts'] != null) {
          total = (widget.activity.gameData['prompts'] as List).length;
        }
        return ((_currentStepIndex + 0.1) / total).clamp(0.08, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hearts = context.watch<AppState>().hearts;

    return CelebrationOverlay(
      showCelebration: _showCelebration,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF9FE),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          // Acik zemin: durum cubugu simgeleri koyu olsun (saat gorunmuyordu)
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: GestureDetector(
              onTap: () {
                SoundService().stop();
                Navigator.of(context).pop();
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.close_rounded, color: Color(0xFF2D3748), size: 22),
              ),
            ),
          ),
          title: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: _getProgress(),
                backgroundColor: const Color(0xFFE8E5F5),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              // Kalan yildizlar + canlar (eskiden sabit 3 yildizdi, can gorunmuyordu)
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(3, (i) => Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: i < _earnedStars ? const Color(0xFFFFB300) : Colors.grey.shade300,
                      )),
                  const SizedBox(width: 8),
                  Text(
                    context.watch<AppState>().isVip ? "💖∞" : "💖$hearts",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFE53935)),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 6),
              // Maskot Rehberlik Baloncugu (Gigi)
              CharacterDialogueBox(
                characterName: widget.activity.characterName,
                // Not: CharacterDialogueBox mesaji zaten kendisi okuyor;
                // burada tekrar okutmak sesi bastan baslatip kesiyordu.
                message: _characterFeedback,
              ),

              // Ana Oyun Alani
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  // Sorular arasi yumusak gecis (eskiden yeni soru aniden beliriyordu)
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    layoutBuilder: (current, previous) => Stack(
                      fit: StackFit.expand,
                      children: [
                        ...previous.map((w) => IgnorePointer(child: w)),
                        if (current != null) current,
                      ],
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_currentStepIndex),
                      child: _buildActivityGame(),
                    ),
                  ),
                ),
              ),

              // Devam Butonu
              if (_isStepCompleted)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200, width: 2)),
                  ),
                  child: BouncyButton(
                    text: 'NEXT MISSION 🌟',
                    color: const Color(0xFF4CAF50),
                    shadowColor: const Color(0xFF2E7D32),
                    isActive: true,
                    onPressed: _finishActivity,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Kucuk telefonlarda icerik ekrandan tasmasin diye: alan yeterliyse
  /// tam yukseklikte (Spacer/Expanded calisir), yetmiyorsa kaydirilabilir.
  Widget _fitScroll(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }

  Widget _buildActivityGame() {
    switch (widget.activity.activityType) {
      case 'matching':
        return _buildMatchingGame();
      case 'drag_drop':
      case 'schedule_drag':
        return _buildDragDropGame();
      case 'trace':
        return _buildTraceGame();
      case 'listen_choose':
        return _fitScroll(_buildListenChooseGame());
      case 'balloon_pop':
        return _fitScroll(_buildBalloonPopGame());
      case 'sentence_builder':
        return _fitScroll(_buildSentenceBuilderGame());
      case 'memory':
        return _buildMemoryGame();
      case 'hidden_object':
        return _fitScroll(_buildHiddenObjectGame());
      case 'fill_blank':
        return _fitScroll(_buildFillBlankGame());
      case 'speak_record':
        return _fitScroll(_buildSpeakRecordGame());
      case 'count_feed':
        return _fitScroll(_buildCountFeedGame());
      case 'color_train':
        return _buildColorTrainGame();
      default:
        return const Center(child: Text("Game Ready"));
    }
  }

  // -------------------------------------------------------------------------
  // 1. E⭐SLE⭐STIRME (MATCHING): OYUNLA⭐STIRILMI⭐S MACERA PARKURU ("Zurafayi Yapraga / Hedefe Ulastir")
  // Hicbir Turkce ceviri icermez, %100 Gorsel + Ingilizce Telaffuz!
  // -------------------------------------------------------------------------
  // -------------------------------------------------------------------------
  // 1. MATCHING: TACTILE PLAYFUL CARD MATCHING (DUOLINGO / STUDYCAT STYLE)
  // -------------------------------------------------------------------------
  Widget _buildMatchingGame() {
    final pairs = widget.activity.gameData['pairs'] as List<dynamic>;
    final totalPairs = pairs.length;
    final matchedCount = _matchedPairs.length;

    // Remaining items to match (Matched items disappear so screen stays clean!)
    final remainingVisuals = _shuffledVisualPairs.where((p) => !_matchedPairs.contains(p['english'])).toList();
    final remainingWords = _shuffledEnglishPairs.where((p) => !_matchedPairs.contains(p['english'])).toList();

    return Column(
      children: [
        // 1. LUSH STEPPING-STONE TRAIL (Organic & Tactile, No Form Borders)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE1F5FE), Color(0xFFE8F5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stepping stones
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(totalPairs, (i) {
                    final isDone = i < matchedCount;
                    final isCurrent = i == matchedCount;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isCurrent ? 44 : 36,
                      height: isCurrent ? 44 : 36,
                      decoration: BoxDecoration(
                        gradient: isDone
                            ? const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFB300)])
                            : (isCurrent
                                ? const LinearGradient(colors: [Color(0xFF81C784), Color(0xFF4CAF50)])
                                : const LinearGradient(colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)])),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDone ? Colors.amber : (isCurrent ? Colors.green : Colors.black26)).withValues(alpha: 0.35),
                            blurRadius: isCurrent ? 8 : 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: Center(
                        child: isDone
                            ? const Text("⭐", style: TextStyle(fontSize: 18))
                            : (isCurrent
                                ? ClipOval(
                                    child: Image.asset(
                                      'assets/images/user_mascot_transparent.png',
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Text("🦒", style: TextStyle(fontSize: 18)),
                                    ),
                                  )
                                : Text(
                                    "${i + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 14),
                                  )),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 8),
              // Goal Golden Leaves
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: matchedCount == totalPairs ? const Color(0xFFFFD54F) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF81C784), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: const Center(
                  child: Text("🌿", style: TextStyle(fontSize: 22)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. PLAYFUL DUAL-COLUMN CARD MATCHING (Left: Pictures, Right: Sound Cards)
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT COLUMN: Chunky Picture Cards (Toy-like 3D Buttons)
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: remainingVisuals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = remainingVisuals[index];
                    final pairId = item['id'] as String;
                    final icon = item['icon'] as String? ?? '⭐';
                    final isSelected = _selectedVisualId == pairId;

                    return GestureDetector(
                      onTap: () {
                        SoundService().playTap();
                        _handleVisualTap(pairId, item['english'] as String);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFF9C4) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFFB300) : const Color(0xFFFFE082),
                            width: isSelected ? 3.5 : 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFFFFB300).withValues(alpha: 0.45)
                                  : const Color(0xFFFFCA28).withValues(alpha: 0.35),
                              offset: Offset(0, isSelected ? 1 : 5), // 3D Push-in feel
                              blurRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 42)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 14),

              // RIGHT COLUMN: 3D Sound & Word Cards (Duolingo Tactile Buttons)
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: remainingWords.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = remainingWords[index];
                    final eng = item['english'] as String;
                    final pairId = item['id'] as String;
                    final isSelected = _selectedEnglish == eng;

                    return GestureDetector(
                      onTap: () {
                        SoundService().speakEnglish(eng);
                        _handleEnglishTap(eng, pairId);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEDE7F6) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF7E57C2) : const Color(0xFFD1C4E9),
                            width: isSelected ? 3.5 : 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF7E57C2).withValues(alpha: 0.45)
                                  : const Color(0xFFB39DDB).withValues(alpha: 0.38),
                              offset: Offset(0, isSelected ? 1 : 5), // 3D Push-in tactile feel
                              blurRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3E5F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.volume_up_rounded, color: Color(0xFF673AB7), size: 18),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                eng,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF311B92),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  void _handleVisualTap(String visualId, String associatedEnglish) {
    setState(() {
      _selectedVisualId = visualId;
      _checkMatchingSolution();
    });
  }

  void _handleEnglishTap(String english, String associatedId) {
    setState(() {
      _selectedEnglish = english;
      _checkMatchingSolution();
    });
  }

  void _checkMatchingSolution() {
    if (_selectedVisualId != null && _selectedEnglish != null) {
      final pairs = widget.activity.gameData['pairs'] as List<dynamic>;
      final targetPair = pairs.firstWhere((p) => p['id'] == _selectedVisualId);

      if (targetPair['english'] == _selectedEnglish) {
        SoundService().playCorrect();
        _matchedPairs.add(_selectedEnglish!);
        _characterFeedback = "Awesome! Step ${_matchedPairs.length} completed! ⭐";

        if (_matchedPairs.length == pairs.length) {
          _triggerSuccess();
        }
      } else {
        SoundService().playWrong();
        SoundService().speakEnglish("Try again!");
        _characterFeedback = "Try again! You can do it! 💪";
        _registerMistake();
      }

      _selectedVisualId = null;
      _selectedEnglish = null;
    }
  }

  // -------------------------------------------------------------------------
  // -------------------------------------------------------------------------
  // 2. PLAYFUL DRAG & DROP BOARD (WOODEN TRAY & TARGET SLOTS)
  // -------------------------------------------------------------------------
  Widget _buildDragDropGame() {
    final targets = widget.activity.gameData['targets'] as List<dynamic>;

    // Color palettes for playful slots
    final slotColors = [
      {'bg': const Color(0xFFE1F5FE), 'border': const Color(0xFF039BE5), 'iconBg': const Color(0xFFB3E5FC)},
      {'bg': const Color(0xFFFFF3E0), 'border': const Color(0xFFFF9800), 'iconBg': const Color(0xFFFFE0B2)},
      {'bg': const Color(0xFFFCE4EC), 'border': const Color(0xFFEC407A), 'iconBg': const Color(0xFFF8BBD0)},
      {'bg': const Color(0xFFEDE7F6), 'border': const Color(0xFF7E57C2), 'iconBg': const Color(0xFFD1C4E9)},
      {'bg': const Color(0xFFE8F5E9), 'border': const Color(0xFF43A047), 'iconBg': const Color(0xFFC8E6C9)},
    ];

    // Iki sutun icerik kadar yer kaplar (eskiden tepsi ekranin en altina kadar
    // uzuyor, sol sutunun alti bos kaliyordu). Cumle sutunu daha genis ki
    // "I wake up at / 7." gibi kotu satir bolunmeleri olmasin.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN: TARGET SLOTS ("Place Card Here!")
        Expanded(
          flex: 5,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
            itemCount: targets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final target = targets[index];
              final isPlaced = _placedTargets.containsKey(index);
              final colors = slotColors[index % slotColors.length];

              return DragTarget<String>(
                onWillAcceptWithDetails: (details) => !isPlaced,
                onAcceptWithDetails: (details) {
                  final droppedSentence = details.data;
                  if (droppedSentence == target['sentence']) {
                    SoundService().playCorrect();
                    setState(() {
                      _placedTargets[index] = droppedSentence;
                      _characterFeedback = 'Awesome! Perfect match! 🏆';
                    });
                    SoundService().speakEnglish(droppedSentence);
                    if (_placedTargets.length == targets.length) {
                      _triggerSuccess();
                    }
                  } else {
                    SoundService().playWrong();
                    setState(() {
                      _characterFeedback = 'Not this box, try again! 🤔';
                    });
                    _registerMistake();
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  final isHovered = candidateData.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      if (_selectedSentence != null && !isPlaced) {
                        if (_selectedSentence == target['sentence']) {
                          SoundService().playCorrect();
                          setState(() {
                            _placedTargets[index] = _selectedSentence!;
                            _selectedSentence = null;
                            _characterFeedback = 'Awesome match! You did it! 🏆';
                          });
                          SoundService().speakEnglish(target['sentence']);
                          if (_placedTargets.length == targets.length) {
                            _triggerSuccess();
                          }
                        } else {
                          SoundService().playWrong();
                          setState(() {
                            _characterFeedback = 'Try a different box! 🤔';
                            _selectedSentence = null;
                          });
                          _registerMistake();
                        }
                      } else if (isPlaced) {
                        SoundService().speakEnglish(_placedTargets[index]!);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isPlaced
                            ? const Color(0xFFE8F5E9)
                            : (isHovered ? const Color(0xFFFFF9C4) : colors['bg'] as Color),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isPlaced
                              ? const Color(0xFF43A047)
                              : (isHovered ? Colors.amber.shade800 : colors['border'] as Color),
                          width: isHovered ? 3.0 : 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (colors['border'] as Color).withValues(alpha: 0.25),
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Round Icon Badge
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: colors['iconBg'] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Text(target['icon'] as String? ?? '⏰', style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Target Drop Zone / Placed Text
                          Expanded(
                            child: isPlaced
                                ? Text(
                                    _placedTargets[index]!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1B5E20),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: (colors['border'] as Color).withValues(alpha: 0.45),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        isHovered ? '👇 Drop!' : '👆 Drop here',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: (colors['border'] as Color),
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(width: 8),

        // RIGHT COLUMN: PLAYFUL WOODEN TRAY FOR CARDS
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF8D6E63), width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withValues(alpha: 0.35),
                  offset: const Offset(0, 6),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Builder(
              builder: (context) {
                final unplacedTargets = targets.where((t) => !_placedTargets.containsValue(t['sentence'])).toList();

                if (unplacedTargets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 8),
                        Text(
                          'ALL PLACED!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: unplacedTargets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, idx) {
                    final target = unplacedTargets[idx];
                    final sentence = target['sentence'] as String;
                    final isSelected = _selectedSentence == sentence;
                    final cardColor = slotColors[idx % slotColors.length]['border'] as Color;

                    // Secili kart belirgin olsun (eskiden secim hic gorunmuyordu)
                    final cardWidget = AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFF9C4) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? Colors.amber.shade800 : cardColor,
                          width: isSelected ? 3.5 : 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cardColor.withValues(alpha: 0.35),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              sentence,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF263238),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              SoundService().playTap();
                              SoundService().speakEnglish(sentence);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: cardColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.volume_up_rounded, color: cardColor, size: 16),
                            ),
                          ),
                        ],
                      ),
                    );

                    return Draggable<String>(
                      data: sentence,
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 170,
                          child: cardWidget,
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.25,
                        child: cardWidget,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          SoundService().playTap();
                          SoundService().speakEnglish(sentence);
                          setState(() {
                            _selectedSentence = (_selectedSentence == sentence) ? null : sentence;
                          });
                        },
                        child: cardWidget,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // 3. DINLENENI SEC (LISTEN & CHOOSE): REFERANS TASARIM (2 UST + 1 ALT DUZENI)
  // -------------------------------------------------------------------------
  Widget _buildListenChooseGame() {
    final questions = widget.activity.gameData['questions'] as List<dynamic>;
    final currentQ = questions[_currentStepIndex];
    final options = _shuffledListenChooseOptions.putIfAbsent(
      _currentStepIndex,
      () => List<dynamic>.from(currentQ['options'] as List<dynamic>)..shuffle(Random()),
    );

    // Kart boyutu ekran genisligine gore (dar telefonlarda yan yana 2 kart sigsin)
    final double screenW = MediaQuery.sizeOf(context).width.clamp(0.0, 600.0).toDouble();
    final double cardW = ((screenW - 32 - 16) / 2).clamp(110.0, 145.0).toDouble();
    final double cardH = cardW * 0.93;

    Widget buildOptionCard(dynamic opt) {
      final width = cardW;
      final height = cardH;
      final name = opt['name'] as String;
      final icon = opt['icon'] as String;

      final isCorrect = _correctChoice == name;
      final isWrong = _wrongChoice == name;

      return GestureDetector(
        onTap: () {
          if (_isAdvancing || _isStepCompleted) return;
          if (name == currentQ['target']) {
            SoundService().playCorrect();
            setState(() {
              _correctChoice = name;
              _characterFeedback = "Great choice! 🎯";
            });
            _advanceAfterCorrect(
              total: questions.length,
              onNext: () => Future.delayed(const Duration(milliseconds: 250), () {
                if (mounted) _playInitialAudio();
              }),
            );
          } else {
            SoundService().playWrong();
            setState(() => _characterFeedback = "Listen again and try another card! 🎧");
            _flashWrong(name);
            _registerMistake();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          height: height,
          transform: Matrix4.translationValues(isWrong ? 6 : 0, 0, 0),
          decoration: BoxDecoration(
            color: isCorrect
                ? const Color(0xFFE8F5E9)
                : (isWrong ? const Color(0xFFFFEBEE) : Colors.white),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isCorrect
                  ? const Color(0xFF43A047)
                  : (isWrong ? const Color(0xFFE53935) : const Color(0xFFECECF2)),
              width: isCorrect || isWrong ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(icon, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        // Ses Butonlari (Buyuk Kirmizi Hoparlor + Sari Hiz Gostergesi)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buyuk Kirmizi Hoparlor Butonu
            GestureDetector(
              onTap: () {
                SoundService().speakEnglish(currentQ['soundText'] as String);
              },
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5252).withValues(alpha: 0.38),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 38),
              ),
            ),
            const SizedBox(width: 14),
            // Kucuk Sari Hiz / Salyangoz Butonu
            GestureDetector(
              onTap: () {
                SoundService().speakEnglishSlow(currentQ['soundText'] as String);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFC107).withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.speed_rounded, color: Color(0xFF4E342E), size: 24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Referans Uygulamadaki 2 Ust + 1 Alt Kart Duzeni
        if (options.length == 3) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildOptionCard(options[0]),
              const SizedBox(width: 16),
              buildOptionCard(options[1]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildOptionCard(options[2]),
            ],
          ),
        ] else ...[
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: options.map((opt) => buildOptionCard(opt)).toList(),
          ),
        ],
      ],
    );
  }

  // -------------------------------------------------------------------------
  // 4. BALON PATLATMA (BALLOON POP) - Gercek Pop & Patlama Efektli
  // -------------------------------------------------------------------------
  Widget _buildBalloonPopGame() {
    final rounds = widget.activity.gameData['rounds'] as List<dynamic>;
    final currentRound = rounds[_currentStepIndex];
    final options = _shuffledBalloonPopOptions.putIfAbsent(
      _currentStepIndex,
      () => List<dynamic>.from(currentRound['options'] as List<dynamic>)..shuffle(Random()),
    );
    final balloonColors = [const Color(0xFFFF3366), const Color(0xFF9C27B0), const Color(0xFF00B0FF)];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade50, Colors.purple.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  SoundService().speakEnglish(currentRound['target'] as String);
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Listen & Catch the Magic Star! ✨",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentRound['target'] as String,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF263238)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Text(
                  "${_currentStepIndex + 1} / ${rounds.length}",
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF7B1FA2)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(options.length, (index) {
              final opt = options[index] as String;
              final color = balloonColors[index % balloonColors.length];
              final isTarget = opt == currentRound['target'];
              final isPopped = _poppedBalloonIndex == index;
              final isWobbling = _wrongBalloonIndex == index;

              if (isPopped) {
                return Expanded(
                  child: Center(
                    child: AnimatedScale(
                      scale: 1.4,
                      duration: const Duration(milliseconds: 250),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("⭐", style: TextStyle(fontSize: 54)),
                          SizedBox(height: 4),
                          Text("GREAT! ✨", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.orange, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  transform: Matrix4.translationValues(
                    isWobbling ? (index.isEven ? 8.0 : -8.0) : 0.0,
                    (index == 1 ? -12.0 : 6.0),
                    0,
                  ),
                  child: GestureDetector(
                    onTap: _poppedBalloonIndex != null
                        ? null
                        : () {
                            if (isTarget) {
                              SoundService().playCorrect();
                              setState(() {
                                _poppedBalloonIndex = index;
                                _characterFeedback = "Great job! You found the matching star! ⭐";
                              });
                              SoundService().speakEnglish(opt);

                              Future.delayed(const Duration(milliseconds: 650), () {
                                if (mounted) {
                                  setState(() {
                                    _poppedBalloonIndex = null;
                                    _wrongBalloonIndex = null;
                                    if (_currentStepIndex < rounds.length - 1) {
                                      _currentStepIndex++;
                                      _playInitialAudio();
                                    } else {
                                      _triggerSuccess();
                                    }
                                  });
                                }
                              });
                            } else {
                              SoundService().playWrong();
                              setState(() {
                                _wrongBalloonIndex = index;
                                _characterFeedback = "Listen again and choose the right star! ✨";
                              });
                              _registerMistake();
                              Future.delayed(const Duration(milliseconds: 400), () {
                                if (mounted) setState(() => _wrongBalloonIndex = null);
                              });
                            }
                          },
                    child: Center(
                      child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              center: const Alignment(-0.3, -0.3),
                              radius: 0.9,
                              colors: [
                                Color.lerp(color, Colors.white, 0.5)!,
                                color,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text("⭐", style: TextStyle(fontSize: 34)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: color, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Text(
                            opt,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }


  // -------------------------------------------------------------------------
  // 5. CUMLE KURMA (SENTENCE BUILDER)
  // -------------------------------------------------------------------------
  Widget _buildSentenceBuilderGame() {
    final sentences = widget.activity.gameData['sentences'] as List<dynamic>;
    final currentItem = sentences[_currentStepIndex];
    if (_lastSentenceIndex != _currentStepIndex) {
      _lastSentenceIndex = _currentStepIndex;
      final raw = List<String>.from(currentItem['words'])..addAll(List<String>.from(currentItem['distractors']));
      _shuffledSentenceWords = List<String>.from(raw)..shuffle(Random());
    }
    final allWords = _shuffledSentenceWords;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.purple.shade200, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentItem['icon'] ?? '🧩', style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  "Build the sentence! 🧩",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A148C)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Cumle dizim yuvasi (dogruysa yesil, yanlissa kirmizi yanar)
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.all(12),
          transform: Matrix4.translationValues(_wrongChoice == 'sentence' ? 6 : 0, 0, 0),
          decoration: BoxDecoration(
            color: _correctChoice == 'sentence'
                ? const Color(0xFFE8F5E9)
                : (_wrongChoice == 'sentence' ? const Color(0xFFFFEBEE) : Colors.purple.shade50),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _correctChoice == 'sentence'
                  ? const Color(0xFF43A047)
                  : (_wrongChoice == 'sentence' ? const Color(0xFFE53935) : Colors.purple.shade300),
              width: 2,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _builtWords.map((w) {
              return GestureDetector(
                onTap: () {
                  setState(() => _builtWords.remove(w));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade300,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade700, width: 2),
                  ),
                  child: Text(w, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),

        // Kelime Taslari
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allWords.where((w) => !_builtWords.contains(w)).map((word) {
            return GestureDetector(
              onTap: () {
                SoundService().speakEnglish(word);
                setState(() => _builtWords.add(word));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Text(word, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),
        ),

        const Spacer(),
        BouncyButton(
          text: 'CHECK ANSWER ⭐',
          color: Colors.green,
          shadowColor: Colors.green.shade800,
          isActive: _builtWords.isNotEmpty && !_isAdvancing,
          onPressed: () {
            if (_isAdvancing || _isStepCompleted) return;
            final formedSentence = _builtWords.join(' ');
            if (formedSentence == currentItem['correct']) {
              SoundService().playCorrect();
              SoundService().speakEnglish(formedSentence);
              setState(() {
                _correctChoice = 'sentence';
                _characterFeedback = "You made a perfect sentence! 🌟";
              });
              _advanceAfterCorrect(
                total: sentences.length,
                onNext: () => _builtWords.clear(),
              );
            } else {
              SoundService().playWrong();
              setState(() => _characterFeedback = "Try the word order again! 🧩");
              _flashWrong('sentence');
              _registerMistake();
            }
          },
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // 6. HARF CIZME / TRACE
  // -------------------------------------------------------------------------
  Widget _buildTraceGame() {
    final letters = widget.activity.gameData['letters'] as List<dynamic>;
    final currentLetterItem = letters[_currentStepIndex];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currentLetterItem['icon'], style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              "${currentLetterItem['word']}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF4A148C)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.purple.shade200, width: 2.5),
            ),
            child: GestureDetector(
              onPanStart: (details) {
                // Konum cizim alanina gore (eskiden tum ekrana gore aliniyordu,
                // cizgi parmagin altinda degil kaymis gorunuyordu)
                final localPos = details.localPosition;
                setState(() {
                  _tracePoints.add(localPos);
                });
              },
              onPanUpdate: (details) {
                final localPos = details.localPosition;
                setState(() {
                  _tracePoints.add(localPos);

                  final validPoints = _tracePoints.where((p) => p != null).map((p) => p!).toList();
                  if (validPoints.length >= 35 && !_isLetterCompleted) {
                    // Cizimin sadece tek bir noktada veya tek duz cizgide olmadigini dogrula (X ve Y yayilimi)
                    double minX = validPoints.first.dx, maxX = validPoints.first.dx;
                    double minY = validPoints.first.dy, maxY = validPoints.first.dy;
                    for (final pt in validPoints) {
                      if (pt.dx < minX) minX = pt.dx;
                      if (pt.dx > maxX) maxX = pt.dx;
                      if (pt.dy < minY) minY = pt.dy;
                      if (pt.dy > maxY) maxY = pt.dy;
                    }

                    // Harfi gercekten kapsayan genis bir cizim yapilmali (en az 60px genislik ve 100px yukseklik)
                    final widthCovered = maxX - minX;
                    final heightCovered = maxY - minY;

                    if (widthCovered >= 55 && heightCovered >= 85) {
                      _isLetterCompleted = true;
                      _characterFeedback = "Super! You traced the letter ${currentLetterItem['letter']}! ⭐";
                      SoundService().speakEnglish(currentLetterItem['word'] as String);
                    }
                  }
                });
              },
              onPanEnd: (details) {
                _tracePoints.add(null);
              },
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                    currentLetterItem['letter'],
                    style: TextStyle(
                      fontSize: 160,
                      fontWeight: FontWeight.w900,
                      color: _isLetterCompleted ? Colors.green.shade400 : Colors.grey.shade200,
                    ),
                  ),
                  ),
                  CustomPaint(
                    painter: _DrawingPainter(points: _tracePoints),
                    size: Size.infinite,
                  ),
                ],
              ),
            ),
          ),
        ),

        if (_isLetterCompleted)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BouncyButton(
              text: _currentStepIndex < letters.length - 1 ? 'NEXT LETTER ⭐' : 'COMPLETE 🎉',
              color: Colors.purple,
              shadowColor: Colors.purple.shade800,
              isActive: true,
              onPressed: () {
                setState(() {
                  if (_currentStepIndex < letters.length - 1) {
                    _currentStepIndex++;
                    _tracePoints.clear();
                    _isLetterCompleted = false;
                  } else {
                    _triggerSuccess();
                  }
                });
              },
            ),
          ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // 7. HAFIZA KARTLARI (MEMORY)
  // -------------------------------------------------------------------------
  Widget _buildMemoryGame() {
    final cards = widget.activity.gameData['cards'] as List<dynamic>;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final isFlipped = _flippedIndices.contains(index) || _matchedIndices.contains(index);

        return GestureDetector(
          onTap: isFlipped ? null : () => _handleCardFlip(index, card['pairId']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: isFlipped ? Colors.white : const Color(0xFF673AB7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isFlipped ? Colors.purple.shade300 : Colors.purple.shade900,
                width: 2,
              ),
            ),
            child: Center(
              child: isFlipped
                  ? Text(
                      card['text'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF4A148C)),
                    )
                  : const Text("⭐", style: TextStyle(fontSize: 28)),
            ),
          ),
        );
      },
    );
  }

  void _handleCardFlip(int index, int pairId) {
    if (_flippedIndices.length >= 2) return;

    setState(() {
      _flippedIndices.add(index);

      if (_flippedIndices.length == 2) {
        final cards = widget.activity.gameData['cards'] as List<dynamic>;
        final firstCard = cards[_flippedIndices[0]];
        final secondCard = cards[_flippedIndices[1]];

        if (firstCard['pairId'] == secondCard['pairId']) {
          _matchedIndices.addAll(_flippedIndices);
          _flippedIndices.clear();
          _characterFeedback = "Great memory! Cards matched! 🏆";
          SoundService().speakEnglish("Matched!");

          if (_matchedIndices.length == cards.length) {
            _triggerSuccess();
          }
        } else {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() {
                _flippedIndices.clear();
                _characterFeedback = "Try again, remember their spots! 🤔";
              });
            }
          });
        }
      }
    });
  }

  // -------------------------------------------------------------------------
  // 8. GIZLI NESNE (HIDDEN OBJECT)
  // -------------------------------------------------------------------------
  Widget _buildHiddenObjectGame() {
    final objects = widget.activity.gameData['objects'] as List<dynamic>;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.shade200),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🤔", style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Tap the items to discover and listen!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4A148C)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE1F5FE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.lightBlue.shade300, width: 2.5),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 18,
              spacing: 18,
              children: List.generate(objects.length, (index) {
                final obj = objects[index];
                final isFound = _foundObjects.contains(index);

                return GestureDetector(
                  onTap: () {
                    SoundService().speakEnglish(obj['sentence'] as String);
                    setState(() {
                      _foundObjects.add(index);
                      _characterFeedback = obj['sentence'] as String;
                      if (_foundObjects.length == objects.length) {
                        _triggerSuccess();
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isFound ? Colors.green.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isFound ? Colors.green : Colors.lightBlue, width: 2.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(obj['icon'], style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 8),
                        if (isFound)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.volume_up_rounded, size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  obj['name'] as String? ?? 'Discovered',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                                ),
                              ],
                            ),
                          )
                        else
                          const Icon(Icons.touch_app_rounded, color: Colors.lightBlue, size: 20),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // 9. BO⭐SLUK DOLDURMA (FILL IN THE BLANK)
  // -------------------------------------------------------------------------
  Widget _buildFillBlankGame() {
    final questions = widget.activity.gameData['questions'] as List<dynamic>;
    final currentQ = questions[_currentStepIndex];
    final options = _shuffledFillBlankOptions.putIfAbsent(
      _currentStepIndex,
      () => List<dynamic>.from(currentQ['options'] as List<dynamic>)..shuffle(Random()),
    );

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple.shade200, width: 2),
          ),
          child: Column(
            children: [
              Text(
                currentQ['sentence'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF4A148C)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Column(
          children: options.map((opt) {
            final isCorrect = _correctChoice == opt;
            final isWrong = _wrongChoice == opt;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              child: BouncyButton(
                text: opt,
                color: isCorrect
                    ? Colors.green
                    : (isWrong ? Colors.red.shade400 : Colors.orange.shade400),
                shadowColor: isCorrect
                    ? Colors.green.shade800
                    : (isWrong ? Colors.red.shade700 : Colors.orange.shade700),
                isActive: true,
                onPressed: () {
                  if (_isAdvancing || _isStepCompleted) return;
                  if (opt == currentQ['answer']) {
                    SoundService().playCorrect();
                    // Bosluk dolmus haliyle tum cumleyi oku
                    final full = (currentQ['sentence'] as String).replaceAll('___', opt);
                    SoundService().speakEnglish(full);
                    setState(() {
                      _correctChoice = opt;
                      _characterFeedback = "You completed it correctly! 🌟";
                    });
                    _advanceAfterCorrect(total: questions.length);
                  } else {
                    SoundService().playWrong();
                    setState(() => _characterFeedback = "Try another word! 🤔");
                    _flashWrong(opt);
                    _registerMistake();
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // 10. KONU⭐S VE KAYDET (SPEAK & RECORD)
  // -------------------------------------------------------------------------
  Widget _buildSpeakRecordGame() {
    final prompts = widget.activity.gameData['prompts'] as List<dynamic>;
    final currentPrompt = prompts[_currentStepIndex];

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purple.shade200, width: 2),
          ),
          child: Column(
            children: [
              Text(
                currentPrompt['question'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF4A148C)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  SoundService().speakEnglish(currentPrompt['suggested'] as String);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.volume_up_rounded, color: Colors.green, size: 20),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          "Example: \"${currentPrompt['suggested']}\"",
                          style: TextStyle(fontSize: 13, color: Colors.green.shade900, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),

        GestureDetector(
          onTap: () {
            if (_isRecording) return;
            setState(() {
              _isRecording = true;
              _characterFeedback = "Listening carefully... Say it loud and clear! 🎙️";
            });

            // Gercekci dinleme gecikmesi (3 saniye)
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                setState(() {
                  _isRecording = false;
                  _characterFeedback = "Great speaking! Beautiful pronunciation! 🌟";
                  SoundService().speakEnglish("Great pronunciation!");
                  if (_currentStepIndex < prompts.length - 1) {
                    _currentStepIndex++;
                  } else {
                    _triggerSuccess();
                  }
                });
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _isRecording ? Colors.redAccent : Colors.purple,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isRecording ? Colors.redAccent : Colors.purple).withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(
              _isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _isRecording ? "LISTENING... 🤔" : "TAP AND SPEAK ENGLISH 🎙️",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black87),
        ),
        const Spacer(),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // 11. SAYI & MEYVE BESLEME OYUNU (FEED GIGI & COUNT 1-10)
  // Lingokids & Duolingo Kids tarzi interaktif meyve yedirme ve sayi sayma
  // -------------------------------------------------------------------------
  Widget _buildCountFeedGame() {
    final gameData = widget.activity.gameData;
    final int targetNumber = gameData['targetNumber'] as int? ?? 5;
    final String itemIcon = gameData['itemIcon'] as String? ?? '🎉';
    final String itemName = gameData['itemName'] as String? ?? 'Apples';
    final numberWords = ['Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten'];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFFF9800), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(itemIcon, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feed Gigi $itemName!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE65100),
                    ),
                  ),
                  Text(
                    'Fed: $_fedCount / $targetNumber (${numberWords[_fedCount]})',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          flex: 5,
          child: DragTarget<String>(
            onWillAcceptWithDetails: (_) => _fedCount < targetNumber,
            onAcceptWithDetails: (_) {
              _feedOneItem(targetNumber, numberWords);
            },
            builder: (context, candidateData, rejectedData) {
              final isHovered = candidateData.isNotEmpty;

              return Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHovered ? const Color(0xFFFFF8E1) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isHovered ? const Color(0xFFFF9800) : const Color(0xFFFFE0B2),
                      width: isHovered ? 4 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: isHovered ? 0.35 : 0.12),
                        blurRadius: isHovered ? 24 : 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/user_mascot_optimized.png',
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Text('🦒', style: TextStyle(fontSize: 80)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isHovered ? const Color(0xFFFF9800) : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isHovered ? 'Yum! Drop here! 😋' : 'Drag or Tap food to feed! 👆',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: isHovered ? Colors.white : const Color(0xFFE65100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              );
            },
          ),
        ),

        Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 6,
          children: List.generate(targetNumber, (index) {
            final isFed = index < _fedCount;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFed ? const Color(0xFFFF9800) : const Color(0xFFEEEEEE),
                border: Border.all(
                  color: isFed ? const Color(0xFFE65100) : const Color(0xFFBDBDBD),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  isFed ? '⭐' : '',
                  style: TextStyle(
                    fontSize: isFed ? 14 : 12,
                    fontWeight: FontWeight.w900,
                    color: isFed ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),

        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFFFE0B2), width: 2),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: List.generate(targetNumber, (index) {
                final isAvailable = index >= _fedCount;
                if (!isAvailable) {
                  return Opacity(
                    opacity: 0.2,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(itemIcon, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                  );
                }

                final foodWidget = Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFD54F), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(itemIcon, style: const TextStyle(fontSize: 30)),
                    ),
                  ),
                );

                return Draggable<String>(
                  data: 'food',
                  feedback: Transform.scale(scale: 1.15, child: foodWidget),
                  childWhenDragging: Opacity(opacity: 0.3, child: foodWidget),
                  child: GestureDetector(
                    onTap: () {
                      _feedOneItem(targetNumber, numberWords);
                    },
                    child: foodWidget,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void _feedOneItem(int targetNumber, List<String> numberWords) {
    if (_fedCount >= targetNumber) return;
    setState(() {
      _fedCount++;
      final currentWord = numberWords[_fedCount];
      final itemName = widget.activity.gameData['itemName'] as String? ?? 'Apples';
      _characterFeedback = '$currentWord! Delicious $itemName! 😋 ($_fedCount / $targetNumber)';
      SoundService().playPop();
      // Yalnizca ElevenLabs'ten uretilen saf kelimeyi (One, Two, Three, Four, Five) seslendir
      SoundService().speakEnglish(currentWord);

      if (_fedCount == targetNumber) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          _triggerSuccess();
        });
      }
    });
  }

  // -------------------------------------------------------------------------
  // 12. RENK & VAGON TRENI OYUNU (COLOR EXPRESS)
  // -------------------------------------------------------------------------
  Widget _buildColorTrainGame() {
    final gameData = widget.activity.gameData;
    final List<dynamic> cars = gameData['cars'] as List<dynamic>? ?? [];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFB39DDB), width: 2),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🚂', style: TextStyle(fontSize: 26)),
              SizedBox(width: 8),
              Text(
                'Color Express!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF4A148C)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Lokomotif ve Vagon Dizisi (Yatay kaydirma)
        SizedBox(
          height: 105,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 85,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7E57C2),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        bottomLeft: Radius.circular(16),
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🚂', style: TextStyle(fontSize: 34)),
                        SizedBox(height: 2),
                        Text(
                          'CHOO-CHOO!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 9),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  ...List.generate(cars.length, (index) {
                    final carInfo = cars[index];
                    final colorName = carInfo['colorName'] as String;
                    final Color carColor = Color(carInfo['colorValue'] as int);
                    final isPlaced = _placedTrainCars.contains(colorName);

                    return DragTarget<String>(
                      onWillAcceptWithDetails: (details) => details.data == colorName && !isPlaced,
                      onAcceptWithDetails: (_) {
                        _placeTrainCar(colorName, cars.length);
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isHovered = candidateData.isNotEmpty;

                        return GestureDetector(
                          onTap: () {
                            if (isPlaced) {
                              SoundService().speakEnglish(colorName);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 76,
                            height: 85,
                            decoration: BoxDecoration(
                              color: isPlaced
                                  ? carColor
                                  : (isHovered ? carColor.withValues(alpha: 0.3) : Colors.white),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isPlaced
                                    ? Colors.black26
                                    : (isHovered ? carColor : Colors.grey.shade300),
                                width: isPlaced ? 3 : 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  carInfo['icon'] as String? ?? '🎨',
                                  style: const TextStyle(fontSize: 26),
                                ),
                                if (isPlaced) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    colorName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Alt Secim Kartlari (Kayip tasma yapmayan SingleChildScrollView)
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: cars.map((car) {
                  final colorName = car['colorName'] as String;
                  final Color carColor = Color(car['colorValue'] as int);
                  final isPlaced = _placedTrainCars.contains(colorName);

                  if (isPlaced) return const SizedBox.shrink();

                  final carCard = Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: carColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: carColor.withValues(alpha: 0.3),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        car['icon'] as String,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  );

                  return Draggable<String>(
                    data: colorName,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Transform.scale(scale: 1.15, child: carCard),
                    ),
                    childWhenDragging: Opacity(opacity: 0.25, child: carCard),
                    child: GestureDetector(
                      onTap: () {
                        SoundService().speakEnglish(colorName);
                        _placeTrainCar(colorName, cars.length);
                      },
                      child: carCard,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _placeTrainCar(String colorName, int total) {
    if (_placedTrainCars.contains(colorName)) return;
    setState(() {
      _placedTrainCars.add(colorName);
      _characterFeedback = 'Awesome! $colorName car attached! 🚂✨';
      SoundService().playCorrect();
      SoundService().speakEnglish('$colorName train car!');

      if (_placedTrainCars.length == total) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          _triggerSuccess();
        });
      }
    });
  }

}

// Harf Cizim Painter (Hafif ve Performansli)
class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;

  _DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orangeAccent
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter oldDelegate) => true;
}
