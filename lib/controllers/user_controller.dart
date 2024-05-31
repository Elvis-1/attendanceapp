import 'package:attendanceapp/data/api/services/user_services.dart';
import 'package:attendanceapp/data/global_service.dart';
import 'package:attendanceapp/model/user_model.dart';
import 'package:attendanceapp/utils/snack_bar.dart';
import 'package:get/get.dart';

class UserController extends GetxController implements GetxService {
  UserServices userServices;
  String userId = GlobalService.sharedPreferencesManager.getUserId();
  UserController({required this.userServices});
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> saveUserDetails(Map<String, dynamic> body) async {
    _isLoading = true;
    update();
    UserModel userModel = UserModel(
      userName: body['userName'],
      id: userId,
      firstName: body['firstName'],
      lastName: body['lastName'],
      birthDate: body['birthDate'],
      address: body['address'],
      profilePicLink: body['profilePicLink'],
      canEdit: true,
      lat: body['lat'],
      long: body['long'],
    );
    final response = await userServices.saveUserDetails(userId, body);
    _isLoading = false;
    update();
    if (response == 'true') {
      await GlobalService.sharedPreferencesManager.saveUserDetails(userModel);
      showSuccessSnackBar("Details saved successfully");
    } else {
      showErrorSnackBar(response);
    }
  }
}
