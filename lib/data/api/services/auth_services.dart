import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // creating a new account
  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // save to database
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('Employee').doc(uid).set({
        'email': email,
      });
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // login with email password method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      print('------------- login firebase auth exception --------------');
      print(e.message.toString());
      return e.message.toString();
    } catch (e) {
      print('------------- login catch error --------------');
      print(e.toString());
      return e.toString();
    }
  }

  // logout the user
  static Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // check whether the user is sign in or not
  static Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  Future<void> deleteUserAccount() async {
    try {
      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user's UID
        String uid = user.uid;

        // Delete user data from Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();

        // Delete the user's authentication account
        await user.delete();

        print("User account and data deleted successfully.");
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Failed to delete user account: $e");
    }
  }
}
