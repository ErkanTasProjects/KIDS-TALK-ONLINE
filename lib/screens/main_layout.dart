import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../utils/app_strings.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'quests_screen.dart';
import 'subscription_screen.dart';
import 'vocabulary_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      SoundService().setAudioSettings(
        soundEnabled: appState.isSoundEnabled,
        musicEnabled: appState.isMusicEnabled,
      );
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const QuestsScreen(),
    const VocabularyScreen(),
    const SubscriptionScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      SoundService().playTap();
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FE),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            children: [
              Expanded(
                // Alt sistem boslugunu alt menu zaten birakiyor; ekranlarin
                // SafeArea'si bir kez daha birakinca menunun ustunde bos bir
                // serit olusuyordu. Icerik icin alt boslugu kaldir.
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final isTurkish = context.watch<AppState>().isTurkish;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: Colors.purple.shade50, width: 2)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.map_rounded, AppStrings.tr('nav_map', isTurkish), const Color(0xFF2E7D32)),
            _buildNavItem(1, Icons.emoji_events_rounded, AppStrings.tr('nav_quests', isTurkish), const Color(0xFFE65100)),
            _buildNavItem(2, Icons.menu_book_rounded, AppStrings.tr('nav_words', isTurkish), const Color(0xFF0288D1)),
            _buildNavItem(3, Icons.stars_rounded, AppStrings.tr('nav_club', isTurkish), const Color(0xFF8E24AA)),
            _buildNavItem(4, Icons.person_rounded, AppStrings.tr('nav_profile', isTurkish), const Color(0xFF512DA8)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    final isSelected = _selectedIndex == index;

    // Expanded: 5 sekme her zaman ekran genisligine sigar (eskiden dar
    // telefonlarda alt menu sagdan tasiyordu)
    return Expanded(
      child: GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: activeColor.withValues(alpha: 0.3), width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? activeColor : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  color: isSelected ? activeColor : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
