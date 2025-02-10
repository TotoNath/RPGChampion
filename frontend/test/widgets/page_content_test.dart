import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/database/model/hero_model.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/hero_details/hero_details.dart';
import 'package:frontend/screen/hero_details/hero_details_info.dart';
import 'package:frontend/screen/hero_details/hero_details_params.dart';
import 'package:frontend/widgets/page_content.dart';

void main() {
  group('PageContent Widget Tests', () {
    late HeroDetailsPage mockWidget;

    setUp(() {
      mockWidget = HeroDetailsPage(
        hero: HeroModel(
            name: "toto",
            hp: 100,
            strength: 100,
            ability: 10,
            level: 1,
            experience: 2,
            Avatar: "none",
            gender: "F"),
        userId: 'testUser',
        guild: Guild(),
        isSelected: 'true',
      );
    });

    testWidgets('Affichage de InfoPage quand activePage = info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageContent(
              activePage: 'info',
              widget: mockWidget,
              heroCount: '10',
              leaderboard: 'leaderboardData',
              heroModel: HeroModel(name: "a",hp: 1,ability: 1,strength: 1,level: 1,experience: 1,Avatar: "",gender: ""), onUpdate: () {  },

            ),
          ),
        ),
      );

      expect(find.byType(InfoPage), findsOneWidget);
    });

    testWidgets('Affichage de Params quand activePage = settings',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageContent(
              activePage: 'settings',
              widget: mockWidget,
              heroCount: '10',
              leaderboard: 'leaderboardData',
              heroModel: HeroModel(name: "a",hp: 1,ability: 1,strength: 1,level: 1,experience: 1,Avatar: "",gender: ""), onUpdate: () {  },
            ),
          ),
        ),
      );

      expect(find.byType(ParamsPage), findsOneWidget);
    });

    testWidgets(
        'Affichage du texte "Unknown Page" quand activePage est invalide',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageContent(
              activePage: 'unknown_page',
              widget: mockWidget,
              heroCount: '10',
              leaderboard: 'leaderboardData',
              heroModel: HeroModel(name: "a",hp: 1,ability: 1,strength: 1,level: 1,experience: 1,Avatar: "",gender: ""), onUpdate: () {  },
            ),
          ),
        ),
      );

      expect(find.text("Unknown Page"), findsOneWidget);
    });
  });
}
