// lib/core/widgets/input_box.dart
import 'package:flutter/material.dart';

Widget buildInputBox({
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? hintText,
  Widget? suffixIcon,
  Key? key,
}) {
  return TextField(
    key: key,
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
