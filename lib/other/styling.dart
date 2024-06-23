import 'package:flutter/material.dart';

class Styling {
  double borderRadius = 10;
  InputDecoration getTFFInputDecoration({
    required String label,
    Icon? prefixIcon,
    TextEditingController? textEditingController,
  }) {
    return InputDecoration(
      filled: true,
      labelText: label,
      prefixIcon: prefixIcon,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  ButtonStyle getElevatedIconButtonStyle() {
    return const ButtonStyle();
  }
}
