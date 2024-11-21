import 'package:flutter/material.dart';
import 'package:smart_guru/config/theme/colors.dart';

class PinCodeTile extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final Function(String) onCompleted;

  const PinCodeTile({
    Key? key,
    required this.controller,
    required this.length,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<PinCodeTile> createState() => _PinCodeTileState();
}

class _PinCodeTileState extends State<PinCodeTile> {
  String _pin = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _pin = widget.controller.text
            .substring(widget.controller.text.length - widget.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50.0,
      height: 50.0,
      child: TextField(
        controller: TextEditingController(text: _pin),
        keyboardType: TextInputType.number,
        maxLength: widget.length,
        obscureText:
            false, // Optionally hide entered digits (replace with desired visual feedback)
        decoration: InputDecoration(
          counterText: "", // Hide counter text
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == widget.length) {
            widget.onCompleted(value);
            FocusScope.of(context).nextFocus(); // Request focus on next field
          }
        },
      ),
    );
  }
}
