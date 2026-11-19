import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';

class LeagueItem {
  final String name;
  final int minXp;
  final String icon;
  final Color color;

  const LeagueItem({
    required this.name,
    required this.minXp,
    required this.icon,
    required this.color,
  });
}

class WeeklyLeagueDialog extends StatelessWidget {
  const WeeklyLeagueDialog({super.key});

  static const List<LeagueItem> leagues = [
    LeagueItem(name: 'Bronze League', minXp: 0, icon: '🛡️', color: Color(0xFFCD7F32)),
    LeagueItem(name: 'Silver League', minXp: 100, icon: '🛡️', color: Color(0xFF90A4AE)),
    LeagueItem(name: 'Gold League', minXp: 250, icon: '🏆', color: Color(0xFFFFB300)),
    LeagueItem(name: 'Sapphire League', minXp: 500, icon: '💎', color: Color(0xFF1E88E5)),
    LeagueItem(name: 'Ruby Star League', minXp: 850, icon: '✨', color: Color(0xFFE53935)),
    LeagueItem(name: 'Emerald League', minXp: 1300, icon: '🍃', color: Color(0xFF43A047)),
    LeagueItem(name: 'Amethyst League', minXp: 1900, icon: '🔮', color: Color(0xFF8E24AA)),
    LeagueItem(name: 'Pearl League', minXp: 2600, icon: '🪐', color: Color(0xFF00ACC1)),
    LeagueItem(name: 'Obsidian League', minXp: 3500, icon: '⚡', color: Color(0xFF37474F)),
  ];

  static void show(BuildContext context) {
    SoundService().playPop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const WeeklyLeagueDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final currentXp = appState.xp;

    // Find next league
    LeagueItem? nextLeague;
    for (final l in leagues) {
      if (currentXp < l.minXp) {
        nextLeague = l;
        break;
      }
    }

    final xpRemaining = nextLeague != null ? (nextLeague.minXp - currentXp) : 0;
    final nextLeagueName = nextLeague != null ? nextLeague.name : 'Master Champion!';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      // Sistem gezinme cubugunun altinda kalmasin
      padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBF5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar with close icon
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly XP League',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2D3748),
                    letterSpacing: -0.2,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SoundService().playTap();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, size: 20, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          // Current XP Status Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFB74D), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('🛡️', style: TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$currentXp XP Total',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextLeague != null
                            ? '$xpRemaining XP to $nextLeagueName'
                            : 'Top League Achieved! 🏆',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // League List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: leagues.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final league = leagues[index];
                final isUnlocked = currentXp >= league.minXp;
                final isCurrent = isUnlocked &&
                    (index == leagues.length - 1 || currentXp < leagues[index + 1].minXp);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.white
                        : (isUnlocked ? Colors.white.withValues(alpha: 0.9) : const Color(0xFFF9F9FB)),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFFFF9800)
                          : (isUnlocked ? Colors.grey.shade300 : Colors.grey.shade200),
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Text(league.icon, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              league.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: isUnlocked ? const Color(0xFF2D3748) : Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${league.minXp} XP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                        )
                      else if (!isUnlocked)
                        Icon(Icons.lock_rounded, color: Colors.grey.shade400, size: 20)
                      else
                        const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF81C784), size: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
