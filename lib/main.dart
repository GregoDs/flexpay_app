import 'package:flexpay/features/auth/ui/splash_screen.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'exports.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");

//  runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => const OverlaySupport.global(child: MyApp()),
//     ),
//   );

  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 915),
      minTextAdapt: true,
      builder: (context, child) {
        // Use a Builder to get the current theme context
        return Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: isDark
                  ? SystemUiOverlayStyle.light.copyWith(
                      statusBarColor: Colors.black,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.dark,
                    )
                  : SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                    ),
              child: MaterialApp(
                title: 'Flexpay App',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: ColorName.primaryColor,
                  scaffoldBackgroundColor: ColorName.whiteColor,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: ColorName.primaryColor,
                  scaffoldBackgroundColor: Colors.black,
                ),
                themeMode: ThemeMode.system,
                routes: AppRoutes.routes,
                home: const SplashScreen(),
              ),
            );
          },
        );
      },
    );
  }
}
