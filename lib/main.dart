import 'package:attendanceapp/controllers/auth_controller.dart';
import 'package:attendanceapp/controllers/check_controller.dart';
import 'package:attendanceapp/controllers/user_controller.dart';
import 'package:attendanceapp/data/global_service.dart';
import 'package:attendanceapp/init.dart';
import 'package:attendanceapp/screens/auth_screens/sign_up.dart';
import 'package:attendanceapp/screens/home_screen.dart';
import 'package:attendanceapp/screens/auth_screens/login_screen.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  await GlobalService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (_) {
        return GetBuilder<CheckController>(
          builder: (_) {
            return GetBuilder<UserController>(
              builder: (_) {
                return GetMaterialApp(
                  title: 'Flutter Demo',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  //  home: const AuthCheck(),
                  localizationsDelegates: const [
                    MonthYearPickerLocalizations.delegate,
                  ],
                  routes: {
                    "/": (context) => const AuthCheck(),
                    "/signup": (context) => const SignUpScreen(),
                    "/login": (context) => const LoginScreen(),
                    "/home": (context) => const HomeScreen()
                  },
                );
              },
            );
          },
        );
      },
    );

    //23, 7th video
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    // sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (GlobalService.sharedPreferencesManager.getUserId() != '') {
        setState(() {
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const HomeScreen() : const LoginScreen();
  }
}
