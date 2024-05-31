import 'package:attendanceapp/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserServices {
  Future<String> saveUserDetails(
      String id, Map<String, dynamic> userModel) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(id)
          .update(userModel);
      return 'true';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }
}
