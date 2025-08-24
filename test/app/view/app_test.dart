// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_coffee/app/app.dart';
import 'package:very_good_coffee/explore_coffee/view/explore_coffee_page.dart';

void main() {
  group('App', () {
    testWidgets('renders ExploreCoffeePage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(ExploreCoffeePage), findsOneWidget);
    });
  });
}
