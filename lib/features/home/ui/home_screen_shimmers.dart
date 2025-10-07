import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ==========================================================
/// 🧭 HOME SCREEN SHIMMERS
/// ==========================================================

/// 🧩 1️⃣ AppBar shimmer — only the balance section shimmers
class AppBarHomeShimmer extends StatelessWidget {
  const AppBarHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
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
          // Top icons + logo row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.menu, color: Colors.white, size: screenWidth * 0.07),
              Image.asset('assets/icon/logos/logo.png', height: 30.h),
              Icon(Icons.notifications, color: Colors.white, size: screenWidth * 0.07),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),

          // Greeting Row
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 24.sp, color: Colors.blue),
              ),
              SizedBox(width: 10.w),
              Text(
                "Hello ...",
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),

          // Label
          Text(
            'Total balance',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 6.h),

          // 🔥 Shimmering balance field
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.3),
            highlightColor: Colors.white.withOpacity(0.7),
            child: Container(
              width: 180.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Placeholder buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 24.r,
                    child: Icon(Icons.circle, color: Colors.white, size: 20.sp),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 40.w,
                    height: 10.h,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🧩 2️⃣ TransactionDetails shimmer — full list shimmer
class TransactionDetailsShimmer extends StatelessWidget {
  const TransactionDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "All Transactions",
          style: GoogleFonts.montserrat(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // show 10 shimmer items
        itemBuilder: (context, index) {
          return const _TransactionItemShimmer();
        },
      ),
    );
  }
}

/// 💡 Small shimmer card for each transaction
class _TransactionItemShimmer extends StatelessWidget {
  const _TransactionItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left column (description + date)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 100,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right side (amount placeholder)
            Container(
              width: 60,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}