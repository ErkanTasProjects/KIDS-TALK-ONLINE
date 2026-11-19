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
  final int initialIndex;
  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _selectedIndex = widget.initialIndex;

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
      backgroundColor: Colors.white,
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

    // Simgeli, yazisiz alt menu: secili sekme renkli yuvarlak kutu icinde.
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7E9F2), width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavItem(0, '🗺️', AppStrings.tr('nav_map', isTurkish), const Color(0xFF14B8A6)),
            _buildNavItem(1, '🎯', AppStrings.tr('nav_quests', isTurkish), const Color(0xFFFF8A00)),
            _buildNavItem(2, '📚', AppStrings.tr('nav_words', isTurkish), const Color(0xFF1CB0F6)),
            _buildNavItem(3, '👑', AppStrings.tr('nav_club', isTurkish), const Color(0xFF8B5CF6)),
            _buildNavItem(4, '🦒', AppStrings.tr('nav_profile', isTurkish), const Color(0xFFFF4B6E)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String emoji, String label, Color activeColor) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: Semantics(
        label: label,
        button: true,
        selected: isSelected,
        child: Tooltip(
          message: label,
          child: GestureDetector(
            onTap: () => _onItemTapped(index),
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 58,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? activeColor.withValues(alpha: 0.6) : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: isSelected ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Opacity(
                      opacity: isSelected ? 1 : 0.85,
                      child: Text(emoji, style: const TextStyle(fontSize: 27)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
