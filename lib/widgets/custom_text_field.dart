import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF7A7A7A)),
      ),
    );
  }
}
