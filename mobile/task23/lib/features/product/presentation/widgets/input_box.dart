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
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'Poppins',
    ),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey[500],
        fontFamily: 'Poppins',
      ),
      suffixIcon: suffixIcon != null ? IconTheme(
        data: const IconThemeData(color: Colors.grey),
        child: suffixIcon!,
      ) : null,
      filled: true,
      fillColor: const Color(0xFF1F1F1F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF333333)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF00C853), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
