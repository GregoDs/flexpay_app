import 'package:flexpay/features/auth/repo/auth_repo.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';

class StartupService {
  final AuthRepo _authRepo = AuthRepo();

  Future<String> decideNextRoute() async {
    final firstLaunch = await SharedPreferencesHelper.isFirstLaunch();

    if (firstLaunch) {
      return 'onboarding';
    }

    final token = await SharedPreferencesHelper.getToken();

    if (token == null) {
      return 'login';
    }

    final isValid = await _validateToken(token);

    if (isValid) {
      return 'home';
    } else {
      await SharedPreferencesHelper.clearToken();
      return 'login';
    }
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await _authRepo.verifyToken(token);
      if (response.data['success'] == true) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
