import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String imagePath;
  final double scale;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.imagePath,
    this.scale = 1.5, // Tamaño por defecto
    required this.onPressed,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed(); // Ejecuta la acción pasada como parámetro
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: TweenAnimationBuilder(
        tween: ColorTween(
          begin: Colors.transparent,
          end: _isPressed ? Colors.white.withOpacity(0.3) : Colors.transparent,
        ),
        duration: const Duration(milliseconds: 200),
        builder: (context, Color? color, child) {
          return ColorFiltered(
            colorFilter: ColorFilter.mode(color!, BlendMode.srcATop),
            child: Transform.scale(
              scale: widget
                  .scale, // Escala para resaltar el botón, puedes ajustarlo o hacerlo configurable
              child: Image.asset(
                widget.imagePath,
              ),
            ),
          );
        },
      ),
    );
  }
}
