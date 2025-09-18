import 'dart:io';
import 'package:flexpay/exports.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

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
  final upgrader = Upgrader();

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

    Future.delayed(const Duration(seconds: 4), () async {
      await _checkForVersionUpdate(testMode: kDebugMode);
    });
  }

  Future<void> _checkForVersionUpdate({bool testMode = false}) async {
  try {
    String? playStoreVersion;
    String? installedVersion;

    if (testMode) {
      // 🔹 Hardcoded values for testing
      playStoreVersion = "2.0.0";     // pretend store version
      installedVersion = "1.0.0";     // pretend installed version
      AppLogger.log('[TEST MODE] Simulating update check...');
    } else {
      // 🔹 Production values
      await upgrader.initialize();
      playStoreVersion = upgrader.versionInfo?.appStoreVersion.toString();
      installedVersion = upgrader.versionInfo?.installedVersion.toString();
    }

    AppLogger.log('Available update version: $playStoreVersion');
    AppLogger.log('Installed app version: $installedVersion');

    if (playStoreVersion != null && installedVersion != null) {
      if (_isNewerVersion(playStoreVersion, installedVersion)) {
        final updateUrl = Platform.isAndroid
            ? 'https://play.google.com/store/apps/details?id=com.flexpay.flexpromoter'
            : 'https://apps.apple.com/app/app_store_id';
        _showUpdateDialog(updateUrl);
        return;
      }
    }
  } catch (e) {
    AppLogger.log('Version check failed: $e');
  }

  // fallback → go to next screen
  await _decideNextScreen();
}

  bool _isNewerVersion(String storeVersion, String installedVersion) {
    try {
      final store = Version.parse(storeVersion);
      final installed = Version.parse(installedVersion);
      return store > installed;
    } catch (_) {
      return storeVersion != installedVersion;
    }
  }

  Future<void> _decideNextScreen() async {
    final service = StartupService();
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
        final user = await SharedPreferencesHelper.getUserModel();
        Navigator.pushReplacementNamed(context, Routes.home, arguments: user);
        break;
    }
  }

  void _showUpdateDialog(String updateUrl) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.fromLTRB(22, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icon/flexhomelogo.png',
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Update FlexPromoter?',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Download size: 9.2 MB',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FlexPromoter recommends that you update to the latest version. Kindly update for the necessary changes to be applied.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF388E3C), // Green
                      textStyle: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    onPressed: null,
                    // onPressed: () async {
                    //   Navigator.of(context).pop();
                    //   await _decideNextScreen(); // continue normally
                    // },
                    child: const Text('NO THANKS'),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C), // Green
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        minimumSize: const Size(88, 36),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        if (await canLaunchUrl(Uri.parse(updateUrl))) {
                          await launchUrl(
                            Uri.parse(updateUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        }
                        await _decideNextScreen(); // fallback if user comes back
                      },
                      child: const Text('UPDATE'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Center(
                child: Image.asset(
                  'assets/icon/flexhomelogo.png',
                  width: 72,
                  height: 72,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
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