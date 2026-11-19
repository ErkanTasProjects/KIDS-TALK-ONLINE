import 'package:flutter/material.dart';
import '../services/sound_service.dart';
import '../widgets/bouncy_button.dart';
import 'explorer_builder_screen.dart';
import 'main_layout.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9FE),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ust Logo & Baslik
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.shade300, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withValues(alpha: 0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/giraffe_logo.png',
                                    width: 24,
                                    height: 24,
                                    errorBuilder: (_, __, ___) => const Text("🦒", style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "KIDS TALK ONLINE",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: Color(0xFFE65100),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Welcome to\nKids Talk Online! ⭐",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF263238),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),

                  // Orta Maskot & Diyalog (Gigi)
                  Column(
                    children: [
                      AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _bounceAnimation.value),
                            child: child,
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            SoundService().playPop();
                            SoundService().speakEnglish("Hello! I am Gigi the Giraffe! Let's explore English together!");
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Arka parildama halesi
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.purple.withValues(alpha: 0.1),
                                ),
                              ),
                              Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFAB47BC), width: 3.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withValues(alpha: 0.25),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/images/user_mascot_optimized.png',
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Text("🦒", style: TextStyle(fontSize: 70)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Konusma Balonu
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.shade200, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("🦒", style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text(
                              "\"Let's learn English together! ⭐\"",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE65100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Alt Butonlar (Login/Register Kaldirildi - 100% Cocuk Dostu ve Eglenceli)
                  Column(
                    children: [
                      // 1. Maceraya Basla (Dogrudan Haritaya / Ana Ekrana)
                      BouncyButton(
                        text: "START ADVENTURE 🚀",
                        color: const Color(0xFFFF9800),
                        shadowColor: const Color(0xFFE65100),
                        isActive: true,
                        onPressed: () {
                          SoundService().playTap();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainLayout()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // 2. Kasifini Tasarla (Traveler / Explorer Builder)
                      BouncyButton(
                        text: "BUILD YOUR EXPLORER 🎨",
                        color: const Color(0xFF7B1FA2),
                        shadowColor: const Color(0xFF4A148C),
                        isActive: true,
                        onPressed: () {
                          SoundService().playTap();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ExplorerBuilderScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 10),

                      // 3. Hizli Tanisma Turu (Onboarding)
                      TextButton(
                        onPressed: () {
                          SoundService().playTap();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                          );
                        },
                        child: Text(
                          "Meet Gigi & Take Tour 🌟 ➔",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
