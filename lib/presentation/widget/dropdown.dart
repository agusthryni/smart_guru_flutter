import 'package:flutter/material.dart';
import '../../config/theme/colors.dart';

class MyDropdown extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final String? initialValue;
  final void Function(String) onChanged;

  const MyDropdown({
    super.key,
    required this.items,
    required this.hintText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<MyDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: secondaryColor,
          filled: true,
        ),
        hint: Text(widget.hintText, style: TextStyle(color: Colors.grey[500])),
        dropdownColor: Colors.white,
        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
            widget.onChanged(newValue!);
          });
        },
      ),
    );
  }
}
