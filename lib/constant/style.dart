import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    color: Colors.white,
  );

  static var elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.purple[600],
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
  );

  static const TextStyle linkTextStyle = TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.blue,
  );
}
