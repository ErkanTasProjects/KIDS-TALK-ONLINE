import 'package:flutter/material.dart';

/// Kids Talk Online - Yumusak ve Akici Sayfa Gecisleri (60 FPS Animasyon)
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AppPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 260),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Hafif yukari kayma + Opaklik acilmasi (Duolingo & iOS stili)
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}

/// Pop-up veya Tam Ekran Dialog Gecisi (Bouncy Scale)
class ScaleDialogRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScaleDialogRoute({required this.page})
      : super(
          opaque: false,
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            );

            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(curved),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}
