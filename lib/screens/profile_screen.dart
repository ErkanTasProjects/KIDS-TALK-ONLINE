import 'package:flutter/material.dart';
import '../data/curriculum_data.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../utils/app_strings.dart';
import '../widgets/parent_gate.dart';
import '../widgets/weekly_league_dialog.dart';
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
                Text(
                  AppStrings.tr('parent_report_title', isTurkish),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildReportMetric(
              AppStrings.tr('metric_completion', isTurkish),
              "%${((appState.totalStars / (CurriculumData.activities.length * 3)) * 100).clamp(0, 100).toInt()}",
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
              "${appState.streak} ${'Days'}",
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
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FE),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // 1. Ogrenci Pasaport Karti
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAB47BC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Zurafa Maskot Avatari
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/user_mascot_optimized.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Text("🦒", style: TextStyle(fontSize: 40)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${appState.currentStage.toUpperCase()} ${'STAGE'}",
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${appState.userName} ⭐",
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Kids Talk Online Student',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Kasif Ozellestirme & Haftalik Lig Kisayolu
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          SoundService().playTap();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ExplorerBuilderScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFFF9800), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("🎨", style: TextStyle(fontSize: 18)),
                              SizedBox(width: 8),
                              Text(
                                "Customize Explorer",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: Color(0xFFE65100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => WeeklyLeagueDialog.show(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFF6C5CE7), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("🛡️", style: TextStyle(fontSize: 18)),
                              SizedBox(width: 8),
                              Text(
                                "XP League",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
                                  color: Color(0xFF512DA8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 2. Istatistik Izgarasi
                Row(
                  children: [
                    _buildStatCard(
                      Icons.star_rounded,
                      Colors.amber,
                      "${appState.totalStars}",
                      AppStrings.tr('stars_earned', isTurkish),
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      Icons.local_fire_department_rounded,
                      Colors.orange,
                      "${appState.streak} ${'d'}",
                      AppStrings.tr('streak_days', isTurkish),
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      Icons.bolt_rounded,
                      Colors.purple,
                      "${appState.xp}",
                      AppStrings.tr('total_xp', isTurkish),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

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
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, Color color, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 6, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
