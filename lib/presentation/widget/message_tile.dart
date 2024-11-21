import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final int index;
  final Function(int) onDelete;

  const MessageTile({
    super.key,
    required this.message,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete(index);
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: primaryColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            message,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
