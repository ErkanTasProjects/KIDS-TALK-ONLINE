import 'package:flutter/material.dart';

class BouncyButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final VoidCallback onPressed;
  final bool isActive; // Butonun aktif/pasif durumu

  const BouncyButton({
    super.key,
    required this.text,
    required this.color,
    required this.shadowColor,
    required this.onPressed,
    this.isActive = true, // Varsayılan olarak aktif
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Eger buton pasifse gri renkler kullan
    final bgColor = widget.isActive ? widget.color : Colors.grey.shade300;
    final shColor = widget.isActive ? widget.shadowColor : Colors.grey.shade400;
    final textColor = widget.isActive ? Colors.white : Colors.grey.shade500;

    return GestureDetector(
      onTapDown: widget.isActive ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.isActive
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 6.0 : 0.0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: shColor,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.text.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
