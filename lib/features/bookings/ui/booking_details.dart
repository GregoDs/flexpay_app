import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:intl/intl.dart';

class BookingDetailsPage extends StatelessWidget {
  final Booking booking;

  const BookingDetailsPage({Key? key, required this.booking}) : super(key: key);

  

String formatPaymentDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "";
  try {
    final parsedDate = DateTime.parse(dateStr);
    return DateFormat("dd-MM-yyyy").format(parsedDate); // 20-08-2025
  } catch (e) {
    return dateStr;
  }
}

String formatMaturityDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return "No maturity set";
  try {
    final parsedDate = DateTime.parse(dateStr);
    return DateFormat("d MMM yyyy").format(parsedDate); // 23 Nov 2025
  } catch (e) {
    return dateStr;
  }
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            "Booking Details",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 86.h),
                child: Column(
                  children: [
                    // Card with booking image overlapping
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Card background
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(20.w, 70.h, 20.w, 20.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            image: DecorationImage(
                              image: AssetImage("assets/images/appbarbackground.png"),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                booking.productName ?? "No Booking Name",
                                style: GoogleFonts.montserrat(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 28.h),

                              // Product Cost & Balance in one row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildRowItem("Product Cost",
                                      "Kshs ${booking.bookingPrice ?? 0}"),
                                  _buildRowItem("Balance",
                                      "Kshs ${(booking.bookingPrice ?? 0) - (booking.total ?? 0)}"),
                                ],
                              ),
                              SizedBox(height: 14.h),

                              // Paid & Maturity in next row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildRowItem("Paid",
                                      "Kshs ${booking.total ?? 0}"),
                                  _buildRowItem(
                                      "Maturity",
                                      formatMaturityDate(booking.deadlineDate),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Divider(thickness: 1, color: Colors.white30),
                              SizedBox(height: 20.h),

                              // Action Buttons
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorName.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Complete Booking",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.redAccent, width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Cancel Booking",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Booking Image (overlapping on top)
                        Positioned(
                          top: -60.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                color: Colors.grey[300],
                              ),
                              child: ClipOval(
                                child: booking.image != null &&
                                        booking.image!.isNotEmpty
                                    ? Image.network(
                                        booking.image!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/bookings_imgs/maldivesholiday.jpeg",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Payments Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Payments",
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorName.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    
                    if (booking.payments != null &&
                        booking.payments!.isNotEmpty)
                      ...booking.payments!.map(
                        (p) => Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.all(14.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[850] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatPaymentDate(p.createdAt) ?? "",
                                style: GoogleFonts.montserrat(
                                  fontSize: 13.sp,
                                  color: isDark? Colors.white70 : Colors.black,
                                ),
                              ),
                              Text(
                                "Mobile Money Transfer",
                                style: GoogleFonts.montserrat(
                                  fontSize: 13.sp,
                                  color: isDark? Colors.white70 : Colors.black,
                                ),
                              ),
                              Text(
                                "Kshs ${p.paymentAmount}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark? Colors.white70 : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Text(
                        "No payments yet",
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          color: textColor,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRowItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}