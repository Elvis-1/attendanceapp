import 'dart:convert';

import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  late final SharedPreferences _prefs;

  Future<SharedPreferencesManager> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('Initialize');
    return this;
  }

  Future<bool> saveUserId(String id) async {
    print('saving user id === $id');
    return _prefs.setString(Constant.userId, id);
  }

  Future<bool> saveUserEmail(String email) async {
    print('saving user email === $email');
    return _prefs.setString(Constant.userEmail, email);
  }

  String getUserEmail() {
    return _prefs.getString(Constant.userEmail) ?? '';
  }

  String getUserId() {
    return _prefs.getString(Constant.userId) ?? '';
  }

  Future<bool> saveUserDetails(UserModel userModel) async {
    String user = jsonEncode(userModel.toJson());
    return _prefs.setString(Constant.userDetails, user);
  }

  UserModel? getUserDetails() {
    String? userJson = _prefs.getString(Constant.userDetails);

    if (userJson != null) {
      final userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
}
