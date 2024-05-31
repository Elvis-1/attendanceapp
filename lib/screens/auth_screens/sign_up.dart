import 'package:attendanceapp/controllers/auth_controller.dart';
import 'package:attendanceapp/model/signup_body.dart';
import 'package:attendanceapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                'Signup',
                style: TextStyle(fontSize: screenWidth / 15),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  fieldTitle("Email"),
                  customField(
                      "Enter your employee email", idTextController, false),
                  fieldTitle("Password"),
                  customField(
                      "Enter your password", passwordTextController, true),
                  GetBuilder<AuthController>(
                    builder: (authController) {
                      return authController.isLoading
                          ? const Center(child: CircularProgressIndicator())
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
                                              Text("Employee email is empty")));
                                } else if (password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Password is empty")));
                                } else {
                                  try {
                                    AuthBody signUpBody =
                                        AuthBody(email, password);
                                    final response = await authController
                                        .registration(signUpBody);
                                    if (response.status == true) {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, '/login', (route) => false);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(response.message)));
                                    }
                                    // if (password == snap.docs[0]['password']) {
                                    //   print('continue');

                                    //   sharedPreference =
                                    //       await SharedPreferences.getInstance();

                                    //   sharedPreference.setString('id', id).then((value) =>
                                    //       Navigator.pushReplacement(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (context) =>
                                    //                   const HomeScreen())));
                                    // } else {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content: Text("Password is not correct")));
                                    // }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }

                                  // print(snap.docs[0]['id']);
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
                                    'Signup',
                                    style: TextStyle(
                                        fontSize: screenWidth / 26,
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
                      Text("Already have an account"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: const Text(
                            "Login",
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
