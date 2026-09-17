import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ikigai/main.dart';
import 'package:ikigai/splash_screen.dart';

void main() {
  testWidgets('App smoke test loads SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });
}
