import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/text_styles.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/database/model/user_model.dart';
import 'package:frontend/screen/home/home.dart';
import 'package:frontend/screen/login/login.dart';
import 'package:frontend/screen/onboarding/onboarding_page.dart';
import 'package:frontend/utils/onboarding_utils.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RPGChampion App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.background,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          bodyLarge: AppTextStyles.primaryText,
          bodyMedium: AppTextStyles.primaryText,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: AppColors.button,
          textTheme: ButtonTextTheme.primary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.buttonText,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          error: AppColors.error,
          secondary: AppColors.success,
          surface: AppColors.warning,
          primary: AppColors.info,
        ).copyWith(background: AppColors.background),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    bool hasSeen = await hasSeenOnboarding();
    if (hasSeen) {
      final db = Database();
      await db.init();
      final userCollection = db.isar.users;
      final userCount = await userCollection.count();

      if (userCount != 0) {
        Get.off(() => const HomePage());
      } else {
        Get.off(() => const LoginPage(title: "LoginPage"));
      }
    } else {
      Get.off(() => const OnboardingPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
