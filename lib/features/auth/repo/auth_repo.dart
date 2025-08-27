import 'package:dio/dio.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepo {
  final ApiService _apiService = ApiService();
  UserModel? _userModel;

  Future<Response> requestOtp(String phoneNumber) async {
    final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"] ??
        (throw Exception("PROD_ENDPOINT_AUTH is not set in .env"));

    final response = await _apiService.post(
      "$endpoint/promoter/send-otp",
      data: {"phone_number": phoneNumber},
      requiresAuth: false,
    );

    if (response.data['success'] == true) {
      _userModel = UserModel(
        token: "",
        user: User(
          id: 0,
          email: "",
          userType: 0,
          isVerified: 0,
          phoneNumber: int.tryParse(phoneNumber) ?? 0,
        ),
      );
    }

    return response;
  }

  Future<Response> verifyOtp(String phoneNumber, String otp) async {
    final endpoint = dotenv.env["PROD_ENDPOINT_AUTH"] ??
        (throw Exception("PROD_ENDPOINT_AUTH is not set in .env"));

    final response = await _apiService.post(
      "$endpoint/promoter/verify-otp",
      data: {"phone_number": phoneNumber, "otp": otp},
      requiresAuth: false,
    );

    if (response.data['success'] == true) {
      final responseData = response.data["data"] ?? {};
      _userModel = UserModel(
        token: responseData["token"] ?? "",
        user: User(
          id: responseData["user"]?["id"] ?? 0,
          email: responseData["user"]?["email"] ?? "",
          userType: responseData["user"]?["user_type"] ?? 0,
          isVerified: responseData["user"]?["is_verified"] ?? 0,
          phoneNumber: responseData["user"]?["phone_number"] ?? 0,
        ),
      );
      await SharedPreferencesHelper.saveUserData(response.data);
      await SharedPreferencesHelper.saveToken(responseData["token"] ?? "");
      print('[Login] Token saved: ${responseData["token"]}');
    }

    return response;
  }

  UserModel? get userModel => _userModel;
}
