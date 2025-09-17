import 'package:flexpay/exports.dart';
import 'package:flexpay/features/home/ui/topupscreen.dart';
import 'package:flexpay/features/home/ui/withdrawpage.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarHome extends StatefulWidget {
  final String userName;
  final double balance;

  const AppBarHome(
    BuildContext context, {
    super.key,
    required this.userName,
    required this.balance,
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  bool isBalanceVisible = true;

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 54.h),
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
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await SharedPreferencesHelper.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.white,
                        child:
                            Icon(Icons.person, size: 24.sp, color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      widget.userName,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.notifications, color: Colors.white, size: 28.sp),
              ],
            ),
            SizedBox(height: 36.h),

            /// Balance Label
            Text(
              'Total balance',
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4.h),

            /// Balance Value + Visibility Toggle
            Row(
              children: [
                Expanded(
                  child: Text(
                    isBalanceVisible
                        ? 'Ksh ${widget.balance.toStringAsFixed(2)}'
                        : '••••••',
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
                    isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(Icons.shopping_cart, "Shop",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MerchantsScreen()))),
                _buildActionButton(Icons.account_balance_wallet, "Withdraw",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WithdrawPage()))),
                _buildActionButton(Icons.arrow_downward, "Top up",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TopUpPage()))),
                _buildActionButton(Icons.sync_alt, "Transfer"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {VoidCallback? onTap}) {
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
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
