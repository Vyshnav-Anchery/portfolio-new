import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/main.dart';

void main() {
  testWidgets('Portfolio smoke test - renders desktop web layout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VyshnavPortfolioApp());
    await tester.pump();

    // Verify key portfolio elements exist
    expect(find.text('Vyshnav A'), findsWidgets);
    expect(find.text('Flutter Developer'), findsWidgets);
  });

  testWidgets('Portfolio smoke test - renders mobile layout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VyshnavPortfolioApp());
    await tester.pump();

    // Verify key portfolio elements exist
    expect(find.text('Vyshnav A'), findsWidgets);
  });
}
