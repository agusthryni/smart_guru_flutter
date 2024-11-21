import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? subtitle2;
  final Widget? leading;
  final Widget? trailing;
  final bool dense;
  final VoidCallback? onTap;
  final Color? tileColor;
  final BorderRadius? shape;

  const MyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitle2,
    this.leading,
    this.trailing,
    this.dense = false,
    this.onTap,
    this.tileColor,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tileColor ?? Colors.transparent,
          borderRadius: shape ?? BorderRadius.zero,
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: subtitle != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    if (subtitle2 != null)
                      Text(
                        subtitle2!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                  ],
                )
              : null,
          leading: leading != null
              ? leading is Icon
                  ? Icon(
                      (leading as Icon).icon,
                      color: primaryColor,
                    )
                  : Text(
                      (leading as Text).data!,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    )
              : null,
          trailing: trailing != null
              ? Icon(
                  (trailing as Icon).icon,
                  color: primaryColor,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          dense: dense,
          onTap: onTap,
          enabled: onTap != null,
        ),
      ),
    );
  }
}
