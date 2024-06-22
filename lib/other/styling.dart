import 'package:flutter/material.dart';

class Styling {
  static double borderRadius = 10;
  InputDecoration getTFFInputDecoration(
      {required String label, Icon? prefixIcon}) {
    return InputDecoration(
      filled: true,
      labelText: label,
      prefixIcon: prefixIcon,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  ButtonStyle getElevatedIconButtonStyle() {
    return const ButtonStyle();
  }
}
