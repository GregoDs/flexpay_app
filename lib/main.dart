import 'package:flexpay/features/auth/ui/splash_screen.dart';
import 'package:flutter/services.dart';
import 'exports.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");

  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flexpay App',
          debugShowCheckedModeBanner: false,

          // ✅ Themes
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

          // ✅ Status bar & nav bar adapt to theme
          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;

            final overlayStyle = isDark
                ? SystemUiOverlayStyle.light.copyWith(
                    statusBarColor: Colors.transparent, // transparent looks modern
                    statusBarIconBrightness: Brightness.light,
                    systemNavigationBarColor: Colors.black,
                    systemNavigationBarIconBrightness: Brightness.light,
                  )
                : SystemUiOverlayStyle.dark.copyWith(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: Colors.white,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  );

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: overlayStyle,
              child: child!,
            );
          },

          routes: AppRoutes.routes,
          home: const SplashScreen(),
        );
      },
    );
  }
}