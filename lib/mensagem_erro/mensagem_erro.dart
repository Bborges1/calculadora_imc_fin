import 'package:flutter/material.dart';

showSnackBar(
    {required BuildContext context,
    required String message,
    bool isError = true}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? Colors.red : Colors.blue,
    showCloseIcon: true,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
