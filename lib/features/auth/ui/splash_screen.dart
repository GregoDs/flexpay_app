import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/ui/login.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/features/auth/ui/onboarding_screen.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flutter/services.dart';

import '../../../utils/services/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.forward();

    // After animation, check where to go
    Future.delayed(const Duration(seconds: 2), () async {
      await _decideNextScreen();
    });
  }

  Future<void> _decideNextScreen() async {
    final service = StartupService();
    final user = await SharedPreferencesHelper.getUserModel();
    AppLogger.log('[SplashScreen] Loaded user from SharedPreferences: ${user?.token}');
    final route = await service.decideNextRoute();

    if (!mounted) return;

    switch (route) {
      case 'onboarding':
        Navigator.pushReplacementNamed(context, Routes.onboarding);
        break;
      case 'login':
        Navigator.pushReplacementNamed(context, Routes.login);
        break;
      case 'home':
        Navigator.pushReplacementNamed(context, Routes.home);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white, // Ensure light background
        body: Center(
          child: ScaleTransition(
            scale: animation,
            child: Image.asset(
              Assets.images.flexpay.path,
              width: 330,
              height: 250,
            ),
          ),
        ),
      ),
    );
  }
}
