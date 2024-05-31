import 'package:attendanceapp/data/api/services/auth_services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../model/response_model.dart';
import '../model/signup_body.dart';

class AuthController extends GetxController implements GetxService {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthService authService;
  AuthController({required this.authService});

  Future<ResponseModel> registration(AuthBody signUpBody) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    final response = await authService.createAccountWithEmail(
        signUpBody.email, signUpBody.password);
    _isLoading = false;
    update();
    if (response == "Account Created") {
      return responseModel = ResponseModel(message: response, status: true);
    } else {
      return responseModel = ResponseModel(message: response, status: false);
    }
  }

  Future<ResponseModel> login(AuthBody signin) async {
    _isLoading = true;
    update();
    ResponseModel responseModel;
    final response =
        await authService.loginWithEmail(signin.email, signin.password);
    _isLoading = false;
    update();
    if (response == "Login Successful") {
      return responseModel = ResponseModel(message: response, status: true);
    } else {
      return responseModel = ResponseModel(message: response, status: false);
    }
  }
}
