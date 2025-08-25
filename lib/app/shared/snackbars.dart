import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar(
    this.message, {
    required this.theme,
    super.duration,
    super.key,
  }) : super(
         behavior: SnackBarBehavior.floating,
         content: Text(
           message,
           style: TextStyle(color: theme.colorScheme.onError),
         ),
         backgroundColor: theme.colorScheme.error,
       );

  final String message;
  final ThemeData theme;
}

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar(
    this.message, {
    required this.theme,
    super.duration,
    super.key,
  }) : super(
         behavior: SnackBarBehavior.floating,
         content: Text(
           message,
           style: const TextStyle(color: Colors.white),
         ),
         backgroundColor: Colors.green,
       );
  final String message;
  final ThemeData theme;
}
