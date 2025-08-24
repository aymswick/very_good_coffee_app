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

class NeutralSnackBar extends SnackBar {
  NeutralSnackBar(
    this.message, {
    required this.theme,
    this.progress = false,
    super.duration,
    super.key,
  }) : super(
         behavior: SnackBarBehavior.fixed,
         content: Row(
           children: [
             if (progress)
               Padding(
                 padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                 child: CircularProgressIndicator.adaptive(
                   backgroundColor: theme.colorScheme.onSurfaceVariant,
                 ),
               ),
             Text(
               message,
               style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
             ),
           ],
         ),
         backgroundColor: theme.colorScheme.surfaceContainerHighest,
       );
  final String message;
  final bool progress;
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
