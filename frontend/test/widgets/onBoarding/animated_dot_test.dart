import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/onBoarding/animated_dots.dart';

void main() {
  testWidgets('Affichage du AnimatedDot inactif', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedDot(isActive: false),
        ),
      ),
    );

    final animatedDot = find.byType(AnimatedContainer);
    expect(animatedDot, findsOneWidget);
  });

  testWidgets('Affichage du AnimatedDot actif', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedDot(isActive: true),
        ),
      ),
    );

    final animatedDot = find.byType(AnimatedContainer);
    expect(animatedDot, findsOneWidget);
  });

  testWidgets('Animation du AnimatedDot', (WidgetTester tester) async {
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          bool isActive = false;
          return MaterialApp(
            home: Scaffold(
              body: GestureDetector(
                onTap: () {
                  setState(() {
                    isActive = !isActive;
                  });
                },
                child: AnimatedDot(isActive: isActive),
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(AnimatedContainer), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();
  });
}
