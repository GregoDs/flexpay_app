import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FlexChamaShimmer extends StatelessWidget {
  const FlexChamaShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSystemDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color cardColor = isSystemDarkMode ? Colors.grey[900]! : Colors.white;
    final Color baseColor =
        isSystemDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final Color highlightColor =
        isSystemDarkMode ? Colors.grey[700]! : Colors.grey[100]!;
        final Color textColor = isSystemDarkMode ? Colors.white : Colors.black;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Balance & Loan Limit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShimmerCard(baseColor, highlightColor, cardColor),
                _buildShimmerCard(baseColor, highlightColor, cardColor),
              ],
            ),
            SizedBox(height: 20.h),
            // Chamas card placeholder
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              height: 100.h,
              width: double.infinity,
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Container(color: baseColor),
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
            // 5 Shimmer transaction rows
            for (int i = 0; i < 5; i++)
              _buildShimmerTransactionRow(baseColor, highlightColor, cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard(Color baseColor, Color highlightColor, Color cardColor) {
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

  Widget _buildShimmerTransactionRow(
      Color baseColor, Color highlightColor, Color cardColor) {
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
          // Date shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(width: 60.w, height: 14.h, color: baseColor),
          ),
          SizedBox(width: 20.w),
          // Description shimmer
          Expanded(
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(width: double.infinity, height: 14.h, color: baseColor),
            ),
          ),
          SizedBox(width: 10.w),
          // Amount shimmer
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(width: 50.w, height: 14.h, color: baseColor),
          ),
        ],
      ),
    );
  }
}