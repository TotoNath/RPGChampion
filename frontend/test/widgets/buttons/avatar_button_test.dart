import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/buttons/avatar_button.dart';

void main() {
  testWidgets('Affichage du bouton Avatar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AvatarButton(userId: 'testUser', guildId: 'testGuild', heroName: '', onAvatarUpdated: (){},),
        ),
      ),
    );

    // Vérifie que le FloatingActionButton est affiché
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.image), findsOneWidget);
  });

  testWidgets('Ouverture de la boîte de dialogue', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AvatarButton(userId: 'testUser', guildId: 'testGuild', heroName: '', onAvatarUpdated: (){},),
        ),
      ),
    );

    // Appuie sur le bouton pour ouvrir la boîte de dialogue
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Vérifie que la boîte de dialogue est affichée
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("Changer l'avatar"), findsOneWidget);
  });
}
