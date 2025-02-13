import 'package:flutter/material.dart';

class Bcolor {
  Bcolor._();

  static const Color indicatorcolor = Color(0xFF3F2771);

  static const Color primaryColor = Color(0xFFE0E0E0);

  static final OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0), // Rounded corners
    borderSide: BorderSide(
      color: Bcolor.primaryColor, // Border color when not focused
      width: 1.0, // Border width
    ),
  );

  static var FormField = TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: Bcolor.enabledBorder,
    ),
  );

}
