import 'package:first_application/app/app_prefs.dart';
import 'package:first_application/app/di.dart';
import 'package:first_application/presentation/login/old_screens/login_view.dart';
import 'package:first_application/presentation/onboarding/onboarding.dart';

import 'package:first_application/presentation/resources/color_manager.dart';
import 'package:first_application/presentation/splash/splash.dart';
import 'package:first_application/presentation/state_renderer/state_renderer.dart';
import 'package:flutter/material.dart';
import 'package:first_application/app/di.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  await initLoginModule();
  await initRegisterModule();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppPreferences _appPrefs = instance<AppPreferences>();

    late bool deger;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: ColorManager.primary),
          primaryColor: ColorManager.primary,
        ),
        home: Scaffold(body: const SplashView()));
  }
}
