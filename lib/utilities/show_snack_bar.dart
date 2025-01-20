import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, {required Widget content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: content,
    ),
  );
}
