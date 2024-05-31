import 'package:flutter/material.dart';
import 'package:get/get.dart';

showErrorSnackBar(String message) {
  Get.snackbar("Error", message,
      backgroundColor: Colors.redAccent, colorText: Colors.white);
}

showSuccessSnackBar(String message) {
  Get.snackbar('Success', message,
      backgroundColor: Colors.lightGreen, colorText: Colors.white);
}
