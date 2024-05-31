import 'package:attendanceapp/data/api/services/check_in_service.dart';
import 'package:attendanceapp/data/global_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CheckController extends GetxController implements GetxService {
  String _checkIn = '--/--';
  String _checkOut = '--/--';

  String get checkIn => _checkIn;
  String get checkOut => _checkOut;

  CheckInAndOutService checkInAndOutService;

  CheckController({required this.checkInAndOutService});
  String currentUserId = GlobalService.sharedPreferencesManager.getUserId();

  checkInUser() async {
    Map<String, dynamic> checkInBody = {
      'date': Timestamp.now(),
      'checkIn': DateFormat('hh:mm:ss a').format(DateTime.now()),
      'checkOut': '--/--',
      'checkInlocation': '',
      'checkOutlocation': '',
    };
    final response =
        await checkInAndOutService.checkIn(currentUserId, checkInBody);

    if (response == 'true') {
      _checkIn = DateFormat('hh:mm:ss a').format(DateTime.now());
      Get.snackbar('Success', 'Checkin successful',
          colorText: Colors.white, backgroundColor: Colors.greenAccent);
      update();
    } else {
      Get.snackbar('Error', response);
    }
  }

  checkOutUser() async {
    Map<String, dynamic> checkOutBody = {
      //  'date': Timestamp.now(),
      //  'checkIn': DateFormat('hh:mm:ss a').format(DateTime.now()),
      'checkOut': DateFormat('hh:mm:ss a').format(DateTime.now()),
      'checkInlocation': '',
      'checkOutlocation': '',
    };
    final response =
        await checkInAndOutService.checkOut(currentUserId, checkOutBody);

    if (response == 'true') {
      _checkOut = DateFormat('hh:mm:ss a').format(DateTime.now());
      Get.snackbar('Success', 'Checkout successful',
          colorText: Colors.white, backgroundColor: Colors.greenAccent);
      update();
    } else {
      Get.snackbar('Error', response);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(response)));
    }
  }

  getUserRecords() async {
    final response = await checkInAndOutService.getUserRecords(currentUserId);
    _checkIn = response['checkIn'];
    _checkOut = response['checkOut'];

    update();
  }
}
