import 'package:flutter/material.dart';

class Styling {
  static InputDecoration getTFFInputDecoration() {
    double border = 10;
    return InputDecoration(
      labelText: 'Mobile No.',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(border),
      ),
    );
  }

  static ButtonStyle getElevatedIconButtonStyle() {
    return ButtonStyle();
  }
}
