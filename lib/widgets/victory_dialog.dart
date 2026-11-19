import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import 'bouncy_button.dart';
import 'kids_characters.dart';

class VictoryCelebrationDialog extends StatefulWidget {
  final String characterName;
  final String activityTitle;
  final int stars;
  final int xpEarned;
  final VoidCallback onContinue;

  const VictoryCelebrationDialog({
    super.key,
    required this.characterName,
    required this.activityTitle,
    required this.stars,
    required this.xpEarned,
    required this.onContinue,
  });

  static Future<void> show({
    required BuildContext context,
    required String characterName,
    required String activityTitle,
    int stars = 3,
    int xpEarned = 45,
    required VoidCallback onContinue,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryCelebrationDialog(
        characterName: characterName,
        activityTitle: activityTitle,
        stars: stars,
        xpEarned: xpEarned,
        onContinue: onContinue,
      ),
    );
  }

  @override
  State<VictoryCelebrationDialog> createState() => _VictoryCelebrationDialogState();
}

class _VictoryCelebrationDialogState extends State<VictoryCelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _dialogController;
  late AnimationController _starsController;
  late Animation<double> _scaleAnimation;

  int _displayedStars = 0;

  @override
  void initState() {
    super.initState();

    _dialogController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _dialogController,
      curve: Curves.elasticOut,
    );

    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _dialogController.forward();

    // Yildizlarin sirayla patlamasi (Pop! Pop! Pop!)
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _displayedStars = 1);
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted && widget.stars >= 2) setState(() => _displayedStars = 2);
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && widget.stars >= 3) {
        setState(() => _displayedStars = 3);
        SoundService().speakEnglish("Awesome job! You earned three stars!");
      }
    });
  }

  @override
  void dispose() {
    _dialogController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterInfo = KidsCharacterInfo.fromName(widget.characterName);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.amber.shade300, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ustte Ziplayan Maskot
              AnimatedKidsCharacter(
                character: characterInfo.type,
                size: 110,
                isCheering: true,
              ),
              const SizedBox(height: 12),

              // Seviye Basligi
              Text(
                widget.activityTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                "AWESOME SUCCESS! 🏆",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF8F00),
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 3 Yildiz Kutlama Animasyonu
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isEarned = index < _displayedStars;
                  return AnimatedScale(
                    scale: isEarned ? 1.15 : 0.8,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        Icons.star_rounded,
                        size: index == 1 ? 58 : 46, // Ortadaki yıldız daha büyük
                        color: isEarned ? const Color(0xFFFFB300) : Colors.grey.shade300,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // XP Odul Rozeti
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade400, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, color: Colors.orange, size: 28),
                    const SizedBox(width: 6),
                    Text(
                      "+${widget.xpEarned} XP EARNED!",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE65100),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ilerleme / Devam Butonu
              SizedBox(
                width: double.infinity,
                child: BouncyButton(
                  text: "CONTINUE ADVENTURE 🚀",
                  color: const Color(0xFF4CAF50),
                  shadowColor: const Color(0xFF2E7D32),
                  isActive: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onContinue();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CelebrationOverlay extends StatelessWidget {
  final bool showCelebration;
  final Widget child;

  const CelebrationOverlay({
    super.key,
    required this.showCelebration,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showCelebration)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.amber.withValues(alpha: 0.12),
                child: const Center(
                  child: Text(
                    "⭐ 🎉 🌟",
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
