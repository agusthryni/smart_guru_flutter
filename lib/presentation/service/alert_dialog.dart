import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmText,
  required String cancelText,
  required Function onConfirm,
  required Function onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(color: primaryColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel();
            },
            child: Text(
              cancelText,
              style: const TextStyle(color: primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: const TextStyle(color: primaryColor),
            ),
          ),
        ],
      );
    },
  );
}
