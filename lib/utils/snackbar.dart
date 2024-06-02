// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.all(20),
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: const TextStyle(fontSize: 12.8),
      ),
    ),
  );
}
