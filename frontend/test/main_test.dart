import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screen/splashscreen/splashscreen.dart';
import 'package:mockito/mockito.dart';

class MockDatabase extends Mock implements Database {}
class MockOnboardingUtils extends Mock {
  Future<bool> hasSeenOnboarding() async => false;
}

void main() {
  testWidgets('MyApp affiche la SplashScreen au démarrage', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
