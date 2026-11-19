import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/kids_theme.dart';

/// Gorevler: gunluk gorevler (her gun yenilenir), yildiz hazinesi ve rozetler.
class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  // Gunun kelimesi: her gun farkli, studyo kaydi olan kelimelerden
  static const _wordsOfDay = [
    'Hello', 'Good morning', 'Apple', 'Book', 'Cat', 'Dog', 'Bird', 'Pencil',
    'Mother', 'Father', 'Sister', 'Brother', 'Red', 'Blue', 'Green', 'Yellow',
  ];

  static String get wordOfDay {
    final n = DateTime.now();
    final dayOfYear = n.difference(DateTime(n.year)).inDays;
    return _wordsOfDay[dayOfYear % _wordsOfDay.length];
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final hoursLeft = s.timeLeftToday.inHours;
    final word = wordOfDay;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          const KidsHeader(
            title: 'Quests',
            subtitle: 'Finish quests, win treasure!',
            color: Color(0xFF8B5CF6),
            image: 'assets/images/piko_cropped.png',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(
                  'Daily quests',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined, size: 18, color: KidsColors.flame),
                      const SizedBox(width: 4),
                      Text(
                        hoursLeft >= 1 ? '$hoursLeft HOURS' : '${s.timeLeftToday.inMinutes} MIN',
                        style: const TextStyle(color: KidsColors.flame, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _QuestTile(
                  id: 'lesson',
                  icon: '🎈',
                  title: 'Complete 1 lesson',
                  progress: s.dailyLessons,
                  goal: 1,
                  color: const Color(0xFF14B8A6),
                ),
                _QuestTile(
                  id: 'stars',
                  icon: '⭐',
                  title: 'Earn 6 stars',
                  progress: s.dailyStars,
                  goal: 6,
                  color: KidsColors.gold,
                ),
                _QuestTile(
                  id: 'listen',
                  icon: '🎧',
                  title: 'Word of the day: "$word"',
                  progress: s.listenedToday ? 1 : 0,
                  goal: 1,
                  color: KidsColors.gem,
                  action: JellyButton(
                    color: KidsColors.gem,
                    shadow: const Color(0xFF1290CC),
                    depth: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      SoundService().speakEnglish(word);
                      s.markListenedToday();
                    },
                    child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const Divider(height: 36, thickness: 2, color: KidsColors.line),
                const SectionLabel('Star treasure'),
                _StarTreasure(s: s),
                const Divider(height: 36, thickness: 2, color: KidsColors.line),
                const SectionLabel('Badges'),
                _Badges(s: s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestTile extends StatelessWidget {
  final String id;
  final String icon;
  final String title;
  final int progress;
  final int goal;
  final Color color;
  final Widget? action;

  const _QuestTile({
    required this.id,
    required this.icon,
    required this.title,
    required this.progress,
    required this.goal,
    required this.color,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final done = progress >= goal;
    final claimed = s.isQuestClaimed(id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: KidsColors.ink),
                      ),
                    ),
                    if (action != null) ...[const SizedBox(width: 8), action!],
                  ],
                ),
                const SizedBox(height: 8),
                FatProgressBar(
                  value: progress / goal,
                  label: '${progress.clamp(0, goal)} / $goal',
                  color: color,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Odul sandigi: tamamlaninca altin olur, dokununca +10 elmas
          JellyButton(
            width: 54,
            height: 48,
            depth: 5,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(14),
            color: claimed ? KidsColors.line : (done ? KidsColors.gold : KidsColors.locked),
            shadow: claimed ? KidsColors.line : (done ? KidsColors.goldDark : KidsColors.lockedDark),
            onTap: () {
              if (s.claimQuest(id, done: done)) {
                SoundService().playVictory();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("🎉 Quest complete! +${AppState.questGems} 💎"),
                  ),
                );
              } else if (!done) {
                SoundService().playWrong();
              }
            },
            child: Text(
              claimed ? '✅' : '🎁',
              style: TextStyle(fontSize: 24, color: done || claimed ? null : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarTreasure extends StatelessWidget {
  final AppState s;
  const _StarTreasure({required this.s});

  @override
  Widget build(BuildContext context) {
    final opened = s.isChestOpened;
    final ready = s.canOpenChest;
    const goal = AppState.chestStarGoal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFFFE08A), width: 2),
      ),
      child: Row(
        children: [
          JellyButton(
            width: 74,
            height: 66,
            depth: 6,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(20),
            color: ready ? KidsColors.gold : (opened ? Colors.white : KidsColors.locked),
            shadow: ready ? KidsColors.goldDark : (opened ? KidsColors.line : KidsColors.lockedDark),
            onTap: () {
              if (s.openChest()) {
                SoundService().playVictory();
                SoundService().speakEnglish("Treasure chest opened! You earned 50 XP and a Super Star badge!");
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    title: const Text("🎁 Star Treasure!", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    content: const Text("+50 XP and +50 💎\n'Super Star' badge earned!",
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [ElevatedButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("AWESOME! ⭐"))],
                  ),
                );
              } else if (!opened) {
                SoundService().playWrong();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("🔒 Collect ${goal - s.totalStars} more stars to open it!"),
                  ),
                );
              }
            },
            child: Text(opened ? '💎' : '🧰', style: TextStyle(fontSize: 34, color: ready || opened ? null : Colors.grey)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opened ? 'Treasure opened!' : (ready ? 'Ready to open!' : 'Collect $goal stars'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: KidsColors.ink),
                ),
                const SizedBox(height: 8),
                FatProgressBar(
                  value: s.totalStars / goal,
                  label: '${s.totalStars.clamp(0, goal)} / $goal',
                  color: KidsColors.gold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  final AppState s;
  const _Badges({required this.s});

  @override
  Widget build(BuildContext context) {
    final badges = <(String, String, bool)>[
      ('🦒', 'Gigi', true),
      ('🐰', 'Luna', s.totalStars >= 1),
      ('🤖', 'Bip-Bop', s.totalStars >= 3),
      ('🦁', 'Leo', s.totalStars >= 6),
      ('⭐', 'Zippy', s.totalStars >= 9),
      ('🌿', 'Savanna', s.isStageComplete('Starter')),
      ('🍇', 'Jungle', s.isStageComplete('Movers')),
      ('☁️', 'Sky', s.isStageComplete('Flyers')),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.82,
      children: [
        for (final b in badges)
          GestureDetector(
            onTap: () {
              SoundService().playPop();
              if (b.$3) SoundService().speakEnglish(b.$2);
            },
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: b.$3 ? const Color(0xFFFFF3D6) : KidsColors.locked,
                      shape: BoxShape.circle,
                      border: Border.all(color: b.$3 ? KidsColors.gold : KidsColors.lockedDark, width: 3),
                    ),
                    child: Center(
                      child: b.$3
                          ? Text(b.$1, style: const TextStyle(fontSize: 30))
                          : const Icon(Icons.lock_rounded, color: KidsColors.lockedDark),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    b.$2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: b.$3 ? KidsColors.ink : KidsColors.inkSoft,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
