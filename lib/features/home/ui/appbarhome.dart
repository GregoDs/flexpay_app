import 'dart:async';

import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/features/home/ui/notifications_page.dart';
import 'package:flexpay/features/home/ui/shimmers_home.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/payments/ui/voucher_sheet.dart';
import 'package:flexpay/features/profile/ui/system_menu.dart';
import 'package:flexpay/features/payments/ui/topup_home_page.dart';
import 'package:flexpay/features/payments/ui/withdraw_home.dart';
import 'package:flexpay/features/kapu/ui/promo_cards.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/getters/getters.dart' as AppUtils;
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/kapu/ui/kapu_opt_in.dart';

import '../../../utils/services/logger.dart';

class AppBarHome extends StatefulWidget {
  final String userName;
  final UserModel userModel;
  final bool isDataReady;
  final VoidCallback? onWalletBalanceMissing; // Add the new parameter

  const AppBarHome(
    BuildContext context, {
    super.key,
    required this.userName,
    required this.userModel,
    required this.isDataReady,
    this.onWalletBalanceMissing, // Initialize the new parameter
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  bool isBalanceVisible = true;
  bool isKapuButtonPressed = false;
  bool isDataReady = false;
  Timer? _balanceRefreshTimer; // Timer to manage periodic refresh
  DateTime? _lastUpdated; // Track the last updated timestamp
  double? cachedBalance; // Cached balance to avoid blank data

  @override
  void initState() {
    super.initState();
    _fetchInitialData(); // Fetch data when the widget is initialized
    _startBalanceRefreshTimer(); // Start the periodic refresh timer
  }

  @override
  void dispose() {
    _balanceRefreshTimer
        ?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startBalanceRefreshTimer() {
    _balanceRefreshTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      final now = DateTime.now();
      if (_lastUpdated == null ||
          now.difference(_lastUpdated!) > const Duration(minutes: 2)) {
        setState(() {
          isDataReady = false; // Show shimmer while refreshing
        });
        _fetchInitialData();
      }
    });
  }

  void _fetchInitialData() async {
    await context.read<HomeCubit>().fetchUserWallet();
    await _ensureMinimumShimmerDuration(); // Ensure shimmer lasts for the full duration
    setState(() {
      isDataReady = true;
      _lastUpdated = DateTime.now(); // Update the last updated timestamp

      // Update cached balance
      final state = context.read<HomeCubit>().state;
      if (state is HomeWalletFetched) {
        final wallet = state.walletResponse.data?.walletAccount?.walletBalance;
        cachedBalance = wallet?.balance.toDouble();
      }
    });
  }

  Future<void> _ensureMinimumShimmerDuration() async {
    await Future.delayed(const Duration(seconds: 0));
  }

  void _manualRefresh() {
    setState(() {
      isDataReady = false; // Show shimmer while refreshing
    });
    _fetchInitialData();
  }

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  // Updated to use the external isDataReady parameter
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        _manualRefresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 48.h),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/appbarbackground.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.r),
              bottomRight: Radius.circular(40.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              /// Centered Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon/logos/logo.png',
                    height: 30.h,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),

              /// Profile + Greeting + Notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userModel: widget.userModel),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 24.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        AppUtils.greetingMessage(widget.userName),
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: screenWidth * 0.07,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SizedBox(height: 22.h),

              /// Balance Label with Info Icon
              Row(
                children: [
                  Text(
                    'Total balance',
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(width: 4.w), // Add spacing between text and icon
                  GestureDetector(
                    onTap: () {
                      _manualRefresh();
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.blue,
                                  size: 48.sp,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'Balance Information',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Feels like the balance is outdated...lets refresh it.',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    'OK',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.info_outline,
                      color:
                          Colors.yellow, // Make the icon yellow for visibility
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),

              /// Balance Value + Visibility Toggle
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (!widget.isDataReady) {
                    // Show shimmer until data is ready
                    return const AppBarBalanceShimmer();
                  }

                  double? balance = cachedBalance; // Use cached balance
                  if (state is HomeWalletFetched) {
                    final wallet =
                        state.walletResponse.data?.walletAccount?.walletBalance;
                    balance = wallet?.balance.toDouble();
                  }

                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              balance != null
                                  ? (isBalanceVisible
                                        ? 'Ksh ${balance.toStringAsFixed(2)}'
                                        : '••••••')
                                  : 'Ksh ${cachedBalance?.toStringAsFixed(2) ?? '••••••'}', // Fallback to cached balance
                              style: GoogleFonts.montserrat(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: toggleBalanceVisibility,
                            child: Icon(
                              isBalanceVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 20.h),

              /// Action Buttons (Shop, Top up, Withdraw, Kapu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _buildActionButton(
                  //   Icons.shopping_cart,
                  //   "Shop",
                  //   onTap: () {
                  //     final navWrapper = context.findAncestorStateOfType<NavigationWrapperState>();
                  //     if (navWrapper != null) {
                  //       navWrapper.setTabIndex(4); // 👈 jump to the Merchant tab
                  //     } else {
                  //       // fallback if somehow opened outside NavigationWrapper
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => NavigationWrapper(
                  //             initialIndex: 4,
                  //             userModel: widget.userModel,
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
                  _buildActionButton(
                    Icons.discount_rounded,
                    "Vouchers",
                    onTap: () async {
                      showMerchantVoucherModal(
                        context,
                        "FlexPay",
                        0, // Default merchant ID for the Vouchers button
                      );
                    },
                  ),
                  _buildActionButton(
                    Icons.arrow_downward,
                    "Top up",
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => TopUpHomePage()),
                      );
                      if (result == true) {
                        context.read<HomeCubit>().fetchUserWallet();
                      }
                    },
                  ),
                  _buildActionButton(
                    Icons.account_balance_wallet,
                    "Withdraw",
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(builder: (_) => WithdrawPage()),
                      );
                      if (result == true) {
                        context.read<HomeCubit>().fetchUserWallet();
                      }
                    },
                  ),

                  _buildActionButton(
                    Icons.card_giftcard,
                    "Kapu",
                    onTap: () async {
                      if (isKapuButtonPressed)
                        return; // Prevent multiple presses
                      setState(() {
                        isKapuButtonPressed = true;
                      });

                      final userId = widget.userModel.user.id.toString();

                      final hasVisited =
                          await SharedPreferencesHelper.hasVisitedKapu(userId);
                      final hasUsed = await SharedPreferencesHelper.hasUsedKapu(
                        userId,
                      );
                      final hasInteracted =
                          await SharedPreferencesHelper.hasInteractedWithKapu(
                            userId,
                          );

                      AppLogger.log(
                        '🔍 [KAPU NAV CHECK] userId=$userId | visited=$hasVisited | used=$hasUsed | interacted=$hasInteracted',
                      );

                      try {
                        await context
                            .read<KapuCubit>()
                            .fetchAllKapuWalletsInstantly();
                        final state = context.read<KapuCubit>().state;

                        if (state is KapuAllWalletsInstantlyFetched &&
                            state.walletsResponse.success &&
                            state.walletsResponse.data.isNotEmpty) {
                          AppLogger.log(
                            '🟢 [KAPU NAV] Wallet data exists → navigating directly to PromoCardsSwiperPage',
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PromoCardsSwiperPage(
                                userModel: widget.userModel,
                              ),
                            ),
                            (route) => route.isFirst,
                          );
                        } else {
                          AppLogger.log(
                            '🟡 [KAPU NAV] Navigating to OnBoardKapu (user has not interacted yet)',
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnBoardKapu(
                                userModel: widget.userModel,
                                onOptIn: () async {
                                  await SharedPreferencesHelper.markKapuVisited(
                                    userId,
                                  );
                                  AppLogger.log(
                                    '✅ [KAPU NAV] User opted in → marking visited and navigating to PromoCardsSwiperPage',
                                  );
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PromoCardsSwiperPage(
                                            userModel: widget.userModel,
                                          ),
                                    ),
                                    (route) => route.isFirst,
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        AppLogger.log(
                          '❌ [KAPU NAV] Error during navigation: $e',
                        );
                      } finally {
                        setState(() {
                          isKapuButtonPressed = false; // Reset the flag
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Action Button Builder
  Widget _buildActionButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 24.r,
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}