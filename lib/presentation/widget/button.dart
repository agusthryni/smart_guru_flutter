import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? buttonColor;
  final Color? textColor;

  const MyButton(
      {super.key,
      required this.onTap,
      required this.text,
      this.buttonColor = secondaryColor,
      this.textColor = primaryColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
