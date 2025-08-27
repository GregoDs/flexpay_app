import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class BookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> booking;

  const BookingDetailsPage({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color cardColor =
        isDarkMode ? const Color(0xFF22313F) : const Color(0xFF22313F);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color accent = const Color(0xFF6FDA56);
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light // White status bar text/icons
          : SystemUiOverlayStyle.dark, // Black status bar text/icons
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: iconColor, size: 28.sp),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        booking["title"] ?? "Holiday Saving",
                        style: GoogleFonts.montserrat(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  //Booking card stack
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 80.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(36.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 98.h,
                            left: 18.w,
                            right: 18.w,
                            bottom: 36.h,
                          ),
                          child: Column(
                            children: [
                              Text(
                                booking["title"] ?? "Holiday",
                                style: GoogleFonts.montserrat(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 18.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Product Cost (NGN)",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[200],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        booking["cost"]?.toString() ??
                                            "77,000",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Earnings",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[200],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        booking["earnings"]?.toString() ??
                                            "19,000",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              // Balance and Maturity fields
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Balance",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[200],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        booking["balance"]?.toString() ??
                                            "50,000",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Maturity",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[200],
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        booking["maturity"]?.toString() ??
                                            "20th Dec 2025",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 18.h),
                              Divider(color: Colors.white38, thickness: 1),
                              SizedBox(height: 18.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: accent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Complete",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 14.h),
                              // Cancel Booking Button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.redAccent, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Cancel Booking",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Image handling here 
                      Positioned(
                        top: 0,
                        child: Container(
                          width: 130.w,
                          height: 130.w,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                          child: booking["image"] != null
                              ? ClipOval(
                                  child: Image.asset(
                                    booking["image"],
                                    width: 130.w,
                                    height: 130.w,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  Text(
                    "Payments",
                    style: GoogleFonts.montserrat(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.lightBlue[400],
                    ),
                  ),
                  SizedBox(height: 18.h),
                  ...List.generate(
                    4,
                    (i) => Container(
                      margin: EdgeInsets.only(bottom: 14.h),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white10
                            : const Color(0xFFF6F7F9),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "20TH Nov.    Holiday Bank Transfer    0,000",
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
