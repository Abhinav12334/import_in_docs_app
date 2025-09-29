import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: NewsListPage()));

    // Since your code doesn’t have a counter, adjust test as needed.
    // For now, just test that the app shows the app bar title.
    expect(find.text('News App'), findsOneWidget);
  });
}
