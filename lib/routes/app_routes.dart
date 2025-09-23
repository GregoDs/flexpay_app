import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/auth/repo/auth_repo.dart';
import 'package:flexpay/features/auth/ui/login.dart';
import 'package:flexpay/features/auth/ui/otp_verification.dart';
import 'package:flexpay/features/auth/ui/register.dart';
import 'package:flexpay/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpay/features/bookings/repo/bookings_repo.dart';
import 'package:flexpay/features/bookings/ui/bookings.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/repo/chama_repo.dart';
import 'package:flexpay/features/flexchama/ui/chama_reg.dart';
import 'package:flexpay/features/flexchama/ui/viewchama.dart';
import 'package:flexpay/features/goals/ui/goals.dart';
import 'package:flexpay/features/auth/ui/onboarding_screen.dart';
import 'package:flexpay/features/auth/ui/splash_screen.dart';
import 'package:flexpay/features/merchants/cubits/merchant_cubit.dart';
import 'package:flexpay/features/merchants/repo/merchants_repo.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';

// Create global Cubit instances
final authCubit = AuthCubit(AuthRepo());
final chamaCubit = ChamaCubit(ChamaRepo());
final bookingsCubit = BookingsCubit(BookingsRepository());
final merchantsCubit = MerchantsCubit(MerchantsRepository());

class AppRoutes {
  static final routes = {
    Routes.splash: (context) => const SplashScreen(),

    Routes.onboarding: (context) => const OnBoardingScreen(),

    Routes.register: (context) =>
        BlocProvider.value(value: authCubit, child: const CreateAccountPage()),

    Routes.login: (context) =>
        BlocProvider.value(value: authCubit, child: const LoginScreen()),

    Routes.otp: (context) =>
        BlocProvider.value(value: authCubit, child: const OtpScreen()),

    // Routes.home: (context) => HomeScreen(
    //       isDarkModeOn: Theme.of(context).brightness == Brightness.dark,
    //     ),
    Routes.home: (context) {
  final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
  return BlocProvider.value(
    value: chamaCubit, // using your global instance
    child: NavigationWrapper(initialIndex: 0, userModel: userModel),
  );
},

    Routes.goals: (context) => GoalsPage(),

    Routes.registerChama: (context) => 
    BlocProvider.value(
      value: chamaCubit,
      child: ChamaRegistrationPage(),
    ),
    

    Routes.viewChamas: (context) =>
        BlocProvider.value(value: chamaCubit, child: const ViewChamas()),

    Routes.bookings: (context) =>
        BlocProvider.value(value: bookingsCubit, child: const BookingsPage()),

    Routes.merchants: (context) =>
        BlocProvider.value(value: merchantsCubit, child: MerchantsScreen()),
  };
}

class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const register = '/register';
  static const login = '/login';
  static const otp = '/otp';
  static const main = '/main';
  static const home = '/home';
  static const registerChama = '/registerChama';
  static const viewChamas = 'viewChamas';
  static const goals = 'goals';
  static const bookings = '/bookings';
  static const merchants = '/merchants';
  static const bookingDetails = '/booking-details';
}
