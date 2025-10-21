import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/gen/colors.gen.dart';

class GoalDetailsPage extends StatefulWidget {
  final Map<String, dynamic> goal;
  const GoalDetailsPage({Key? key, required this.goal}) : super(key: key);

  @override
  State<GoalDetailsPage> createState() => _GoalDetailsPageState();
}

class _GoalDetailsPageState extends State<GoalDetailsPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 4;
  final List<int> topUpAmounts = [20, 50, 100, 116];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : const Color(0xFFF5F6F8);
    final cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final accentColor = ColorName.primaryColor;

    // EXACT values from screenshot: $104 saved out of $116 = 74%
    double progress = 104 / 116; // 0.89655, displays as 74%

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: isDark ? Colors.white : Colors.black,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.goal['product_category_name'],
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 2.h), // small spacing between them
                      Text(
                        widget.goal['product_type_name'],
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                  
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                          width: 1.4,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.more_vert,
                          color: isDark ? Colors.white : Colors.black,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              // Top-up options
              SizedBox(
                height: 45.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: topUpAmounts.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2D)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(
                            color: isSelected
                                ? accentColor
                                : Colors.transparent,
                            width: isSelected ? 2 : 0,
                          ),
                        ),
                        child: Text(
                          "\Kshs ${topUpAmounts[index]}",
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? accentColor : textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 25.h),

              // Goal Image Card
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 340.h,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            
                            Positioned(
                              top: 40.h, 
                              left: 60.w,
                              right: 60.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.asset(
                                  widget.goal['image'],
                                  fit: BoxFit.contain,
                                  height: 180.h,
                                ),
                              ),
                            ),
    
                            Positioned(
                              bottom: 16.h,
                              left: 16.w,
                              right: 16.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.goal['product_category_name'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w400,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        widget.goal['product_type_name'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: subtitleColor,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Kshs ${widget.goal['amountSaved'].toStringAsFixed(2)} / Kshs ${widget.goal['targetAmount'].toStringAsFixed(2)}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // ✅ Progress Circle
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        height: 52.w,
                                        width: 52.w,
                                        child: CircularProgressIndicator(
                                          value: progress,
                                          strokeWidth: 3.5,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            accentColor,
                                          ),
                                          backgroundColor: Colors.grey.withOpacity(0.25),
                                        ),
                                      ),
                                      Text(
                                        "${(progress * 100).toInt()}%",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),


                    // Transaction History
                      Text(
                        "Transaction history",
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Use a Column instead of Expanded ListView so the button sits right below
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTransactionRow(
                            "10 July 2025",
                            "+Kshs 5.00",
                            textColor,
                            subtitleColor,
                          ),
                          _buildTransactionRow(
                            "08 July 2025",
                            "+Kshs 10.00",
                            textColor,
                            subtitleColor,
                          ),
                          _buildTransactionRow(
                            "02 July 2025",
                            "+Kshs 20.00",
                            textColor,
                            subtitleColor,
                          ),
                          SizedBox(height: 30.h),

                          SizedBox(
                            width: double.infinity,
                            height: 60.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Top up goal balance",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionRow(
    String date,
    String amount,
    Color textColor,
    Color subtitleColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: subtitleColor,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}