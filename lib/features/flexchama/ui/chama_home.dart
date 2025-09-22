import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/ui/appbar_chama_home.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/services/service_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlexChama extends StatefulWidget {
  final dynamic profile;
  const FlexChama({super.key, required this.profile});

  @override
  State<FlexChama> createState() => _FlexChamaState();
}

class _FlexChamaState extends State<FlexChama> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch on init
    // context.read<ChamaCubit>().fetchChamaUserSavings();
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
        : Color(0xFF57A5D8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.48),
        child: AppBarChama(context),
      ),
      body: BlocBuilder<ChamaCubit, ChamaState>(
        builder: (context, state) {
          int loanBalance = 0;
          int loanLimit = 0;
          int maturedSavings = 0;

          if (state is ChamaSavingsFetched) {
            final chamaDetails = state.savingsResponse.data!.chamaDetails;
            maturedSavings = chamaDetails.withdrawableAmount;
            loanBalance = chamaDetails.loanTaken;
            loanLimit = chamaDetails.loanLimit;
          }

          if (state is ChamaSavingsLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ChamaError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBalanceCard(
                        FontAwesomeIcons.creditCard,
                        'Loan Balance',
                        // 'Kshs $loanBalance',
                        'Kshs ${AppUtils.formatAmount(loanBalance)}',

                        Colors.green,
                        textColor,
                        cardColor,
                      ),
                      _buildBalanceCard(
                        FontAwesomeIcons.handHoldingDollar,
                        'Loan Limit',
                        'Kshs ${AppUtils.formatAmount(loanLimit)}',
                        Colors.orange,
                        textColor,
                        cardColor,
                      ),
                    ],
                  ),
                  // SizedBox(height: 20.h),
                  // _buildBalanceCard(
                  //     FontAwesomeIcons.wallet,
                  //     'Matured Savings',
                  //     'Kshs $maturedSavings',
                  //     Colors.blue,
                  //     textColor,
                  //     cardColor),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.viewChamas);
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
                  Text(
                    'Transactions',
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (state is ChamaSavingsFetched)
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          state.savingsResponse.data!.payments.data.length,
                      itemBuilder: (context, index) {
                        final payment =
                            state.savingsResponse.data!.payments.data[index];
                        return _buildTransactionRow(
                          payment.createdAt,
                          payment.paymentSource,
                          // payment.paymentAddress,
                          // 'Kshs ${payment.paymentAmount}',
                          'Kshs ${AppUtils.formatAmount(payment.paymentAmount)}',
                          textColor,
                          cardColor,
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
    // String method,
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
          // Text(method,
          //     style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor)),
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
