import 'package:flutter/material.dart';
import '../services/sound_service.dart';

// =========================================================================
// KIDS TALK ONLINE - SEVIMLI KARAKTERLER & ANIMASYON SISTEMI (PERFORMANS ODAKLI)
// =========================================================================

enum CharacterType { gigi, piko, luna, leo, mimi, barnaby, toby, bipBop, zippy }

class KidsCharacterInfo {
  final CharacterType type;
  final String name;
  final String title;
  final Color primaryColor;
  final Color secondaryColor;
  final String emoji;
  final String greetings;

  const KidsCharacterInfo({
    required this.type,
    required this.name,
    required this.title,
    required this.primaryColor,
    required this.secondaryColor,
    required this.emoji,
    required this.greetings,
  });

  static const List<KidsCharacterInfo> all = [
    KidsCharacterInfo(
      type: CharacterType.gigi,
      name: 'Gigi',
      title: 'Friendly Giraffe',
      primaryColor: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFF8E1),
      emoji: '🦒',
      greetings: 'Hello! I am Gigi! Let\'s learn English together!',
    ),
    KidsCharacterInfo(
      type: CharacterType.luna,
      name: 'Luna',
      title: 'Smart Bunny',
      primaryColor: Color(0xFFAB47BC),
      secondaryColor: Color(0xFFF3E5F5),
      emoji: '🐰',
      greetings: 'Hi! Let\'s explore wonderful words today!',
    ),
    KidsCharacterInfo(
      type: CharacterType.leo,
      name: 'Leo',
      title: 'Brave Lion',
      primaryColor: Color(0xFFFF9800),
      secondaryColor: Color(0xFFFFF3E0),
      emoji: '🦁',
      greetings: 'Roar! Speak out loud in English! You are awesome!',
    ),
    KidsCharacterInfo(
      type: CharacterType.mimi,
      name: 'Mimi',
      title: 'Happy Kitty',
      primaryColor: Color(0xFFEC407A),
      secondaryColor: Color(0xFFFCE4EC),
      emoji: '🐱',
      greetings: 'Meow! Let\'s play and learn English together!',
    ),
    KidsCharacterInfo(
      type: CharacterType.barnaby,
      name: 'Barnaby',
      title: 'Wise Bear',
      primaryColor: Color(0xFF1E88E5),
      secondaryColor: Color(0xFFE3F2FD),
      emoji: '🐻',
      greetings: 'Hello my friend! Ready for an exciting adventure?',
    ),
    KidsCharacterInfo(
      type: CharacterType.toby,
      name: 'Toby',
      title: 'Fast Turtle',
      primaryColor: Color(0xFF00897B),
      secondaryColor: Color(0xFFE0F2F1),
      emoji: '🐢',
      greetings: 'Step by step, we will learn every day!',
    ),
    KidsCharacterInfo(
      type: CharacterType.bipBop,
      name: 'Bip-Bop',
      title: 'Smart Robot',
      primaryColor: Color(0xFF00ACC1),
      secondaryColor: Color(0xFFE0F7FA),
      emoji: '🤖',
      greetings: 'Beep-Boop! Robot memory ready! Let\'s practice words!',
    ),
    KidsCharacterInfo(
      type: CharacterType.zippy,
      name: 'Zippy',
      title: 'Shooting Star',
      primaryColor: Color(0xFFFFD600),
      secondaryColor: Color(0xFFFFFDE7),
      emoji: '⭐',
      greetings: 'You are shining bright! Keep going super star!',
    ),
  ];

  static KidsCharacterInfo fromName(String name) {
    final lower = name.toLowerCase();
    if (lower == 'piko') {
      return all[0];
    }
    return all.firstWhere(
      (c) => c.name.toLowerCase() == lower,
      orElse: () => all[0],
    );
  }
}

// -------------------------------------------------------------------------
// CANLI ANIMASYONLU KARAKTER WIDGET'I (HAFIF VE AKICI)
// -------------------------------------------------------------------------
class AnimatedKidsCharacter extends StatefulWidget {
  final CharacterType character;
  final double size;
  final bool isCheering;
  final VoidCallback? onTap;

  const AnimatedKidsCharacter({
    super.key,
    required this.character,
    this.size = 100,
    this.isCheering = false,
    this.onTap,
  });

  @override
  State<AnimatedKidsCharacter> createState() => _AnimatedKidsCharacterState();
}

class _AnimatedKidsCharacterState extends State<AnimatedKidsCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    final info = KidsCharacterInfo.all.firstWhere((c) => c.type == widget.character);
    SoundService().speakEnglish(info.greetings);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final info = KidsCharacterInfo.all.firstWhere((c) => c.type == widget.character);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: child,
            );
          },
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Arka Plan Hale / Isilti
                Container(
                  width: widget.size * 0.92,
                  height: widget.size * 0.92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: info.primaryColor.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: info.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                // Gigi veya diger karakterler
                if (widget.character == CharacterType.gigi || widget.character == CharacterType.piko)
                  Padding(
                    padding: EdgeInsets.all(widget.size * 0.06),
                    child: Image.asset(
                      'assets/images/user_mascot_optimized.png',
                      width: widget.size * 0.88,
                      height: widget.size * 0.88,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(info),
                    ),
                  )
                else
                  _buildFallbackAvatar(info),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(KidsCharacterInfo info) {
    return Container(
      width: widget.size * 0.85,
      height: widget.size * 0.85,
      decoration: BoxDecoration(
        color: info.secondaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: info.primaryColor, width: 2.5),
      ),
      child: Center(
        child: Text(
          info.emoji,
          style: TextStyle(fontSize: widget.size * 0.44),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// SEVIMLI DIYALOG VE REHBERLIK BALONCUGU (SESLENDIRME DESTEKLI)
// -------------------------------------------------------------------------
class CharacterDialogueBox extends StatelessWidget {
  final String characterName;
  final String message;
  final Color? bubbleColor;
  final VoidCallback? onCharacterTap;

  const CharacterDialogueBox({
    super.key,
    required this.characterName,
    required this.message,
    this.bubbleColor,
    this.onCharacterTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sevimli Gigi Maskotu
            GestureDetector(
              onTap: () {
                SoundService().playPop();
                SoundService().speakEnglish(message);
                onCharacterTap?.call();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF3E0),
                  border: Border.all(color: const Color(0xFFFF9800), width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/user_mascot_optimized.png',
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text("🦒", style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Canli ve Anlasilir Gigi Konusma Baloncugu
            Expanded(
              child: GestureDetector(
                onTap: () {
                  SoundService().speakEnglish(message);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFE0B2), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        offset: const Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF9800),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.volume_up_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          message.isNotEmpty ? message : "Let's learn English together! 🦒✨",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2D3748),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
