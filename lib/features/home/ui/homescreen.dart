import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/ui/appbarhome.dart';
import 'package:flexpay/features/home/ui/transactions_home.dart';
import 'package:flexpay/features/payments/ui/voucher_sheet.dart';
import 'package:flexpay/features/promos/ui/promo_cards.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flexpay/utils/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
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
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> outlets = [];
  bool isLoading = true;
  double _walletBalance = 0.0;
  double _refundableBalance = 0.0;
  List<TransactionData> _transactions = [];
  bool _txLoading = false;
  String? _txError;

  @override
  void initState() {
    super.initState();
    // Fetch wallet when arriving on HomeScreen regardless of navigation path
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<HomeCubit>();
        cubit.fetchUserWallet();
        setState(() {
          _txLoading = true;
          _txError = null;
        });
        cubit.fetchLatestTransactions();
        // context.read<MerchantsCubit>().fetchMerchants();
      }
    });
  }

  Future<void> _refreshData() async {
    final cubit = context.read<HomeCubit>();

    setState(() {
      _txLoading = true;
      _txError = null;
    });

    // ✅ Re-fetch wallet and transactions in parallel, wait for both
    await Future.wait([
      cubit.fetchUserWallet(),
      cubit.fetchLatestTransactions(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * 0.60,
            ),
            child: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is HomeWalletFetched) {
                  final wallet =
                      state.walletResponse.data?.walletAccount?.walletBalance;
                  final refundableWalletBalance =
                      state
                          .walletResponse
                          .data
                          ?.walletAccount
                          ?.walletRefundBalance ??
                      0;
                  if (wallet != null) {
                    setState(() {
                      _walletBalance = wallet.balance.toDouble();
                      _refundableBalance = refundableWalletBalance.toDouble();
                    });
                  }
                } else if (state is HomeWalletFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is HomeTransactionsLoading) {
                  setState(() {
                    _txLoading = true;
                    _txError = null;
                  });
                } else if (state is HomeTransactionsFetched) {
                  setState(() {
                    _transactions = state.transactionsResponse.data;
                    _txLoading = false;
                  });
                } else if (state is HomeTransactionsFailure) {
                  setState(() {
                    _txLoading = false;
                    _txError = state.message;
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: AppBarHome(
                context,
                userName: "${widget.userModel.user.firstName}",
                balance: _walletBalance,
                refundableBalance: _refundableBalance,
                userModel: widget.userModel,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: const Color(0xFF337687),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🎅 Xmas Kapu Promo Banner
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PromoCardsPage(userModel: widget.userModel),
                            ),
                          );
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
                            // Add glow effect for light mode
                            boxShadow: widget.isDarkModeOn
                                ? null
                                : [
                                    // BoxShadow(
                                    //   color: Colors.white.withOpacity(0.8),
                                    //   blurRadius: 15.r,
                                    //   spreadRadius: 3.r,
                                    //   offset: Offset(0, 0),
                                    // ),
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
                    SizedBox(height: 28.h),
                    VoucherModalSheet(context: context),
                    SizedBox(height: 8.h),
                    _buildMerchantImages(context),
                    SizedBox(height: 8.h),
                    _buildTransactionsSection(context),
                  ],
                ),
              ),
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
                      Divider(thickness: 1, color: Colors.grey[300]),
                      SizedBox(height: 10.h),

                      Text(
                        "My Referral Rewards",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D3C4E),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _referralRow("Friends Joined", "0"),
                      _referralRow("Total Earned", "Kes 0"),
                      _referralRow("Amount Used", "Kes 0"),
                      _referralRow("Current Balance", "Kes 0"),
                      SizedBox(height: 10.h),
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

  Widget _referralRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 15.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 15.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantImages(BuildContext context) {
    final bool useDynamicMerchants = false;

    if (!useDynamicMerchants) {
      // ✅ Hardcoded fallback
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildMerchantCard(
              context,
              "assets/merchants/hotpoint.svg",
              110.w,
              "Hotpoint",
              merchantId: 73,
            ),
            SizedBox(width: 30.w),
            _buildMerchantCard(
              context,
              "assets/merchants/naivas.png",
              110.w,
              "Naivas",
              merchantId: 107,
            ),
            SizedBox(width: 30.w),
            _buildMerchantCard(
              context,
              "assets/merchants/quickmart.png",
              100.w,
              "Quickmart",
              merchantId: 347,
            ),
          ],
        ),
      );
    }

    // ✅ Dynamic merchants via Bloc
    // return BlocBuilder<MerchantsCubit, MerchantsState>(
    //   builder: (context, state) {
    //     if (state is MerchantsLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (state is MerchantsError) {
    //       return Text("Error: ${state.message}");
    //     } else if (state is MerchantsFetched) {
    //       if (state.merchants.isEmpty) {
    //         return const Text("No merchants available");
    //       }
    //       return SingleChildScrollView(
    //         scrollDirection: Axis.horizontal,
    //         child: Row(
    //           children: state.merchants.map((m) {
    //             final img = m.logo ?? "assets/placeholder.png";
    //             return Padding(
    //               padding: EdgeInsets.only(right: 30.w),
    //               child: _buildMerchantCard(
    //                 context,
    //                 img,
    //                 110.w,
    //                 m.merchantName ?? "Merchant",
    //               ),
    //             );
    //           }).toList(),
    //         ),
    //       );
    //     }
    //     return const SizedBox.shrink();
    //   },
    // );
  }

  Widget _buildMerchantCard(
    BuildContext context,
    String imagePath,
    double width,
    String merchantName, {
    int merchantId = 0,
  }) {
    return GestureDetector(
      onTap: () => showMerchantVoucherModal(context, merchantName, merchantId),
      child: Container(
        width: width,
        height: 60.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: imagePath.endsWith('.svg')
            ? SvgPicture.asset(imagePath, fit: BoxFit.contain)
            : imagePath.startsWith("http")
            ? Image.network(imagePath, fit: BoxFit.contain)
            : Image.asset(imagePath, fit: BoxFit.contain),
      ),
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
        SizedBox(height: 20.h),
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
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(_createSlideUpRoute(_transactions));
        },
        // ... existing code ...
        child: Container(
          padding: EdgeInsets.all(12.w),
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
                              fontSize: 13.sp,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            description,
                            style: GoogleFonts.montserrat(
                              fontSize: 15.sp,
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
                  fontSize: 16.sp,
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
