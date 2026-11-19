import 'dart:math';

import 'package:flutter/material.dart';

/// Ebeveyn Kilidi: cocugun cozemeyecegi, her seferinde degisen bir carpma
/// sorusu sorar. Dogru cevapta true doner.
/// (Google Play "Families" / App Store "Kids" kategorisi gereksinimi.)
Future<bool> showParentGate(BuildContext context) async {
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
      title: const Text(
        "🛡️ Parent Gate",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
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
