import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/app/app.dart';

void main() {
  group('snackbars', () {
    late ThemeData theme;

    const successText = 'successful message';
    const errorText = 'error message';

    setUpAll(() {
      theme = ThemeData.dark();
    });
    testWidgets('SuccessSnackbar ...', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SuccessSnackBar(successText, theme: theme),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100,
                    width: 100,
                  ),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text(successText), findsNothing);
      await tester.tap(find.byType(GestureDetector));
      expect(find.text(successText), findsNothing);
      await tester.pump(); // schedule animation
      expect(find.text(successText), findsOneWidget);
    });

    testWidgets('ErrorSnackbar ...', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ErrorSnackBar(errorText, theme: theme),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100,
                    width: 100,
                  ),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text(errorText), findsNothing);
      await tester.tap(find.byType(GestureDetector));
      expect(find.text(errorText), findsNothing);
      await tester.pump(); // schedule animation
      expect(find.text(errorText), findsOneWidget);
    });
  });
}
