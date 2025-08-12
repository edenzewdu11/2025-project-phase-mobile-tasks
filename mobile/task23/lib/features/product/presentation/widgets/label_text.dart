// lib/core/widgets/label_text.dart
import 'package:flutter/material.dart';

Widget buildLabelText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      fontFamily: 'Poppins',
      color: Colors.white,
    ),
  );
}
