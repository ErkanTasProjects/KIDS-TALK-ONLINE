import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/curriculum_data.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';
import '../theme/kids_theme.dart';
import '../utils/page_transitions.dart';
import 'lesson_screen.dart';

/// Ana harita: "Gigi'nin Safari Yolu".
/// Tek, surekli kivrimli bir patika; her seviye ayri renkli bir diyar.
/// Diyar basligi kaydirirken ustte yapisik kalir ve diyar degisince degisir.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Yerlesim sabitleri (kaydirma hedefini hesaplamak icin deterministik)
const double _bannerH = 104;
const double _trailTop = 34;
const double _rowH = 118;
const double _chestRowH = 128;
const double _trailBottom = 40;

double _trailHeight(int nodes) => _trailTop + nodes * _rowH + _chestRowH + _trailBottom;

/// Dalga seklinde yatay kayma (merkezden piksel). Duolingo'dan farkli olarak
/// tek yone uzun bir "S" kivrimi cizer.
const List<double> _wave = [0, -78, -104, -60, 18, 86, 104, 56];

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scroll = ScrollController();
  bool _showJump = false;
  bool _jumpUp = true;
  bool _didInitialScroll = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_updateJumpButton);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Siradaki dersin kaydirma konumu (merkezde gorunecek sekilde).
  double? _currentOffset(AppState s, double viewport) {
    final current = s.currentActivity;
    if (current == null) return null;
    double y = 0;
    for (final land in Land.all) {
      final list = CurriculumData.getActivitiesByStage(land.stage);
      final idx = list.indexWhere((a) => a.id == current.id);
      if (idx == -1) {
        y += _bannerH + _trailHeight(list.length);
        continue;
      }
      y += _bannerH + _trailTop + idx * _rowH + _rowH / 2;
      return math.max(0, y - viewport * 0.45);
    }
    return null;
  }

  void _updateJumpButton() {
    if (!_scroll.hasClients) return;
    final s = context.read<AppState>();
    final viewport = _scroll.position.viewportDimension;
    final target = _currentOffset(s, viewport);
    final show = target != null && (target - _scroll.offset).abs() > viewport * 0.6;
    final up = target != null && target < _scroll.offset;
    if (show != _showJump || up != _jumpUp) {
      setState(() {
        _showJump = show;
        _jumpUp = up;
      });
    }
  }

  void _jumpToCurrent({bool animate = true}) {
    if (!_scroll.hasClients) return;
    final s = context.read<AppState>();
    final target = _currentOffset(s, _scroll.position.viewportDimension);
    if (target == null) return;
    final clamped = target.clamp(0.0, _scroll.position.maxScrollExtent);
    if (animate) {
      _scroll.animateTo(clamped, duration: const Duration(milliseconds: 650), curve: Curves.easeInOutCubic);
    } else {
      _scroll.jumpTo(clamped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    // Ilk acilista siradaki derse kaydir
    if (appState.isLoaded && !_didInitialScroll) {
      _didInitialScroll = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToCurrent(animate: false);
        _updateJumpButton();
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopStatsBar(appState: appState),
            Expanded(
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: _scroll,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      for (final land in Land.all)
                        SliverMainAxisGroup(
                          slivers: [
                            PinnedHeaderSliver(child: _LandBanner(land: land, appState: appState)),
                            SliverToBoxAdapter(child: _LandTrail(land: land, appState: appState)),
                          ],
                        ),
                      const SliverToBoxAdapter(child: _TrailEnd()),
                    ],
                  ),
                  // "Siradaki derse don" butonu
                  Positioned(
                    right: 16,
                    bottom: 18,
                    child: AnimatedScale(
                      scale: _showJump ? 1 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      child: JellyButton(
                        color: Colors.white,
                        shadow: KidsColors.line,
                        depth: 4,
                        padding: const EdgeInsets.all(14),
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          SoundService().playTap();
                          _jumpToCurrent();
                        },
                        child: Icon(
                          _jumpUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          color: KidsColors.gem,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// UST ISTATISTIK CUBUGU
// =========================================================================
class _TopStatsBar extends StatelessWidget {
  final AppState appState;
  const _TopStatsBar({required this.appState});

  @override
  Widget build(BuildContext context) {
    final streakOn = appState.streak > 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      color: Colors.white,
      child: Row(
        children: [
          // Kasif avatari
          GestureDetector(
            onTap: () {
              SoundService().playPop();
              SoundService().speakEnglish("Hello! I am Gigi! Let's explore new English adventures!");
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(appState.avatarColor).withValues(alpha: 0.25),
                border: Border.all(color: Color(appState.avatarColor), width: 2.5),
              ),
              padding: const EdgeInsets.all(3),
              child: ClipOval(
                child: Image.asset('assets/images/user_mascot_optimized.png', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Text('🦒'))),
              ),
            ),
          ),
          const Spacer(),
          _Stat(
            icon: const _EnBadge(),
            value: '${appState.totalStars}',
            color: KidsColors.ink,
            onTap: () => SoundService().speakEnglish("You have ${appState.totalStars} stars!"),
          ),
          const Spacer(),
          _Stat(
            icon: Text('🔥', style: TextStyle(fontSize: 22, color: streakOn ? null : Colors.grey)),
            value: '${appState.streak}',
            color: streakOn ? KidsColors.flame : KidsColors.inkSoft,
            onTap: () => SoundService().speakEnglish("${appState.streak} day streak!"),
          ),
          const Spacer(),
          _Stat(
            icon: const Text('💎', style: TextStyle(fontSize: 21)),
            value: '${appState.gems}',
            color: KidsColors.gem,
            onTap: () => SoundService().speakEnglish("You have ${appState.gems} diamonds!"),
          ),
          const Spacer(),
          _Stat(
            icon: const Text('💖', style: TextStyle(fontSize: 21)),
            value: appState.isVip ? '∞' : '${appState.hearts}',
            color: KidsColors.heart,
            onTap: () => showHeartsInfo(context, appState),
          ),
        ],
      ),
    );
  }
}

class _EnBadge extends StatelessWidget {
  const _EnBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(6),
        border: const Border(bottom: BorderSide(color: Color(0xFF1D4ED8), width: 2.5)),
      ),
      child: const Text('EN', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
    );
  }
}

class _Stat extends StatelessWidget {
  final Widget icon;
  final String value;
  final Color color;
  final VoidCallback onTap;
  const _Stat({required this.icon, required this.value, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SoundService().playPop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 5),
            Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }
}

/// Can bilgisi: dolu mu, sonraki can ne zaman, elmasla doldurma.
void showHeartsInfo(BuildContext context, AppState appState) {
  appState.refreshHearts();
  final full = appState.isVip || appState.hearts >= AppState.maxHearts;
  final wait = appState.timeToNextHeart;
  final mins = wait == null ? 0 : (wait.inSeconds / 60).ceil();
  final canBuy = appState.gems >= AppState.heartRefillCost;

  if (full) SoundService().speakEnglish("Full hearts! Ready to play!");

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        appState.isVip ? "💖 Unlimited hearts" : "💖 ${appState.hearts} / ${AppState.maxHearts}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      content: Text(
        full ? "Your hearts are full. Ready to play!" : "A wrong answer costs 1 heart.\nNext heart in $mins min.",
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("OK")),
        if (!full)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: KidsColors.gem, foregroundColor: Colors.white),
            onPressed: canBuy
                ? () {
                    appState.refillHeartsWithGems();
                    SoundService().playCorrect();
                    SoundService().speakEnglish("Hearts refilled!");
                    Navigator.of(ctx).pop();
                  }
                : null,
            child: Text("REFILL 💎 ${AppState.heartRefillCost}"),
          ),
      ],
    ),
  );
}

// =========================================================================
// DIYAR BASLIGI (yapisik)
// =========================================================================
class _LandBanner extends StatelessWidget {
  final Land land;
  final AppState appState;
  const _LandBanner({required this.land, required this.appState});

  @override
  Widget build(BuildContext context) {
    final total = CurriculumData.getActivitiesByStage(land.stage).length;
    final done = appState.completedInStage(land.stage);
    return Container(
      height: _bannerH,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
      child: Container(
        decoration: BoxDecoration(
          color: land.color,
          borderRadius: BorderRadius.circular(20),
          border: Border(bottom: BorderSide(color: land.dark, width: 5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "LAND ${land.number} · ${land.stage.toUpperCase()} · $done/$total",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${land.emoji} ${land.name}",
                        style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Rehber kitabi
            Container(width: 2, height: double.infinity, color: land.dark.withValues(alpha: 0.5)),
            InkWell(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
              onTap: () => _showGuide(context),
              child: const SizedBox(
                width: 64,
                child: Center(child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 28)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGuide(BuildContext context) {
    SoundService().playPop();
    final list = CurriculumData.getActivitiesByStage(land.stage);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.8),
        padding: EdgeInsets.fromLTRB(20, 18, 20, 20 + MediaQuery.viewPaddingOf(ctx).bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: KidsColors.line, borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 14),
            Text("${land.emoji} ${land.name} Guide",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: land.dark)),
            const SizedBox(height: 4),
            Text(land.subtitle, style: const TextStyle(color: KidsColors.inkSoft, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final a = list[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: land.light,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(ActivityIcon.emojiFor(a.activityType), style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.title,
                                  style: const TextStyle(fontWeight: FontWeight.w900, color: KidsColors.ink)),
                              Text("${a.stageNumber} · ${a.topic}",
                                  style: const TextStyle(fontSize: 12, color: KidsColors.inkSoft)),
                            ],
                          ),
                        ),
                        if (appState.isCompleted(a)) const Text('✅'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// DIYAR PATIKASI: dugumler + kesikli yol + karakterler + sandik
// =========================================================================
class _LandTrail extends StatelessWidget {
  final Land land;
  final AppState appState;
  const _LandTrail({required this.land, required this.appState});

  @override
  Widget build(BuildContext context) {
    final activities = CurriculumData.getActivitiesByStage(land.stage);
    final landUnlocked = appState.isStageUnlocked(land.stage);
    final current = appState.currentActivity;

    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final scale = (w / 420).clamp(0.72, 1.0);
      double xFor(int i) => w / 2 + _wave[i % _wave.length] * scale;
      double yFor(int i) => _trailTop + i * _rowH + _rowH / 2;

      final centers = <Offset>[
        for (var i = 0; i < activities.length; i++) Offset(xFor(i), yFor(i)),
      ];
      final chestCenter = Offset(w / 2 + 40 * scale, _trailTop + activities.length * _rowH + _chestRowH / 2);
      final points = [...centers, chestCenter];
      final reached = <bool>[
        for (var i = 0; i < activities.length; i++) appState.isUnlocked(activities[i]),
        appState.isStageComplete(land.stage),
      ];

      // Karakterler dalganin bos tarafina yerlesir
      final mascotSize = 150 * scale;

      return SizedBox(
        height: _trailHeight(activities.length),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _TrailPainter(points: points, reached: reached, color: land.color)),
            ),
            // Karakter A: ust kivrimin karsi tarafi (sag)
            Positioned(
              right: 6,
              top: _trailTop + _rowH * 0.55,
              child: _Mascot(path: land.mascotA, height: mascotSize, active: landUnlocked),
            ),
            // Karakter B: sandigin karsisinda (sol)
            Positioned(
              left: 14,
              top: _trailTop + activities.length * _rowH - 6,
              child: _Mascot(path: land.mascotB, height: mascotSize * 0.72, active: landUnlocked, flip: true),
            ),
            for (var i = 0; i < activities.length; i++)
              Positioned(
                left: centers[i].dx - _TrailNode.size / 2,
                top: centers[i].dy - _TrailNode.size / 2 - 6,
                child: _TrailNode(
                  activity: activities[i],
                  land: land,
                  unlocked: appState.isUnlocked(activities[i]),
                  completed: appState.isCompleted(activities[i]),
                  isCurrent: current?.id == activities[i].id,
                  stars: appState.getStarsFor(activities[i].id),
                ),
              ),
            Positioned(
              left: chestCenter.dx - 42,
              top: chestCenter.dy - 42,
              child: _LandChest(land: land, appState: appState),
            ),
          ],
        ),
      );
    });
  }
}

class _TrailPainter extends CustomPainter {
  final List<Offset> points;
  final List<bool> reached;
  final Color color;
  _TrailPainter({required this.points, required this.reached, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < points.length - 1; i++) {
      final a = points[i];
      final b = points[i + 1];
      final path = Path()
        ..moveTo(a.dx, a.dy)
        ..cubicTo(a.dx, a.dy + (b.dy - a.dy) * 0.55, b.dx, b.dy - (b.dy - a.dy) * 0.55, b.dx, b.dy);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 9
        ..color = reached[i + 1] ? color.withValues(alpha: 0.45) : KidsColors.locked;
      // Kesikli cizgi: patika "ayak izi" gibi
      for (final metric in path.computeMetrics()) {
        double d = 0;
        while (d < metric.length) {
          final seg = metric.extractPath(d, math.min(d + 12, metric.length));
          canvas.drawPath(seg, paint);
          d += 22;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TrailPainter old) =>
      old.points != points || old.reached.toString() != reached.toString() || old.color != color;
}

class _Mascot extends StatelessWidget {
  final String path;
  final double height;
  final bool active;
  final bool flip;
  const _Mascot({required this.path, required this.height, required this.active, this.flip = false});

  // Kilitli diyarda karakterler gri (henuz ulasilmadi hissi)
  static const _grey = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 0.45, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    Widget img = Image.asset(path, height: height, fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => SizedBox(height: height));
    if (flip) img = Transform.flip(flipX: true, child: img);
    if (!active) img = ColorFiltered(colorFilter: _grey, child: img);
    return IgnorePointer(child: img);
  }
}

/// Patikadaki ders tasi: 3D "jole" yuvarlatilmis kare.
class _TrailNode extends StatefulWidget {
  static const double size = 78;
  final ActivityItem activity;
  final Land land;
  final bool unlocked;
  final bool completed;
  final bool isCurrent;
  final int stars;

  const _TrailNode({
    required this.activity,
    required this.land,
    required this.unlocked,
    required this.completed,
    required this.isCurrent,
    required this.stars,
  });

  @override
  State<_TrailNode> createState() => _TrailNodeState();
}

class _TrailNodeState extends State<_TrailNode> with SingleTickerProviderStateMixin {
  late final AnimationController _bounce =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

  @override
  void initState() {
    super.initState();
    if (widget.isCurrent) _bounce.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _TrailNode old) {
    super.didUpdateWidget(old);
    if (widget.isCurrent && !_bounce.isAnimating) _bounce.repeat(reverse: true);
    if (!widget.isCurrent && _bounce.isAnimating) _bounce.stop();
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  void _tap(BuildContext context) {
    if (!widget.unlocked) {
      SoundService().playWrong();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("🔒 Finish the lesson before this one to unlock it!"),
        ),
      );
      return;
    }
    SoundService().playTap();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _LessonStartBottomSheet(activity: widget.activity, land: widget.land),
    );
  }

  @override
  Widget build(BuildContext context) {
    final land = widget.land;
    final face = widget.unlocked ? land.color : KidsColors.locked;
    final lip = widget.unlocked ? land.dark : KidsColors.lockedDark;
    const s = _TrailNode.size;

    final tile = JellyButton(
      width: s,
      height: s - 8,
      depth: 8,
      color: face,
      shadow: lip,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(26),
      onTap: () => _tap(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ust parlama
          Positioned(
            top: 7,
            left: 12,
            child: Container(
              width: 22,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: widget.unlocked ? 0.35 : 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          widget.unlocked
              ? Text(ActivityIcon.emojiFor(widget.activity.activityType), style: const TextStyle(fontSize: 32))
              : const Icon(Icons.lock_rounded, color: KidsColors.lockedDark, size: 32),
        ],
      ),
    );

    return SizedBox(
      width: s,
      height: s + 18,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Siradaki ders: etrafinda halka
          if (widget.isCurrent)
            Positioned(
              top: -9,
              child: Container(
                width: s + 18,
                height: s + 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: land.color.withValues(alpha: 0.3), width: 5),
                ),
              ),
            ),
          tile,
          // Tamamlananlar: yildizlar
          if (widget.completed)
            Positioned(
              bottom: -4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final filled = i < (widget.stars > 0 ? widget.stars : 3);
                  return Icon(Icons.star_rounded, size: 19, color: filled ? KidsColors.gold : KidsColors.locked);
                }),
              ),
            ),
          // Siradaki ders: ziplayan "START" balonu
          if (widget.isCurrent)
            Positioned(
              top: -50,
              child: AnimatedBuilder(
                animation: _bounce,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, -6 * Curves.easeInOut.transform(_bounce.value)),
                  child: child,
                ),
                child: _StartBubble(color: land.color),
              ),
            ),
        ],
      ),
    );
  }
}

class _StartBubble extends StatelessWidget {
  final Color color;
  const _StartBubble({required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KidsColors.line, width: 2),
          ),
          child: Text("START", style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1)),
        ),
        CustomPaint(size: const Size(16, 8), painter: _TrianglePainter()),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0),
      Paint()
        ..color = KidsColors.line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Diyar sonu hazine sandigi: diyar bitince acilir, +30 elmas.
class _LandChest extends StatelessWidget {
  final Land land;
  final AppState appState;
  const _LandChest({required this.land, required this.appState});

  @override
  Widget build(BuildContext context) {
    final opened = appState.isLandChestOpened(land.stage);
    final ready = appState.isStageComplete(land.stage) && !opened;

    return SizedBox(
      width: 84,
      height: 84,
      child: JellyButton(
        width: 84,
        height: 72,
        depth: 7,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(22),
        color: ready ? KidsColors.gold : (opened ? land.light : KidsColors.locked),
        shadow: ready ? KidsColors.goldDark : (opened ? land.color.withValues(alpha: 0.35) : KidsColors.lockedDark),
        onTap: () {
          if (ready) {
            appState.openLandChest(land.stage);
            SoundService().playVictory();
            SoundService().speakEnglish("Treasure chest opened!");
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                title: const Text("🎁 Treasure!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
                content: Text("You finished ${land.name}!\n+${AppState.landChestGems} 💎",
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  ElevatedButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("YAY! ⭐")),
                ],
              ),
            );
          } else if (opened) {
            SoundService().playPop();
          } else {
            SoundService().playWrong();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text("🎁 Finish every lesson in ${land.name} to open this chest!"),
              ),
            );
          }
        },
        child: Text(
          opened ? '💎' : '🎁',
          style: TextStyle(fontSize: 38, color: ready || opened ? null : Colors.grey),
        ),
      ),
    );
  }
}

class _TrailEnd extends StatelessWidget {
  const _TrailEnd();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        children: [
          Image.asset('assets/images/giraffe_mascot.png', height: 120,
              errorBuilder: (_, __, ___) => const SizedBox(height: 120)),
          const SizedBox(height: 8),
          const Text(
            "More adventures coming soon! 🚀",
            textAlign: TextAlign.center,
            style: TextStyle(color: KidsColors.inkSoft, fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// DERS BASLATMA PENCERESI
// =========================================================================
class _LessonStartBottomSheet extends StatelessWidget {
  final ActivityItem activity;
  final Land land;

  const _LessonStartBottomSheet({required this.activity, required this.land});

  @override
  Widget build(BuildContext context) {
    // Alt bosluga sistem gezinme cubugu yuksekligi eklenir
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(22, 14, 22, 20 + bottomInset),
      decoration: BoxDecoration(
        color: land.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(ActivityIcon.emojiFor(activity.activityType), style: const TextStyle(fontSize: 34)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${land.stage.toUpperCase()} ${activity.stageNumber} · ${ActivityIcon.labelFor(activity.activityType).toUpperCase()}",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.title,
                      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "🦒 ${activity.characterQuote}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3),
            ),
          ),
          const SizedBox(height: 18),
          JellyButton(
            width: double.infinity,
            height: 54,
            color: Colors.white,
            shadow: land.dark,
            depth: 5,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              final navigator = Navigator.of(context);
              final appState = context.read<AppState>();
              navigator.pop();
              appState.refreshHearts();
              if (!appState.canPlay) {
                // Can yoksa ders baslamasin
                SoundService().playWrong();
                ScaffoldMessenger.of(navigator.context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("💔 No hearts left! Tap the heart at the top to refill."),
                  ),
                );
                return;
              }
              SoundService().playTap();
              navigator.push(AppPageRoute(page: LessonScreen(activity: activity)));
            },
            child: Text(
              "START +${15 * 3} XP",
              style: TextStyle(color: land.dark, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}
