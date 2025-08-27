import 'package:flexpay/features/flexchama/ui/appbarchama.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Add this import

class FlexChama extends StatefulWidget {
  const FlexChama({super.key});

  @override
  State<FlexChama> createState() => _FlexChamaState();
}

class _FlexChamaState extends State<FlexChama> {
  int walletBalance = 22000;
  int loanBalance = 0;
  int flexcoinBalance = 1230;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isSystemDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final Color backgroundColor =
        isSystemDarkMode ? Colors.black : Colors.white;
    final Color textColor = isSystemDarkMode ? Colors.white : Colors.black;
    final Color cardColor = isSystemDarkMode ? Colors.grey[900]! : Colors.white;
    final Color shadowColor =
        isSystemDarkMode ? Colors.transparent : Colors.grey.withOpacity(0.2);
    final highlightColor =
        isSystemDarkMode ? Colors.blueAccent : Color(0xFF57A5D8);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.48),
        child: AppBarChama(context),
      ),
      body: SingleChildScrollView(
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
                      loanBalance.toString(),
                      Colors.green,
                      textColor,
                      cardColor),
                  _buildBalanceCard(
                      FontAwesomeIcons.handHoldingDollar,
                      'Loan Limit',
                      flexcoinBalance.toString(),
                      Colors.orange,
                      textColor,
                      cardColor),
                ],
              ),
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
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  _buildTransactionRow('20TH Nov.', 'Navas Deposit - Fridge',
                      'MPESA', '20,000', textColor, cardColor),
                  _buildTransactionRow('20TH Nov.', 'Navas Deposit - Fridge',
                      'MPESA', '20,000', textColor, cardColor),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: NavigationWrapper(initialIndex: 2,),
    );
  }

  Widget _buildBalanceCard(IconData icon, String title, String amount,
      Color iconColor, Color textColor, Color cardColor) {
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
              blurRadius: 8)
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
              blurRadius: 8)
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

  Widget _buildTransactionRow(String date, String description, String method,
      String amount, Color textColor, Color cardColor) {
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
          Text(date,
              style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor)),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(method,
              style: GoogleFonts.montserrat(fontSize: 14.sp, color: textColor)),
          Text(amount,
              style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
        ],
      ),
    );
  }
}
