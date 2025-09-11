import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/features/auth/models/user_model.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StartupService tests', () {
    late StartupService startupService;

    setUp(() async {
      // Reset SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      startupService = StartupService();
    });

    test('First launch should go to onboarding', () async {
      final route = await startupService.decideNextRoute();
      expect(route, 'onboarding');
    });

    test('After OTP verification, app should go to home on next launch', () async {
      // Fake a user model (like what you save after OTP verify)
      final fakeUser = UserModel(
        token: 'fakeToken123',
        user: User(
          id: 1,
          email: 'test@example.com',
          userType: 1,
          isVerified: 1,
          phoneNumber: '0700000000',
          firstName: 'Test',
          lastName: 'User',
          username: 'testuser',
        ),
      );

      // Save the fake user + mark first launch done
      await SharedPreferencesHelper.saveUserModel(fakeUser);
      await SharedPreferencesHelper.setFirstLaunchDone();

      // Now it should skip onboarding and go home
      final route = await startupService.decideNextRoute();
      expect(route, 'home');
    });
  });
}