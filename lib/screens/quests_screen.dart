import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  bool _chestOpened = false;

  void _openTreasureChest(bool isTurkish) {
    if (_chestOpened) return;
    setState(() => _chestOpened = true);
    SoundService().playVictory();
    SoundService().speakEnglish("Treasure chest opened! You earned 50 XP and a Super Star badge!");
    context.read<AppState>().addXp(50);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          "🎁 Treasure Chest Opened!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("💎", style: TextStyle(fontSize: 60)),
            SizedBox(height: 12),
            Text(
              "+50 XP and 'Super Star' Badge Earned!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                "AWESOME! ⭐",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isTr = appState.isTurkish;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FE),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // 1. Ust Macera Banner'i (Kids Talk Ozel Tasarimi)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA), Color(0xFFAB47BC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
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
                                '🎯 QUEST CENTER',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Daily Adventures',
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complete quests, open the treasure chest and collect badges!',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Kullanicinin Ozel Zurafa Maskotu
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/user_mascot_optimized.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Text("🦒", style: TextStyle(fontSize: 34)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Haftalik Hazine Sandigi Karti
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.amber.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.amber.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'WEEKLY TREASURE CHEST 📦',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFFE65100)),
                          ),
                          Text(
                            _chestOpened
                                ? ('OPENED 💎')
                                : ('READY! ✨'),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _chestOpened ? Colors.grey : Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _openTreasureChest(isTr),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.amber.shade600, width: 2),
                              ),
                              child: Center(
                                child: Text(_chestOpened ? "💎" : "🎁", style: const TextStyle(fontSize: 34)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Earn 20 Stars to Open Chest',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: (appState.totalStars / 20).clamp(0.0, 1.0),
                                    minHeight: 12,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${appState.totalStars} / 20 ${'Stars'}",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Gunluk Gorevler Bolumu
                Text(
                  'DAILY MISSIONS ⚡',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF4A148C), letterSpacing: 1.1),
                ),
                const SizedBox(height: 10),

                // Gorev 1: Kelime Dinleme
                _buildQuestRow(
                  icon: "🎧",
                  title: 'Listen to Daily Greeting Word',
                  subtitle: 'Listen and repeat "Hello"',
                  progress: 1.0,
                  progressText: "1 / 1",
                  actionButton: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade50,
                      foregroundColor: const Color(0xFF8E24AA),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.volume_up_rounded, size: 18),
                    label: Text(
                      'LISTEN',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    onPressed: () {
                      SoundService().speakEnglish("Hello! Good morning!");
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Gorev 2: Egzersiz Yapma
                _buildQuestRow(
                  icon: "🎈",
                  title: 'Complete 1 Activity',
                  subtitle: 'Earn 3 stars in any lesson',
                  progress: (appState.currentLevelIndex >= 1 ? 1.0 : 0.0),
                  progressText: "${appState.currentLevelIndex >= 1 ? '1' : '0'} / 1",
                ),
                const SizedBox(height: 10),

                // Gorev 3: 5 Yildiz Topla
                _buildQuestRow(
                  icon: "⭐",
                  title: 'Collect 5 Stars',
                  subtitle: 'Finish lessons with excellence',
                  progress: (appState.totalStars / 5).clamp(0.0, 1.0),
                  progressText: "${appState.totalStars} / 5",
                ),
                const SizedBox(height: 24),

                // 4. Koleksiyon Rozetleri Albumu
                Text(
                  'CHARACTER BADGES 🏅',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF4A148C), letterSpacing: 1.1),
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBadgeCard("🦒", "Gigi", true),
                    _buildBadgeCard("🐰", "Luna", true),
                    _buildBadgeCard("🤖", "Bip-Bop", true),
                    _buildBadgeCard("🦁", "Leo", appState.totalStars >= 6),
                    _buildBadgeCard("⭐", "Zippy", appState.totalStars >= 9),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestRow({
    required String icon,
    required String title,
    required String subtitle,
    required double progress,
    required String progressText,
    Widget? actionButton,
  }) {
    final bool isDone = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDone ? Colors.green.shade300 : Colors.purple.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDone ? Colors.green.shade50 : const Color(0xFFF3E5F5),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF263238))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(isDone ? Colors.green : const Color(0xFFAB47BC)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (actionButton != null)
            actionButton
          else
            Text(
              progressText,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: isDone ? Colors.green : Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadgeCard(String emoji, String name, bool isUnlocked) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isUnlocked) {
              SoundService().playCorrect();
              SoundService().speakEnglish("You unlocked the $name badge! Super star!");
            } else {
              SoundService().playTap();
            }
          },
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : Colors.grey.shade100,
              shape: BoxShape.circle,
              border: Border.all(
                color: isUnlocked ? const Color(0xFFFF9800) : Colors.grey.shade300,
                width: 2.5,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: isUnlocked
                  ? Text(emoji, style: const TextStyle(fontSize: 28))
                  : const Icon(Icons.lock_rounded, color: Colors.grey, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isUnlocked ? const Color(0xFF4A148C) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
