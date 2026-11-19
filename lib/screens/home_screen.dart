import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/curriculum_data.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../utils/page_transitions.dart';
import '../widgets/kids_characters.dart';
import '../widgets/weekly_league_dialog.dart';
import 'lesson_screen.dart';

/// Kids Talk Online - Duolingo Tarzi Macera Haritasi (Learning Path)
/// 60-120 FPS akici performans, 3D dokunmatik butonlar ve sevimli karakterler.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _stages = ['Starter', 'Movers', 'Flyers'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7FC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // UST BASLIK & ISTATISTIK BARI (Streak, XP, Can, Ses)
                _buildTopHeader(appState),

                // SEVIYE SECICI TAB BARI (Starter, Movers, Flyers)
                _buildStageTabs(),

                // DUOLINGO TARZI KIVRIMLI HARITA
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _stages.map((stage) {
                      return _DuolingoPathView(
                        stage: stage,
                        appState: appState,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // UST ISTATISTIK & PROFIL BARI
  // -------------------------------------------------------------------------
  Widget _buildTopHeader(AppState appState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.purple.shade50, width: 2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Corner Logo & Title with Giraffe Emblem
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber.shade400, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/giraffe_logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Text("🦒", style: TextStyle(fontSize: 24)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFFB74D), width: 1),
                        ),
                        child: const Text(
                          "KIDS TALK ONLINE 🦒",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                            color: Color(0xFFE65100),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "English World",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Sag Kisim: Muzik Butonu + Yuksek Kaliteli Gigi Avatari
              Row(
                children: [
                  // Muzik Ac/Kapa Butonu
                  GestureDetector(
                    onTap: () {
                      appState.toggleMusic();
                      SoundService().setAudioSettings(
                        soundEnabled: appState.isSoundEnabled,
                        musicEnabled: appState.isMusicEnabled,
                      );
                      SoundService().playTap();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: appState.isMusicEnabled ? Colors.purple.shade50 : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appState.isMusicEnabled ? Colors.purple.shade200 : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        appState.isMusicEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
                        size: 20,
                        color: appState.isMusicEnabled ? const Color(0xFF8E24AA) : Colors.grey,
                      ),
                    ),
                  ),

                  // Gigi Avatari
                  GestureDetector(
                    onTap: () {
                      SoundService().playPop();
                      SoundService().speakEnglish("Hello! I am Gigi! Let's explore new English adventures!");
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/images/user_mascot_optimized.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Text("🦒", style: TextStyle(fontSize: 28)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Sik Referans Tarzi Kapsul Haplari (Language, Streak, Gems, Hearts, XP League)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dil Kapsulu
                _buildCapsulePill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C5CE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('EN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'English',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2D3748)),
                      ),
                    ],
                  ),
                  borderColor: const Color(0xFF6C5CE7).withValues(alpha: 0.3),
                  onTap: () {
                    SoundService().playTap();
                  },
                ),
                const SizedBox(width: 6),

                // Streak (Alev)
                _buildCapsulePill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text('${appState.streak}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFFF9800))),
                    ],
                  ),
                  borderColor: Colors.orange.shade200,
                  onTap: () {
                    SoundService().playPop();
                    SoundService().speakEnglish("${appState.streak} day streak!");
                  },
                ),
                const SizedBox(width: 6),

                // Elmaslar (Gems)
                _buildCapsulePill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('💎', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text('${appState.gems}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF00ACC1))),
                    ],
                  ),
                  borderColor: Colors.cyan.shade200,
                  onTap: () {
                    SoundService().playVictory();
                    SoundService().speakEnglish("You have ${appState.gems} diamonds!");
                  },
                ),
                const SizedBox(width: 6),

                // Canlar (Hearts)
                _buildCapsulePill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('💖', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text('${appState.hearts}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFE53935))),
                    ],
                  ),
                  borderColor: Colors.red.shade200,
                  onTap: () {
                    appState.refillHearts();
                    SoundService().playCorrect();
                    SoundService().speakEnglish("Full hearts! Ready to play!");
                  },
                ),
                const SizedBox(width: 6),

                // XP Ligi (Weekly XP League Modal)
                _buildCapsulePill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🛡️', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 4),
                      Text('${appState.xp} XP', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF8E24AA))),
                    ],
                  ),
                  borderColor: Colors.purple.shade200,
                  onTap: () => WeeklyLeagueDialog.show(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapsulePill({
    required Widget child,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  

  Widget _buildStageTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.purple.shade100, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFFAB47BC)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6A1B9A),
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "🌱 STARTER"),
          Tab(text: "🚀 MOVERS"),
          Tab(text: "🌟 FLYERS"),
        ],
      ),
    );
  }
}

// =========================================================================
// DUOLINGO TARZI KIVRIMLI HARITA GORUNUMU (_DuolingoPathView)
// =========================================================================
class _DuolingoPathView extends StatelessWidget {
  final String stage;
  final AppState appState;

  const _DuolingoPathView({
    required this.stage,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    final activities = CurriculumData.getActivitiesByStage(stage);

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      itemCount: activities.length + 1, // +1 for the Unit Header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildUnitBanner(stage);
        }

        final activityIndex = index - 1;
        final activity = activities[activityIndex];

        // Seviye kilit ve durum mantigi
        final bool isStarter = stage.toLowerCase() == 'starter';
        final bool isUnlocked = (isStarter && activityIndex <= appState.currentLevelIndex) ||
            (!isStarter && appState.currentLevelIndex >= 4);
        final bool isCompleted = (isStarter && activityIndex < appState.currentLevelIndex) ||
            (appState.getStarsFor(activity.id) > 0);
        final bool isCurrent = isStarter && activityIndex == appState.currentLevelIndex;

        // Duolingo zikzak x-offseti: 0: Merkez, 1: Sag (+65), 2: Merkez, 3: Sol (-65)
        final int pattern = activityIndex % 4;
        double xOffset = 0.0;
        if (pattern == 1) xOffset = 65.0;
        if (pattern == 3) xOffset = -65.0;

        // Her 3 seviyede bir bonus sandik gosterimi
        final bool showTreasure = (activityIndex + 1) % 4 == 0 && activityIndex > 0;

        return Column(
          children: [
            // Seviye Dugumu (Node)
            _DuolingoNodeItem(
              activity: activity,
              levelNumber: activityIndex + 1,
              isUnlocked: isUnlocked,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              xOffset: xOffset,
              stars: appState.getStarsFor(activity.id),
              onTap: () => _handleNodeTap(context, activity, isUnlocked),
            ),

            // Noktali Yol Ilerleme Izi (Reference App Dotted Path)
            if (activityIndex < activities.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A5F).withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),

            // Bonus Hazine Sandigi
            if (showTreasure)
              _buildTreasureChest(context, activityIndex),
          ],
        );
      },
    );
  }

  Widget _buildUnitBanner(String stage) {
    String unitTitle = "UNIT 1";
    String unitName = "First Steps & Greetings";
    String description = "Greetings, Family Members & School";
    Color primaryColor = const Color(0xFF4CAF50);
    Color lightBg = const Color(0xFFE8F5E9);

    if (stage == 'Movers') {
      unitTitle = "UNIT 2";
      unitName = "Adventure Station";
      description = "Daily Routines, Hobbies & Classes";
      primaryColor = const Color(0xFF8E24AA);
      lightBg = const Color(0xFFF3E5F5);
    } else if (stage == 'Flyers') {
      unitTitle = "UNIT 3";
      unitName = "Champions League";
      description = "Fluent Speaking & Self Introduction";
      primaryColor = const Color(0xFFFF9800);
      lightBg = const Color(0xFFFFF3E0);
    }

    String islandEmblem = '🦁';
    if (stage == 'Movers') islandEmblem = '🦒';
    if (stage == 'Flyers') islandEmblem = 'abc';

    return Column(
      children: [
        // Ada Ust Baslik & Ada Rozeti (Reference App "Animal Island" Stili)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              // Ada Rozeti (Merkez Emoji Kutucugu)
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(islandEmblem, style: const TextStyle(fontSize: 42)),
                ),
              ),
              const SizedBox(height: 8),

              // Ilerleme Kapsulu (Orn: 0 of 5 ✓)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${(appState.currentLevelIndex).clamp(0, 5)} of 5",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.check_rounded, size: 16, color: Color(0xFF4CAF50)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Guidebook & AI Roleplay Mor Hap Butonu
              GestureDetector(
                onTap: () {
                  SoundService().playTap();
                  SoundService().speakEnglish("Welcome to Guidebook and AI Roleplay with Gigi!");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C5CE7),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C5CE7).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Guidebook & AI Roleplay",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Unite Bilgilendirme Karti
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: primaryColor.withValues(alpha: 0.4), width: 2),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        unitTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      unitName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 6,
                    )
                  ],
                ),
                child: Icon(Icons.menu_book_rounded, color: primaryColor, size: 28),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTreasureChest(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: GestureDetector(
        onTap: () {
          SoundService().playVictory();
          appState.addXp(25);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFFFF9800),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: const Row(
                children: [
                  const Text("🎁", style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  const Text(
                    "Awesome! +25 Bonus XP Earned!",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE082),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFFB300), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text("🎁", style: TextStyle(fontSize: 34)),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Bonus Chest",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFFF57C00),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, ActivityItem activity, bool isUnlocked) {
    if (!isUnlocked) {
      SoundService().playWrong();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF424242),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: const Row(
            children: [
              Icon(Icons.lock_rounded, color: Colors.amber, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "This level is locked! Complete previous lessons to unlock.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    // Duolingo Tarzi Bolum Onizleme ve Baslama Penceresi
    SoundService().playTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _LessonStartBottomSheet(activity: activity),
    );
  }
}

// =========================================================================
// DUOLINGO 3D BUTON DUGUMU (_DuolingoNodeItem)
// =========================================================================
class _DuolingoNodeItem extends StatelessWidget {
  final ActivityItem activity;
  final int levelNumber;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final double xOffset;
  final int stars;
  final VoidCallback onTap;

  const _DuolingoNodeItem({
    required this.activity,
    required this.levelNumber,
    required this.isUnlocked,
    required this.isCompleted,
    required this.isCurrent,
    required this.xOffset,
    required this.stars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Duolingo Renk Paleti (Canli Yesil / Mor / Altin)
    Color buttonColor = const Color(0xFF58CC02); // Canli Duolingo Yesili
    Color shadowColor = const Color(0xFF46A302); // 3D Alt Kenar

    if (isCompleted) {
      buttonColor = const Color(0xFFFFC800); // Altın Şampiyon Sarısı
      shadowColor = const Color(0xFFE5A500);
    } else if (!isUnlocked) {
      buttonColor = const Color(0xFFE5E5E5); // Kilitli Gri
      shadowColor = const Color(0xFFBDBDBD);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      child: Transform.translate(
        offset: Offset(xOffset, 0),
        child: Column(
          children: [
            // Aktif seviyedeki Gigi Maskotu ve Konusma Balonu
            if (isCurrent)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Minik Gigi
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Image.asset(
                        'assets/images/user_mascot_optimized.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Konusma Baloncugu
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF58CC02), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        "START! 🚀",
                        style: TextStyle(
                          color: Color(0xFF46A302),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Cift Halkali (Double Concentric Ring) Referans Buton Dugumu
            GestureDetector(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Dis Halka (Outer Ring)
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isUnlocked
                            ? (isCompleted ? const Color(0xFFFFB300) : const Color(0xFF1E3A5F))
                            : const Color(0xFFD8D8E2),
                        width: isCurrent ? 4.0 : 3.5,
                      ),
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4CD964).withValues(alpha: 0.35),
                                blurRadius: 12,
                                spreadRadius: 3,
                              ),
                            ]
                          : null,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUnlocked
                            ? (isCompleted ? const Color(0xFFFFC800) : const Color(0xFF4CD964))
                            : const Color(0xFFE2E2EA),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$levelNumber',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: isUnlocked ? Colors.white : const Color(0xFF757588),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Kilit Rozeti (Sag alt kose)
                  if (!isUnlocked)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.lock_rounded, size: 14, color: Color(0xFF757588)),
                      ),
                    ),
                ],
              ),
            ),

            // Tamamlanmissa 3 Yildiz Gosterimi
            if (isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (starIdx) {
                    final bool filled = starIdx < (stars > 0 ? stars : 3);
                    return Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: filled ? const Color(0xFFFFB300) : Colors.grey.shade300,
                    );
                  }),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  activity.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isUnlocked ? const Color(0xFF2D3748) : Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// BOLUM BASLAMA BOTTOM SHEET PENCERESI (_LessonStartBottomSheet)
// =========================================================================
class _LessonStartBottomSheet extends StatelessWidget {
  final ActivityItem activity;

  const _LessonStartBottomSheet({required this.activity});

  @override
  Widget build(BuildContext context) {
    final characterInfo = KidsCharacterInfo.fromName(activity.characterName);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tutamac cizgisi
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 18),

          // Karakter Avatari ve Baslik
          Row(
            children: [
              AnimatedKidsCharacter(
                character: characterInfo.type,
                size: 70,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: characterInfo.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${activity.stage.toUpperCase()} • ${activity.stageNumber}",
                        style: TextStyle(
                          color: characterInfo.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      activity.topic,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Karakter Tavsiyesi / Sozu
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F7FC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded, color: Colors.amber, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activity.characterQuote,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A148C),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 3D Duolingo Tarzi BASLA Butonu
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              SoundService().playTap();
              Navigator.of(context).push(
                AppPageRoute(
                  page: LessonScreen(activity: activity),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF58CC02),
                borderRadius: BorderRadius.circular(18),
                border: const Border(
                  bottom: BorderSide(color: Color(0xFF46A302), width: 5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF58CC02).withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "START! 🚀",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
