import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

class MyButtonIcon extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final Icon? icon;
  final Icon? icon2;

  const MyButtonIcon(
      {super.key,
      required this.onTap,
      required this.text,
      this.buttonColor = secondaryColor,
      this.textColor = primaryColor,
      this.icon,
      this.icon2});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 15),
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (icon2 != null) ...[
                const SizedBox(width: 15),
                icon2!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
