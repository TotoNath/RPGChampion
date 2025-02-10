import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/onBoarding/onboarding_content.dart';

void main() {
  testWidgets('Affichage du OnboardingContent avec index supérieur à 0',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OnboardingContent(
            illustration: 'assets/logo.png',
            text: 'Test description',
            title: 'Test title',
            index: 1,
          ),
        ),
      ),
    );

    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Test title'), findsOneWidget);
    expect(find.text('Test description'), findsOneWidget);
  });

  testWidgets('Vérifie que l\'image est affichée correctement',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OnboardingContent(
            illustration: 'assets/logo.png',
            text: 'Test description',
            title: 'Test title',
            index: 1,
          ),
        ),
      ),
    );

    final image = find.byType(Image);
    expect(image, findsOneWidget);

    final imageWidget = tester.widget<Image>(image);
    expect(imageWidget.image, isA<AssetImage>());
    expect((imageWidget.image as AssetImage).assetName, 'assets/logo.png');
  });

  testWidgets('Vérifie l\'alignement et le style du texte',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: OnboardingContent(
            illustration: 'assets/logo.png',
            text: 'Test description',
            title: 'Test title',
            index: 1,
          ),
        ),
      ),
    );

    final textTitle = find.text('Test title');
    final textDescription = find.text('Test description');

    expect(textTitle, findsOneWidget);
    expect(textDescription, findsOneWidget);

    final textWidget = tester.widget<Text>(textDescription);
    expect(textWidget.textAlign, TextAlign.center);
  });
}
