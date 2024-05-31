import 'package:attendanceapp/controllers/auth_controller.dart';
import 'package:attendanceapp/controllers/check_controller.dart';
import 'package:attendanceapp/controllers/user_controller.dart';
import 'package:attendanceapp/data/api/services/auth_services.dart';
import 'package:attendanceapp/data/api/services/check_in_service.dart';
import 'package:attendanceapp/data/api/services/user_services.dart';
import 'package:get/get.dart';

Future<void> initController() async {
  // services
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => CheckInAndOutService());
  Get.lazyPut(() => UserServices());

  // controllers
  Get.lazyPut(() => AuthController(authService: Get.find()));
  Get.lazyPut(() => CheckController(checkInAndOutService: Get.find()));
  Get.lazyPut(() => UserController(userServices: Get.find()));
}
