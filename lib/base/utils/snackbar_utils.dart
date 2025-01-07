import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showSnackBar(context, content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: content,
    ));
  }
}
