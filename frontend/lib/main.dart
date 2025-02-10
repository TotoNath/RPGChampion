import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constant/color.dart';
import 'package:frontend/constant/text_styles.dart';
import 'package:frontend/screen/splashscreen/splashscreen.dart';
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
          surface: AppColors.background,
          primary: AppColors.info,
        ).copyWith(background: AppColors.background),
      ),
      home: SplashScreen(),
    );
  }
}
