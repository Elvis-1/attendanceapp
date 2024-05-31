import 'package:attendanceapp/data/local_storage/shared_pref.dart';
import 'package:attendanceapp/firebase_options.dart';
import 'package:attendanceapp/init.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GlobalService {
  // all services should be initialized here
  static late SharedPreferencesManager sharedPreferencesManager;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await initController();

    sharedPreferencesManager = await SharedPreferencesManager().init();
  }
}
