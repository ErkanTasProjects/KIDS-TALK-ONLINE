import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sound_service.dart';
import '../state/app_state.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isAnnual = true;

  /// Ebeveyn Kilidi: cocuklarin kendi basina abonelik baslatmasini engeller
  /// (Google Play "Families" ve App Store "Kids" kategorisi gereksinimi).
  /// Cocugun cozemeyecegi bir carpma sorusu sorulur.
  Future<bool> _showParentGate() async {
    final rnd = Random();
    final a = 6 + rnd.nextInt(7); // 6-12
    final b = 3 + rnd.nextInt(7); // 3-9
    final correct = a * b;
    final options = <int>{correct};
    while (options.length < 3) {
      final delta = (rnd.nextInt(5) + 1) * (rnd.nextBool() ? 1 : -1);
      final candidate = correct + delta * (rnd.nextBool() ? 1 : a);
      if (candidate > 0) options.add(candidate);
    }
    final shuffled = options.toList()..shuffle(rnd);

    final passed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("🛡️ Parent Gate", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Grown-ups only! Please solve this to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 14),
            Text(
              "$a × $b = ?",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF4A148C)),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: shuffled
                  .map((n) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade50,
                          foregroundColor: const Color(0xFF4A148C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(n == correct),
                        child: Text("$n", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      ),
    );
    return passed ?? false;
  }

  Future<void> _showPurchaseDialog() async {
    final ok = await _showParentGate();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please ask a grown-up to help you. 🙂"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text("🌟 Star Club", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text(
          "Start your 7-day free trial (${_isAnnual ? "Annual plan" : "Monthly plan"}). "
          "You can cancel anytime from Google Play / App Store.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("START FREE ⭐", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;

    // TODO(odeme): Gercek tahsilat icin in_app_purchase / RevenueCat entegrasyonu
    // gerekli. Simdilik deneme uyeligi cihazda yerel olarak acilir.
    context.read<AppState>().setVip(true);
    SoundService().playVictory();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🎉 Hooray! Your 7-Day Free Trial Has Started!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVip = context.watch<AppState>().isVip;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FE),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                // 1. Kozmik Kulup Basligi
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF7B1FA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
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
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "STAR CHAMPIONS CLUB ⭐",
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Unlimited Learning",
                                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "All Cambridge missions & voices unlocked!",
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Yillik / Aylik Secim Butonu
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isAnnual = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_isAnnual ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Monthly",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !_isAnnual ? const Color(0xFF1A237E) : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isAnnual = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _isAnnual ? Colors.amber : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  // FittedBox: dar ekranda yarim genislige sigmayan metin tasmasin
                                  child: const Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "Annual (50% OFF) 🎁",
                                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
                                      ),
                                    ),
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
                const SizedBox(height: 20),

                // 2. Ayricaliklar Listesi
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.purple.shade100, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      _buildPerkItem(Icons.favorite_rounded, Colors.redAccent, "Unlimited Hearts & Energy", "Never wait, practice anytime as much as you like"),
                      const Divider(height: 20),
                      _buildPerkItem(Icons.headset_rounded, const Color(0xFF7B1FA2), "Studio Quality Voice Audio", "Clear, natural, child-friendly speech and pronunciation"),
                      const Divider(height: 20),
                      _buildPerkItem(Icons.verified_rounded, Colors.green, "Official Cambridge YLE Certificate", "Starters, Movers & Flyers completion diplomas"),
                      const Divider(height: 20),
                      _buildPerkItem(Icons.block_rounded, Colors.orange, "100% Safe & Ad-Free", "Child-safe, fully protected learning environment"),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // 3. Fiyat ve Baslatma Butonu
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.amber.shade300, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _isAnnual ? "\$4.99 / mo (Billed Annually)" : "\$8.99 / mo",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFE65100)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "First 7 Days Free! Cancel anytime.",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9800),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          onPressed: isVip ? null : _showPurchaseDialog,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isVip ? "STAR CLUB ACTIVE ✅" : "START 7-DAY FREE TRIAL 🚀",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
        ),
      ),
    );
  }

  Widget _buildPerkItem(IconData icon, Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF263238))),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }
}
