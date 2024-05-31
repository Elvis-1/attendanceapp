import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CheckInAndOutService {
  Future<String> checkIn(
      String userId, Map<String, dynamic> checkinBody) async {
    try {
      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(userId)
          .collection('Record')
          .doc(DateFormat("dd MMMM yyyy").format(DateTime.now()))
          .set(checkinBody);
      return 'true';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> checkOut(
      String userId, Map<String, dynamic> checkOutBody) async {
    try {
      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(userId)
          .collection('Record')
          .doc(DateFormat("dd MMMM yyyy").format(DateTime.now()))
          .update(checkOutBody);
      return 'true';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<DocumentSnapshot> getUserRecords(String userId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(userId)
        .collection('Record')
        .doc(DateFormat("dd MMMM yyyy").format(DateTime.now()))
        .get();

    return snapshot;
  }
}
