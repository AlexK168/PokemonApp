import 'package:flutter/material.dart';

const int snackBarDurationInMilliseconds = 921;

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: snackBarDurationInMilliseconds),
    )
  );
}