import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flexpay/features/goals/models/create_goal_response.dart/create_goal_response.dart';
import 'package:flexpay/features/goals/models/goals_model/show_goals_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/error_handler.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:flexpay/utils/services/api_service.dart';

class GoalsRepo {
  final ApiService _apiService = ApiService();

  /// 🟢 CREATE A NEW GOAL
  Future<CreateGoalResponse> createGoal({
    required String productName,
    required String targetAmount,
    required String startDate,
    required String endDate,
    required String frequency,
    required String frequencyContribution,
    required String deposit,
  }) async {
    final String url = "${ApiService.prodEndpointGoals}";
    final userModel = await SharedPreferencesHelper.getUserModel();
    final userId = userModel?.user.id;

    final payload = {
      "product_name": productName,
      "amount": targetAmount,
      "user_id": userId,
      "start_date": startDate,
      "end_date": endDate,
      "frequency": frequency,
      "frequency_contribution": frequencyContribution,
      "deposit": deposit,
    };

    try {
      AppLogger.apiRequest(
        method: 'POST',
        uri: Uri.parse(url),
        body: payload,
      );

      final response = await _apiService.post(
        url,
        data: jsonEncode(payload),
        requiresAuth: true,
      );

      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'POST',
        uri: Uri.parse(url),
        data: response.data,
      );

      final result = CreateGoalResponse.fromJson(response.data);

      if (result.success == true) {
        AppLogger.log(
          "✅ Goal created successfully: ${result.data?.first.booking?.data?.bookingReference}",
        );
      } else {
        AppLogger.log("⚠️ Goal creation failed — ${result.errors}");
      }

      return result;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'POST',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    } catch (e) {
      AppLogger.log("❌ Unexpected error in createGoal: $e");
      throw Exception(ErrorHandler.handleGenericError(e));
    }
  }

  // -------------------------------------------------------------------------
  // 🟢 FETCH GOALS (Paginated)
  // -------------------------------------------------------------------------
  Future<FetchGoalsResponse> fetchGoals({
    int page = 1,
  }) async {
    final userModel = await SharedPreferencesHelper.getUserModel();
    final userId = userModel?.user.id;

    if (userId == null) {
      throw Exception("User not found in local storage");
    }

    final String url = "${ApiService.prodEndpointGoals}/$userId?page=$page";

    try {
      AppLogger.apiRequest(
        method: 'GET',
        uri: Uri.parse(url),
      );

      final response = await _apiService.get(
        url,
        requiresAuth: true,
      );

      AppLogger.apiResponse(
        statusCode: response.statusCode,
        method: 'GET',
        uri: Uri.parse(url),
        data: response.data,
      );

      final result = FetchGoalsResponse.fromJson(response.data);

      if (result.success == true) {
        final currentPage = result.data?.goals?.currentPage ?? 0;
        final totalGoals = result.data?.goals?.total ?? 0;
        AppLogger.log("✅ Goals fetched successfully — Page $currentPage / Total $totalGoals");
      } else {
        AppLogger.log("⚠️ Failed to fetch goals — ${result.errors}");
      }

      return result;
    } on DioException catch (e) {
      AppLogger.apiError(
        type: 'DioException',
        method: 'GET',
        uri: Uri.parse(url),
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      throw ErrorHandler.formatDioError(e);
    } catch (e) {
      AppLogger.log("❌ Unexpected error in fetchGoals: $e");
      throw Exception(ErrorHandler.handleGenericError(e));
    }
  }
}