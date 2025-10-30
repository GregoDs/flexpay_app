import 'dart:math';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/models/savings_model/chama_savings_model.dart';
import 'package:flexpay/features/flexchama/ui/appbar_chama_home.dart';
import 'package:flexpay/features/flexchama/ui/shimmer_chama_products.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/services/logger.dart';

class FlexChama extends StatefulWidget {
  final dynamic profile;
  const FlexChama({super.key, required this.profile});

  @override
  State<FlexChama> createState() => _FlexChamaState();
}

class _FlexChamaState extends State<FlexChama> {
  Future<void> _refresh() async {
    await context.read<ChamaCubit>().fetchChamaUserSavings();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSystemDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final Color backgroundColor = isSystemDarkMode
        ? Colors.black
        : Colors.white;
    final Color textColor = isSystemDarkMode ? Colors.white : Colors.black;
    final Color cardColor = isSystemDarkMode ? Colors.grey[900]! : Colors.white;
    final highlightColor = isSystemDarkMode
        ? Colors.blueAccent
        : const Color(0xFF57A5D8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.48),
        child: AppBarChama(context),
      ),
      body: BlocListener<ChamaCubit, ChamaState>(
        listener: (context, state) {
          if (state is ChamaSavingsFetched &&
              state.savingsResponse.statusCode != 400 &&
              state.savingsResponse.errors?.isNotEmpty == true) {
            final response = state.savingsResponse;
            // Only show snackbar for non-400 errors
            if ((response.errors?.isNotEmpty ?? false) &&
                response.statusCode != 400) {
              final errorMsg = response.errors!.first.toString();
              CustomSnackBar.showError(
                context,
                title: "Error",
                message: errorMsg,
              );
            } else if (response.statusCode == 400) {
              AppLogger.log(
                "ℹ️ 400 error ignored for UI: ${response.errors?.first}",
              );
            }
          }
        },

        child: BlocBuilder<ChamaCubit, ChamaState>(
  builder: (context, state) {
    // ✅ Extract previous savings if in loading state
    ChamaSavingsResponse? savingsData;
    
    if (state is ChamaSavingsFetched) {
      savingsData = state.savingsResponse;
    } else if (state is ChamaSavingsLoading && state.previousSavings != null) {
      // ✅ Use cached data during loading
      savingsData = state.previousSavings;
    }

    // ✅ Only show shimmer if we have NO data at all
    if (savingsData == null && state is ChamaSavingsLoading) {
      return const FlexChamaShimmer();
    }
    
    // Show error
    if (state is ChamaError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    // ✅ Set balances from available data
    int loanBalance = 0;
    int loanLimit = 0;
    
    if (savingsData?.data?.chamaDetails != null) {
      final chamaDetails = savingsData!.data!.chamaDetails;
      loanBalance = chamaDetails.loanTaken;
      loanLimit = chamaDetails.loanLimit;
    }

    // ✅ Check if we're in a withdrawal loading state
    final isWithdrawing = state is WithdrawChamaSavingsLoading;

    return RefreshIndicator(
      onRefresh: _refresh,
      color: highlightColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Balance & Limit Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBalanceCard(
                  FontAwesomeIcons.creditCard,
                  'Loan Balance',
                  '${AppUtils.formatAmount(loanBalance)}',
                  Colors.green,
                  textColor,
                  cardColor,
                ),
                _buildBalanceCard(
                  FontAwesomeIcons.handHoldingDollar,
                  'Loan Limit',
                  '${AppUtils.formatAmount(loanLimit)}',
                  Colors.orange,
                  textColor,
                  cardColor,
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // ✅ Show loading indicator if withdrawing
            if (isWithdrawing)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(highlightColor),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Processing withdrawal...",
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          color: highlightColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Chamas card
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, Routes.viewChamas);
                await context.read<ChamaCubit>().fetchChamaUserSavings();
              },
              child: _buildCard(
                icon: Icons.groups,
                title: 'Chamas',
                description: 'Tap to view your chama',
                highlightColor: highlightColor,
                textColor: textColor,
                cardColor: cardColor,
              ),
            ),
            SizedBox(height: 20.h),

            // Transactions
            Text(
              'Transactions',
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),

            // ✅ Show transactions if we have data
            if (savingsData?.data != null) ...[
              Builder(
                builder: (_) {
                  final payments = savingsData!.data!.payments.data ?? [];

                  if (payments.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Text(
                        "No Payments yet",
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontStyle: FontStyle.italic,
                          color: textColor,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: min(5, payments.length),
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return _buildTransactionRow(
                        payment.createdAt,
                        payment.paymentSource,
                        'Kshs ${AppUtils.formatAmount(payment.paymentAmount)}',
                        textColor,
                        cardColor,
                      );
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  },
),
      ),
    );
  }

  // Original balance card
  Widget _buildBalanceCard(
    IconData icon,
    String title,
    String amount,
    Color iconColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      width: 160.w,
      height: 144.h,
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28.sp),
          SizedBox(height: 10.h),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer balance card
  Widget _buildShimmerBalanceCard(Color cardColor, Color highlightColor) {
    final baseColor = Colors.grey[300]!;
    return Container(
      width: 160.w,
      height: 144.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 28.sp, height: 28.sp, color: baseColor),
            SizedBox(height: 10.h),
            Container(width: 80.w, height: 12.h, color: baseColor),
            SizedBox(height: 5.h),
            Container(width: 100.w, height: 18.h, color: baseColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
    required Color highlightColor,
    required Color textColor,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: highlightColor, size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: highlightColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: highlightColor, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(
    String date,
    String description,
    String amount,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
