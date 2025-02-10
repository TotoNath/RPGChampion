import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/buttons/drawer_button.dart';

void main() {

  testWidgets('Vérifie l\'animation du CustomDrawerButton', (WidgetTester tester) async {
    String activePage = 'home';

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: CustomDrawerButton(
                activePage: activePage,
                context: context,
                page: 'settings',
                icon: Icons.settings,
                selectedIcon: Icons.settings_applications,
                onPressed: () {
                  setState(() {
                    activePage = 'settings';
                  });
                },
              ),
            ),
          );
        },
      ),
    );

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(activePage, 'settings');
  });
}
