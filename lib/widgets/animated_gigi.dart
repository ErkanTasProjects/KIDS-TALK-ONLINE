import 'package:flutter/material.dart';
import '../services/sound_service.dart';

/// Kids Talk Online - Canli ve Yuksek Performansli Gigi Zurafa Maskotu
/// Kasma ve takilma yapmaz (60-120 FPS), dogal ve piril piril 3D gorunum.
class AnimatedGigi extends StatefulWidget {
  final double size;
  final bool showSpeechBubble;
  final String? customMessage;
  final VoidCallback? onTap;

  const AnimatedGigi({
    super.key,
    this.size = 110,
    this.showSpeechBubble = false,
    this.customMessage,
    this.onTap,
  });

  @override
  State<AnimatedGigi> createState() => _AnimatedGigiState();
}

class _AnimatedGigiState extends State<AnimatedGigi> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    )..repeat(reverse: true);

    _hoverAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );

    _rotateAnimation = Tween<double>(begin: -0.025, end: 0.025).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    SoundService().playPop();
    SoundService().speakEnglish(widget.customMessage ?? "Hello! I am Gigi! Let's learn English together!");
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _hoverAnimation.value),
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: child,
              ),
            );
          },
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Arka plandaki yumusak parilti
                Container(
                  width: widget.size * 0.88,
                  height: widget.size * 0.88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF66BB6A).withValues(alpha: 0.25),
                        const Color(0xFFFFD54F).withValues(alpha: 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Yuksek Kaliteli 3D Gigi Maskotu
                Image.asset(
                  'assets/images/user_mascot_optimized.png',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text("🦒", style: TextStyle(fontSize: widget.size * 0.6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
