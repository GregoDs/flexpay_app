// main.dart
import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/repo/auth_repo.dart';
import 'package:flexpay/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpay/features/bookings/repo/bookings_repo.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'package:flexpay/features/goals/cubits/goals_cubit.dart';
import 'package:flexpay/features/goals/repo/goals_repo.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/repo/home_repo.dart';
import 'package:flexpay/features/merchants/cubits/merchant_cubit.dart';
import 'package:flexpay/features/merchants/repo/merchants_repo.dart';
import 'package:flexpay/features/payments/cubits/payments_cubit.dart';
import 'package:flexpay/features/payments/repo/payments_repo.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/repo/kapu_repo.dart';
import 'package:flexpay/features/auth/ui/splash_screen.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Global route observer
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

// ✅ Global Cubits
final authCubit = AuthCubit(AuthRepo());
final chamaCubit = ChamaCubit(ChamaRepo());
final bookingsCubit = BookingsCubit(BookingsRepository());
final merchantsCubit = MerchantsCubit(MerchantsRepository());
final homeCubit = HomeCubit(HomeRepo(ApiService()));
final paymentsCubit = PaymentsCubit(PaymentsRepo(ApiService()));
final goalsCubit = GoalsCubit(GoalsRepo());
final kapuCubit = KapuCubit(KapuRepo(ApiService()));

/// ✅ Pretty Bloc Observer with Color-coded Logs
class AppBlocObserver extends BlocObserver {
  String _cyan(String text) => '\x1B[36m$text\x1B[0m';
  String _green(String text) => '\x1B[32m$text\x1B[0m';
  String _yellow(String text) => '\x1B[33m$text\x1B[0m';
  String _red(String text) => '\x1B[31m$text\x1B[0m';
  String _bold(String text) => '\x1B[1m$text\x1B[0m';

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (!kReleaseMode) {
      debugPrint('''
${_cyan('🌀 BLOC CHANGE:')} ${_bold(bloc.runtimeType.toString())}
${_yellow('↳ From:')} ${change.currentState}
${_green('↳ To:')} ${change.nextState}
──────────────────────────────────────────────
''');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (!kReleaseMode) {
      debugPrint('''
${_cyan('🔁 BLOC TRANSITION:')} ${_bold(bloc.runtimeType.toString())}
${_yellow('↳ Event:')} ${transition.event}
${_yellow('↳ From:')} ${transition.currentState}
${_green('↳ To:')} ${transition.nextState}
──────────────────────────────────────────────
''');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('''
${_red('❌ BLOC ERROR:')} ${_bold(bloc.runtimeType.toString())}
${_yellow('↳ Error:')} $error
${_yellow('↳ Stacktrace:')} ${stackTrace.toString().split('\n').first}
──────────────────────────────────────────────
''');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");

  // ✅ Attach the Pretty BlocObserver
  Bloc.observer = AppBlocObserver();

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
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authCubit),
            BlocProvider.value(value: homeCubit),
            BlocProvider.value(value: chamaCubit),
            BlocProvider.value(value: paymentsCubit),
            BlocProvider.value(value: merchantsCubit),
            BlocProvider.value(value: goalsCubit),
            BlocProvider.value(value: kapuCubit),
            BlocProvider.value(value: bookingsCubit),
          ],
          child: MaterialApp(
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

            // ✅ System UI styling (status bar + nav bar)
            builder: (context, child) {
              final isDark = Theme.of(context).brightness == Brightness.dark;

              final overlayStyle = isDark
                  ? SystemUiOverlayStyle.light.copyWith(
                      statusBarColor: Colors.transparent,
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

            navigatorObservers: [routeObserver],
            routes: AppRoutes.routes,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}