import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final bool showCloseButton;
  final Function()? onLeadingPressed;
  final Function()? onClosePressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showLeading = false,
    this.showCloseButton = false,
    this.onLeadingPressed,
    this.onClosePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: showLeading
          ? IconButton(
              onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            )
          : null,
      actions: showCloseButton
          ? [
              IconButton(
                onPressed: onClosePressed ?? () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.black),
              )
            ]
          : null,
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
