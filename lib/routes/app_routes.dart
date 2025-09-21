// import 'package:flexpromoter/features/auth/ui/otpverification.dart';
// import 'package:flexpromoter/features/bookings/cubit/make_booking_cubit.dart';
// import 'package:flexpromoter/features/bookings/ui/booking_details.dart';
// import 'package:flexpromoter/features/bookings/ui/bookings.dart';
// import 'package:flexpromoter/features/bookings/ui/make_bookings.dart';
// import 'package:flexpromoter/features/commissions/cubit/commissions_cubit.dart';
// import 'package:flexpromoter/features/commissions/ui/commissions.dart';
// import 'package:flexpromoter/features/leaderboard/ui/leaderboard_screen.dart';
// import 'package:flexpromoter/features/leaderboard/cubit/leaderboard_cubit.dart';
// import 'package:flexpromoter/features/leaderboard/repo/leaderboard_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flexpromoter/features/auth/cubit/auth_cubit.dart';
// import 'package:flexpromoter/features/auth/repo/auth_repo.dart';
// import 'package:flexpromoter/features/auth/ui/login.dart';
// import 'package:flexpromoter/features/home/ui/home.dart';
// import 'package:flexpromoter/features/onboarding/splash_screen.dart';
// import 'package:flexpromoter/features/onboarding/onboarding_screen.dart';
// import 'package:flexpromoter/features/commissions/repo/commission_repo.dart';
// import 'package:flexpromoter/features/bookings/cubit/bookings_cubit.dart';
// import 'package:flexpromoter/features/bookings/repo/bookings_repo.dart';
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
import 'package:flexpay/features/flexchama/ui/viewchama.dart';
import 'package:flexpay/features/goals/ui/goals.dart';

import 'package:flexpay/features/home/ui/homescreen.dart';

import 'package:flexpay/features/auth/ui/onboarding_screen.dart';

import 'package:flexpay/features/auth/ui/splash_screen.dart';
import 'package:flexpay/features/merchants/cubits/merchant_cubit.dart';
import 'package:flexpay/features/merchants/repo/merchants_repo.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/utils/services/api_service.dart';

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
      return NavigationWrapper(initialIndex: 0, userModel: userModel);
    },

    Routes.goals: (context) => GoalsPage(),

    Routes.viewChamas: (context) => BlocProvider.value(
      value: chamaCubit,
      child: const ViewChamas(), 
    ),

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
  static const viewChamas = 'viewChamas';
  static const goals = 'goals';
  static const bookings = '/bookings';
  static const merchants = '/merchants';
  static const bookingDetails = '/booking-details';
}
