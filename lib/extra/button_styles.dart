import 'package:flutter/material.dart';

ButtonStyle pill(Color foreground, Color background, double radius) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(background),
    foregroundColor: MaterialStateProperty.all(foreground),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
