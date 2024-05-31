import 'package:attendanceapp/controllers/auth_controller.dart';
import 'package:attendanceapp/data/global_service.dart';
import 'package:attendanceapp/model/signup_body.dart';
import 'package:attendanceapp/screens/auth_screens/sign_up.dart';
import 'package:attendanceapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  late SharedPreferences sharedPreference;
  double screenWidth = 0;
  double screenHeight = 0;
  Color primary = const Color(0xFFeef444c);
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    // bool isKeyboardVisible =
    //     KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 2.5,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(70))),
              child: Center(
                child: Icon(
                  size: screenHeight / 5,
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: screenHeight / 15, bottom: screenHeight / 15),
              child: Text(
                'Login',
                style: TextStyle(fontSize: screenWidth / 18),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle("Employee ID"),
                  customField(
                      "Enter your employee Id", idTextController, false),
                  fieldTitle("Password"),
                  customField(
                      "Enter your password", passwordTextController, true),
                  GetBuilder<AuthController>(
                    builder: (authController) {
                      return authController.isLoading
                          ? Center(child: CircleAvatar())
                          : GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                String email = idTextController.text.trim();
                                String password =
                                    passwordTextController.text.trim();
                                if (email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Employee id is empty")));
                                } else if (password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Password id is empty")));
                                } else {
                                  // QuerySnapshot snap = await FirebaseFirestore.instance
                                  //     .collection("Employee")
                                  //     .where('id', isEqualTo: id)
                                  //     .get();
                                  //  print(snap.docs[0]['id']);
                                  try {
                                    AuthBody authBody =
                                        AuthBody(email, password);
                                    final response =
                                        await authController.login(authBody);
                                    if (response.status == true) {
                                      String userId = FirebaseAuth
                                          .instance.currentUser!.uid;

                                      await GlobalService
                                          .sharedPreferencesManager
                                          .saveUserEmail(email);
                                      await GlobalService
                                          .sharedPreferencesManager
                                          .saveUserId(userId);
                                      Get.toNamed('/home');
                                      // Navigator.pushNamedAndRemoveUntil(
                                      //     context, '/home', (route) => false);
                                      return;
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(response.message)));
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }

                                  //  print(snap.docs[0]['id']);
                                }
                              },
                              child: Container(
                                height: 60,
                                margin: EdgeInsets.only(top: screenHeight / 40),
                                width: screenWidth,
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        color: Colors.white,
                                        letterSpacing: 2),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                  Row(
                    children: [
                      Text("Don\"t have an account"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/signup', (route) => false);
                          },
                          child: const Text(
                            "signup",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: screenWidth / 26),
      ),
    );
  }

  Widget customField(
      String hint, TextEditingController controller, bool obscureText) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 40),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                color: Colors.black26,
                offset: Offset(
                  2,
                  3,
                ))
          ]),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              size: screenWidth / 15,
              color: primary,
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: screenWidth / 6),
            child: TextFormField(
              controller: controller,
              enableSuggestions: false,
              autocorrect: false,
              obscureText: obscureText,
              decoration: InputDecoration(
                  hintText: hint,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: screenHeight / 35),
                  border: InputBorder.none),
              maxLines: 1,
            ),
          ))
        ],
      ),
    );
  }
}
