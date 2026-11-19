import 'package:flutter/material.dart';
import '../data/curriculum_data.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../utils/app_strings.dart';
import '../widgets/parent_gate.dart';
import '../widgets/weekly_league_dialog.dart';
import '../theme/kids_theme.dart';
import 'explorer_builder_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _speechRate = SoundService().speechSliderValue;

  /// Her seferinde farkli soru soran ortak ebeveyn kilidi
  /// (eskiden hep "8 + 6 = ?" soruluyordu, cocuk ezberleyebiliyordu).
  Future<void> _showParentGate() async {
    final ok = await showParentGate(context);
    if (!mounted) return;
    if (ok) {
      _showParentReport();
    } else {
      SoundService().playWrong();
    }
  }

  void _showParentReport() {
    final appState = context.read<AppState>();
    final isTurkish = appState.isTurkish;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.viewPaddingOf(ctx).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text("📊", style: TextStyle(fontSize: 28)),
                const SizedBox(width: 10),
                // Flexible: uzun baslik sagdan tasiyordu
                Flexible(
                  child: Text(
                    AppStrings.tr('parent_report_title', isTurkish),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReportMetric(
              AppStrings.tr('metric_completion', isTurkish),
              "${((appState.totalStars / (CurriculumData.activities.length * 3)) * 100).clamp(0, 100).toInt()}%",
              Colors.green,
            ),
            // Gercek veriler (eskiden "%95" ve "32 Words" sabit yaziliydi)
            _buildReportMetric(
              "Lessons completed",
              "${CurriculumData.activities.where((a) => appState.getStarsFor(a.id) > 0).length} / ${CurriculumData.activities.length}",
              Colors.blue,
            ),
            _buildReportMetric(
              AppStrings.tr('metric_vocabulary', isTurkish),
              "${appState.learnedWords.length} Words",
              Colors.purple,
            ),
            _buildReportMetric(
              AppStrings.tr('metric_streak', isTurkish),
              "${appState.streak} ${appState.streak == 1 ? 'day' : 'days'}",
              Colors.orange,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.favorite_rounded),
                label: Text(
                  AppStrings.tr('btn_refill_hearts', isTurkish),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  appState.refillHearts();
                  Navigator.of(ctx).pop();
                  SoundService().speakEnglish("Hearts refilled!");
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildReportMetric(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isTurkish = appState.isTurkish;

    final league = WeeklyLeagueDialog.leagues.lastWhere((l) => appState.xp >= l.minXp,
        orElse: () => WeeklyLeagueDialog.leagues.first);
    final lessonsDone = CurriculumData.activities.where(appState.isCompleted).length;
    final land = Land.of(appState.currentActivity?.stage ?? 'Flyers');

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Kapak: diyar renginde zemin + buyuk kasif
          _ProfileHero(appState: appState, color: land.color, onSettings: () {
            SoundService().playTap();
            final ctx = _settingsKey.currentContext;
            if (ctx != null) {
              Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            }
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  appState.userName,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: KidsColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  "${land.emoji} ${land.name.toUpperCase()} EXPLORER",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: KidsColors.inkSoft,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                // Kurs / ders / lig ozet satiri
                Row(
                  children: [
                    _miniStat(
                      const Text('EN', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                      'Course',
                    ),
                    _miniStatText('$lessonsDone / ${CurriculumData.activities.length}', 'Lessons'),
                    _miniStatText(league.icon, league.name.replaceAll(' League', '')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: JellyButton(
                        color: Colors.white,
                        shadow: KidsColors.line,
                        depth: 4,
                        borderRadius: BorderRadius.circular(16),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        onTap: () {
                          SoundService().playTap();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ExplorerBuilderScreen()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🎨', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'CUSTOMIZE EXPLORER',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: land.dark, fontWeight: FontWeight.w900, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    JellyButton(
                      color: Colors.white,
                      shadow: KidsColors.line,
                      depth: 4,
                      borderRadius: BorderRadius.circular(16),
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                      onTap: () => WeeklyLeagueDialog.show(context),
                      child: const Text('🏆', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // 2. Genel bakis kartlari
                const SectionLabel('Overview'),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.3,
                  children: [
                    _overviewTile('🔥', '${appState.streak}', appState.streak == 1 ? 'day streak' : 'days streak'),
                    _overviewTile('⚡', '${appState.xp}', 'total XP'),
                    _overviewTile('⭐', '${appState.totalStars}', AppStrings.tr('stars_earned', isTurkish)),
                    _overviewTile('💎', '${appState.gems}', 'gems'),
                  ],
                ),
                const SizedBox(height: 26),
                SectionLabel('Settings', key: _settingsKey),

                // 3. DIL AYARLARI KARTI (Hocanin Istedigi Veli Dil Secenegi)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.amber.shade200, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(color: Colors.amber.shade100, shape: BoxShape.circle),
                            child: const Text("🌐", style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.tr('app_language', isTurkish),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF263238)),
                                ),
                                Text(
                                  'Parent UI language selector',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Segmented Language Toggle Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                SoundService().playTap();
                                appState.setLanguage('en');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6A1B9A),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF6A1B9A),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withValues(alpha: 0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("🇬🇧", style: TextStyle(fontSize: 18)),
                                    SizedBox(width: 8),
                                    Text(
                                      "English (Default)",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 4. Ses ve Telaffuz Laboratuvari
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.purple.shade100, width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.record_voice_over_rounded, color: Color(0xFF7B1FA2)),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.tr('speech_rate', isTurkish),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF263238)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppStrings.tr('speech_slow', isTurkish), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          Text(
                            _speechRate < 0.4
                                ? AppStrings.tr('speech_slow', isTurkish)
                                : (_speechRate > 0.6 ? AppStrings.tr('speech_fast', isTurkish) : AppStrings.tr('speech_normal', isTurkish)),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF7B1FA2)),
                          ),
                          Text(AppStrings.tr('speech_fast', isTurkish), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: _speechRate,
                        min: 0.25,
                        max: 0.85,
                        activeColor: const Color(0xFF7B1FA2),
                        onChanged: (val) {
                          setState(() => _speechRate = val);
                          SoundService().setSpeechRate(val);
                        },
                      ),
                      Center(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF7B1FA2), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF7B1FA2)),
                          label: Text(
                            AppStrings.tr('test_audio', isTurkish),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2)),
                          ),
                          onPressed: () {
                            SoundService().speakEnglish("Hello! Welcome to Kids Talk Online! Let's learn English together!");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Ayar Anahtarlari (Muzik ve Efektler)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.purple.shade100, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(AppStrings.tr('sound_effects', isTurkish), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(AppStrings.tr('sound_desc', isTurkish)),
                        value: appState.isSoundEnabled,
                        activeColor: const Color(0xFF7B1FA2),
                        // Eskiden ayar kaydediliyor ama ses motoruna iletilmiyordu
                        onChanged: (v) {
                          appState.toggleSound();
                          SoundService().setAudioSettings(
                            soundEnabled: v,
                            musicEnabled: appState.isMusicEnabled,
                          );
                        },
                      ),
                      Divider(color: Colors.grey.shade200),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(AppStrings.tr('music_title', isTurkish), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(AppStrings.tr('music_desc', isTurkish)),
                        value: appState.isMusicEnabled,
                        activeColor: const Color(0xFF7B1FA2),
                        onChanged: (v) {
                          appState.toggleMusic();
                          SoundService().setAudioSettings(
                            soundEnabled: appState.isSoundEnabled,
                            musicEnabled: v,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 6. Ebeveyn Denetim Butonu
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A148C),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFF7B1FA2), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  icon: const Icon(Icons.security_rounded),
                  label: Text(
                    'PARENT GATE & REPORT 🛡️',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  ),
                  onPressed: _showParentGate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final GlobalKey _settingsKey = GlobalKey();

  Widget _miniStat(Widget icon, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(7),
              border: const Border(bottom: BorderSide(color: Color(0xFF1D4ED8), width: 3)),
            ),
            child: icon,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: KidsColors.inkSoft, fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _miniStatText(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: KidsColors.ink, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 2),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: KidsColors.inkSoft, fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _overviewTile(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: KidsColors.line, width: 2),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(value,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: KidsColors.ink)),
                ),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: KidsColors.inkSoft)),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

/// Profil kapagi: renkli zemin, buyuk kasif figuru, ayarlar kisayolu.
class _ProfileHero extends StatelessWidget {
  final AppState appState;
  final Color color;
  final VoidCallback onSettings;
  const _ProfileHero({required this.appState, required this.color, required this.onSettings});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      height: 250 + top,
      color: color,
      child: Stack(
        children: [
          Positioned(left: -40, top: top + 40, child: _circle(140, Colors.white.withValues(alpha: 0.10))),
          Positioned(right: -30, bottom: -30, child: _circle(170, Colors.white.withValues(alpha: 0.10))),
          Positioned(
            top: top + 6,
            right: 8,
            child: IconButton(
              onPressed: onSettings,
              icon: const Icon(Icons.settings_rounded, color: Colors.white, size: 30),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                'assets/images/gigi_waving.png',
                height: 225,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text('🦒', style: TextStyle(fontSize: 90)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _circle(double s, Color c) =>
      Container(width: s, height: s, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
}
