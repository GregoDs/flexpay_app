import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/ui/appbarhome.dart';
import 'package:flexpay/features/home/ui/transactions_home.dart';
import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/ui/kapu_opt_in.dart';
import 'package:flexpay/features/kapu/ui/promo_cards.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flexpay/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/features/home/models/home_transactions_model/transactions_model.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkModeOn;
  final UserModel userModel;

  const HomeScreen({
    super.key,
    required this.isDarkModeOn,
    required this.userModel,
    UserModel? user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<dynamic> outlets = [];
  bool isLoading = true;
  List<TransactionData> _transactions = [];
  bool _txLoading = false;
  String? _txError;
  bool _isNavigatingToKapu = false;
  bool _walletLoading = false;
  bool _isLoading = true;

  // Added flags to track individual fetch states
  bool _walletFetched = false;
  bool _transactionsFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final cubit = context.read<HomeCubit>();

      // Prevent overlapping API calls
      if (!_walletLoading && cubit.state is! HomeWalletFetched) {
        _walletLoading = true;
        cubit.fetchUserWallet().then((_) => _walletLoading = false);
      }

      if (!_txLoading && cubit.state is! HomeTransactionsFetched) {
        setState(() {
          _txLoading = true;
          _txError = null;
        });
        cubit.fetchLatestTransactions().then(
          (_) => setState(() => _txLoading = false),
        );
      }
    });
  }

  Future<void> _refreshData() async {
    final cubit = context.read<HomeCubit>();

    // Prevent overlapping API calls
    if (_walletLoading || _txLoading) return;

    setState(() {
      _txLoading = true;
      _txError = null;
    });

    await Future.wait([
      cubit.fetchUserWallet().then((_) => _walletLoading = false),
      cubit.fetchLatestTransactions().then(
        (_) => setState(() => _txLoading = false),
      ),
    ]);
  }

  Widget _buildMerchantImage(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/merchantspageimg/default.png');
      },
    );
  }

  // Added a delay to ensure shimmer lasts for at least 2 seconds
  Future<void> _ensureMinimumShimmerDuration() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.60,
            ),
            child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) async {
                AppLogger.log(
                  'BlocListener: Current state = $state',
                ); // Debug log

                if (state is HomeWalletFetched) {
                  final walletBalance =
                      state.walletResponse.data!.walletAccount?.walletBalance;
                  AppLogger.log(
                    'Wallet balance fetched: Total Credit = ${walletBalance?.totalCredit}, Total Debit = ${walletBalance?.totalDebit}',
                  );
                  await _ensureMinimumShimmerDuration(); // Ensure shimmer lasts for 2 seconds
                  setState(() {
                    _walletFetched = true; // Mark wallet as fetched
                    _isLoading =
                        !_walletFetched ||
                        !_transactionsFetched; // Update combined loading state
                    AppLogger.log('Updated _isLoading = $_isLoading');
                  });
                }

                if (state is HomeTransactionsFetched) {
                  await _ensureMinimumShimmerDuration(); // Ensure shimmer lasts for 2 seconds
                  setState(() {
                    _transactionsFetched = true; // Mark transactions as fetched
                    _txLoading = false; // Stop transactions loader
                    _transactions = state
                        .transactionsResponse
                        .data; // Update transactions list
                    AppLogger.log(
                      'Transactions fetched: _transactionsFetched = $_transactionsFetched',
                    );
                    _isLoading =
                        !_walletFetched ||
                        !_transactionsFetched; // Update combined loading state
                    AppLogger.log('Updated _isLoading = $_isLoading');
                  });
                }

                if (state is HomeWalletLoading ||
                    state is HomeTransactionsLoading) {
                  setState(() {
                    _isLoading = true; // Keep shimmer active while loading
                    AppLogger.log(
                      'Combined loading started: _isLoading = $_isLoading',
                    );
                  });
                }

                if (state is HomeWalletFailure ||
                    state is HomeTransactionsFailure) {
                  await _ensureMinimumShimmerDuration(); // Ensure shimmer lasts for 2 seconds
                  setState(() {
                    _isLoading = false; // Stop shimmer on failure
                    _txLoading = false; // Stop transactions loader on failure
                    AppLogger.log(
                      'Combined loading failed: _isLoading = $_isLoading',
                    );
                  });
                }
              },
              child: AppBarHome(
                context,
                userName: "${widget.userModel.user.firstName}",
                userModel: widget.userModel,
                isDataReady:
                    !_isLoading, // Use combined loading flag to control shimmer
                onWalletBalanceMissing: () {
                  // Add a fallback UI or refetch option
                  AppLogger.log(
                    'Wallet balance missing in UI. Prompting user to refetch.',
                  );
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Wallet Balance Missing'),
                      content: Text(
                        'Your wallet balance is not visible. Would you like to refetch it?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<HomeCubit>().fetchUserWallet();
                          },
                          child: Text('Refetch'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: const Color(0xFF337687),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              children: [
                // 🎅 Xmas Kapu Promo Banner
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      if (_isNavigatingToKapu) return;
                      setState(() => _isNavigatingToKapu = true);

                      try {
                        final userId = widget.userModel.user.id.toString();

                        final hasVisited =
                            await SharedPreferencesHelper.hasVisitedKapu(
                              userId,
                            );
                        final hasUsed =
                            await SharedPreferencesHelper.hasUsedKapu(userId);
                        final hasInteracted =
                            await SharedPreferencesHelper.hasInteractedWithKapu(
                              userId,
                            );

                        AppLogger.log(
                          '🔍 [KAPU NAV CHECK] userId=$userId | visited=$hasVisited | used=$hasUsed | interacted=$hasInteracted',
                        );

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
                          await Navigator.push(
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
                        AppLogger.log('❌ [KAPU NAV ERROR] $e');
                      } finally {
                        if (mounted)
                          setState(() => _isNavigatingToKapu = false);
                      }
                    },
                    child: Container(
                      height: 110.h,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: widget.isDarkModeOn
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                        boxShadow: widget.isDarkModeOn
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 5.r,
                                  spreadRadius: 5.r,
                                  offset: Offset(0, 0),
                                ),
                                BoxShadow(
                                  color: widget.isDarkModeOn
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.amber.withOpacity(0.4),
                                  blurRadius: 35.r,
                                  spreadRadius: 2.r,
                                  offset: Offset(0, 0),
                                ),
                              ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.small(
                                "Lipia PolePole",
                                fontSize: 18.sp,
                                color: widget.isDarkModeOn
                                    ? ColorName.whiteColor
                                    : ColorName.blackColor,
                              ),
                              SizedBox(height: 2.h),
                              AppText.small(
                                "Christmas Kapu 🎅",
                                fontSize: 18.sp,
                                color: widget.isDarkModeOn
                                    ? ColorName.whiteColor
                                    : ColorName.blackColor,
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 2.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.touch_app_rounded,
                                          size: 12.sp,
                                          color: widget.isDarkModeOn
                                              ? ColorName.whiteColor
                                              : ColorName.blackColor,
                                        ),
                                        SizedBox(width: 4.w),
                                        AppText.medium(
                                          "Tap to view",
                                          fontSize: 12.sp,
                                          color: widget.isDarkModeOn
                                              ? ColorName.whiteColor
                                              : ColorName.blackColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: widget.isDarkModeOn
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // ❄️ Replace image with Lottie animation
                          Positioned(
                            right: -94.w,
                            top: -34.h,
                            child: Lottie.asset(
                              'assets/images/home_images/happy_snowman.json',
                              height: 146.h,
                              fit: BoxFit.cover,
                              repeat: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
                _buildCampaignCard(context),
                SizedBox(height: 20.h),
                // VoucherModalSheet(context: context),
                // SizedBox(height: 8.h),
                // _buildMerchantImages(context),
                // SizedBox(height: 8.h),
                _buildTransactionsSection(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCampaignCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCampaignModal(context);
      },
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/appbarbackground.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.campaign, color: Colors.white, size: 28.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'Spread the word!\nRefer a friend and earn',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCampaignModal(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 18.w, 24.h),
          child: SingleChildScrollView(
            child: BlocProvider.value(
              value: homeCubit,
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state is HomeReferralSuccess) {
                    Navigator.pop(context); // close modal
                    CustomSnackBar.showSuccess(
                      context,
                      title: "Referral Sent!",
                      message: "Your friend has been referred successfully.",
                    );
                  } else if (state is HomeReferralFailure) {
                    Navigator.pop(context);
                    CustomSnackBar.showError(
                      context,
                      title: "Referral Failed",
                      message: state.message,
                    );
                  }
                },

                builder: (context, state) {
                  final isLoading = state is HomeReferralLoading;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // underline indicator
                      Center(
                        child: Container(
                          width: 50.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // icons row
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emoji_people,
                              color: Colors.orange,
                              size: 30.sp,
                            ),
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.card_giftcard,
                              color: Colors.blue,
                              size: 30.sp,
                            ),
                            SizedBox(width: 12.w),
                            Icon(Icons.star, color: Colors.amber, size: 30.sp),
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // title
                      Center(
                        child: Text(
                          'Refer & Earn',
                          style: GoogleFonts.montserrat(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D3C4E),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      Text(
                        'Share the love—get KES 100 when your friend tops up KES 500!',
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 26.h),

                      Text(
                        "Phone Number",
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // phone input
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: TextField(
                          controller: phoneController,
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter Phone number",
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.montserrat(
                              color: Colors.grey[500],
                              fontSize: 15.sp,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      SizedBox(height: 22.h),

                      // REFER button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  final phone = phoneController.text.trim();
                                  if (phone.isNotEmpty) {
                                    context.read<HomeCubit>().makeReferral(
                                      phone,
                                    );
                                  } else {
                                    CustomSnackBar.showWarning(
                                      context,
                                      title: "Missing Number",
                                      message:
                                          "Please enter a phone number to refer.",
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF337687),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SpinKitWave(color: Colors.white, size: 28.sp)
                              : Text(
                                  "Refer",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Transactions",
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.h),
        if (_txLoading) ...[
          Center(child: SpinKitWave(color: ColorName.primaryColor, size: 30)),
        ] else if (_transactions.isEmpty)
          Text(
            _txError ?? "No transactions yet",
            style: GoogleFonts.montserrat(fontSize: 14.sp),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length.clamp(0, 5),
            itemBuilder: (context, index) {
              final tx = _transactions[index];
              final isIncome = tx.paymentAmount >= 0;
              final amountText = _formatAmount(
                tx.paymentAmount,
                prefix: 'Ksh ',
              );
              return _buildTransactionTile(
                tx.date,
                tx.productName,
                amountText,
                isIncome,
                context,
              );
            },
          ),
      ],
    );
  }

  Widget _buildTransactionTile(
    String dateTime,
    String description,
    String amount,
    bool isIncome,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(_createSlideUpRoute(_transactions));
        },
        // ... existing code ...
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT SIDE: icon + text
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        isIncome ? Icons.north_east : Icons.south_west,
                        color: isIncome ? Colors.green : Colors.red,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Only the Column should be flexible
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateTime,
                            style: GoogleFonts.montserrat(
                              fontSize: 10.sp,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            description,
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // RIGHT SIDE: amount
              Text(
                amount,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double value, {String prefix = ''}) {
    final isNegative = value < 0;
    final abs = value.abs();
    final hasCents = abs.truncateToDouble() != abs;
    final text = hasCents ? abs.toStringAsFixed(2) : abs.toStringAsFixed(0);
    final signed = isNegative ? '-$prefix$text' : '+$prefix$text';
    return signed;
  }

  Route _createSlideUpRoute(List<TransactionData> transactions) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) =>
          TransactionDetailsPage(transactions: transactions),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
