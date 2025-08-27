import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/ui/login.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/features/onboarding/onboardingscreen.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  bool isLoggedIn = false;
  bool firstLaunch = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    );

    _initialize(); 
  }

  Future<void> _initialize() async {
    await _checkLoginStatus(); 
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    
    if (firstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnBoardingScreen()),
      );
    } else if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigationWrapper()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  Future<void> _checkLoginStatus() async {
    final localStorage = await SharedPreferences.getInstance();
    final launch = localStorage.getBool('firstLaunch');
    final token = localStorage.getString('token');

    setState(() {
      firstLaunch = launch ?? true;
      isLoggedIn = token != null && token.isNotEmpty;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
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