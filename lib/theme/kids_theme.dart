import 'package:flutter/material.dart';

/// "Gigi'nin Safari Yolu" tasarim sistemi.
/// Her Cambridge seviyesi ayri bir "diyar": kendi rengi, adi ve maskotu var.
class Land {
  final String stage; // 'Starter' | 'Movers' | 'Flyers'
  final int number;
  final String name;
  final String emoji;
  final String subtitle;
  final Color color;
  final Color dark; // 3D alt kenar / golge
  final Color light; // zemin tonu
  final String mascotA; // yol kenari karakterleri
  final String mascotB;

  const Land({
    required this.stage,
    required this.number,
    required this.name,
    required this.emoji,
    required this.subtitle,
    required this.color,
    required this.dark,
    required this.light,
    required this.mascotA,
    required this.mascotB,
  });

  static const starter = Land(
    stage: 'Starter',
    number: 1,
    name: 'Sunny Savanna',
    emoji: '🌿',
    subtitle: 'Greetings, routines, family & school',
    color: Color(0xFF14B8A6),
    dark: Color(0xFF0F8F82),
    light: Color(0xFFE6FBF8),
    mascotA: 'assets/images/gigi_waving.png',
    mascotB: 'assets/images/piko_cropped.png',
  );

  static const movers = Land(
    stage: 'Movers',
    number: 2,
    name: 'Berry Jungle',
    emoji: '🍇',
    subtitle: 'Balloons, sentences, memory & subjects',
    color: Color(0xFF8B5CF6),
    dark: Color(0xFF6D3FD8),
    light: Color(0xFFF3EEFF),
    mascotA: 'assets/images/gigi_pointing.png',
    mascotB: 'assets/images/piko_cropped.png',
  );

  static const flyers = Land(
    stage: 'Flyers',
    number: 3,
    name: 'Sky Islands',
    emoji: '☁️',
    subtitle: 'Hidden objects, hobbies & speaking',
    color: Color(0xFFFF8A00),
    dark: Color(0xFFD96F00),
    light: Color(0xFFFFF3E3),
    mascotA: 'assets/images/gigi_thinking.png',
    mascotB: 'assets/images/piko_cropped.png',
  );

  static const all = [starter, movers, flyers];

  static Land of(String stage) =>
      all.firstWhere((l) => l.stage.toLowerCase() == stage.toLowerCase(), orElse: () => starter);
}

/// Aktivite turune gore yol uzerindeki tas simgesi.
class ActivityIcon {
  static String emojiFor(String type) {
    switch (type) {
      case 'matching':
        return '🧩';
      case 'drag_drop':
      case 'schedule_drag':
        return '✋';
      case 'trace':
        return '✏️';
      case 'listen_choose':
        return '🎧';
      case 'balloon_pop':
        return '🎈';
      case 'sentence_builder':
        return '🧱';
      case 'memory':
        return '🃏';
      case 'hidden_object':
        return '🔍';
      case 'fill_blank':
        return '🔤';
      case 'speak_record':
        return '🎙️';
      case 'count_feed':
        return '🍎';
      case 'color_train':
        return '🚂';
      default:
        return '⭐';
    }
  }

  static String labelFor(String type) {
    switch (type) {
      case 'matching':
        return 'Match';
      case 'drag_drop':
      case 'schedule_drag':
        return 'Drag & Drop';
      case 'trace':
        return 'Trace';
      case 'listen_choose':
        return 'Listen';
      case 'balloon_pop':
        return 'Balloon Pop';
      case 'sentence_builder':
        return 'Build';
      case 'memory':
        return 'Memory';
      case 'hidden_object':
        return 'Find It';
      case 'fill_blank':
        return 'Fill In';
      case 'speak_record':
        return 'Speak';
      default:
        return 'Play';
    }
  }
}

class KidsColors {
  static const ink = Color(0xFF1F2A44);
  static const inkSoft = Color(0xFF6B7690);
  static const line = Color(0xFFE7E9F2);
  static const bg = Color(0xFFFAFBFF);
  static const locked = Color(0xFFE3E6EE);
  static const lockedDark = Color(0xFFC5CAD6);
  static const gold = Color(0xFFFFC21A);
  static const goldDark = Color(0xFFE09E00);
  static const heart = Color(0xFFFF4B6E);
  static const gem = Color(0xFF1CB0F6);
  static const flame = Color(0xFFFF9600);
}

/// Basinca asagi "gomulen" 3D jole buton (tum ekranlarda ortak dil).
class JellyButton extends StatefulWidget {
  final Widget child;
  final Color color;
  final Color shadow;
  final VoidCallback? onTap;
  final double depth;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const JellyButton({
    super.key,
    required this.child,
    required this.color,
    required this.shadow,
    this.onTap,
    this.depth = 6,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.width,
    this.height,
  });

  @override
  State<JellyButton> createState() => _JellyButtonState();
}

class _JellyButtonState extends State<JellyButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final d = _down ? 1.0 : widget.depth;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.width,
        height: widget.height == null ? null : widget.height! + widget.depth,
        child: Padding(
          padding: EdgeInsets.only(top: widget.depth - d),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            height: widget.height == null ? null : widget.height! + d,
            decoration: BoxDecoration(
              color: widget.shadow,
              borderRadius: widget.borderRadius,
            ),
            padding: EdgeInsets.only(bottom: d),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: widget.borderRadius,
              ),
              child: Center(widthFactor: 1, heightFactor: 1, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Renkli ekran basligi: buyuk baslik + alt yazi + sagda maskot.
class KidsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String image;
  final Widget? trailing;

  const KidsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.image,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, top + 14, 12, 0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          // Hafif dekoratif daireler
          Positioned(
            right: 70,
            top: -20,
            child: _bubble(70, Colors.white.withValues(alpha: 0.10)),
          ),
          Positioned(
            left: -30,
            bottom: -10,
            child: _bubble(90, Colors.white.withValues(alpha: 0.08)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (trailing != null) ...[const SizedBox(height: 10), trailing!],
                    ],
                  ),
                ),
              ),
              Image.asset(image, height: 118, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 90)),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _bubble(double size, Color c) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

/// Bolum basligi: "DAILY QUESTS" gibi gri, harf aralikli etiket.
class SectionLabel extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionLabel(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(
                color: KidsColors.inkSoft,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Icinde "3 / 5" yazan kalin ilerleme cubugu.
class FatProgressBar extends StatelessWidget {
  final double value;
  final String label;
  final Color color;
  const FatProgressBar({super.key, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 22,
        child: Stack(
          children: [
            Container(color: KidsColors.line),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                // ust parlama
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: value > 0.08
                    ? Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )
                    : null,
              ),
            ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: value >= 0.55 ? Colors.white : KidsColors.inkSoft,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
