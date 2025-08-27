import 'package:flexpay/features/bookings/ui/booking_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

final List<Map<String, dynamic>> dummyBookings = [
  {
    "image": "assets/images/bookings_imgs/samsungtv.avif",
    "title": "Samsung 43 LED TV",
    "subtitle": "Done on January 3rd",
    "progress": 1.0,
    "progressColor": Color(0xFFF7B53A),
    "badge": true,
    "percentage": 100,
    "status": "Completed",
  },
  {
    "image": null,
    "title": "School Fees",
    "subtitle": "Yours by February 20th",
    "progress": 0.9,
    "progressColor": Colors.green,
    "badge": false,
    "percentage": 90,
    "status": "Active",
  },
  {
    "image": "assets/images/bookings_imgs/Lseat.jpeg",
    "title": "L seat",
    "subtitle": "Yours by March 12th",
    "progress": 0.6,
    "progressColor": Colors.green,
    "badge": false,
    "percentage": 60,
    "status": "Active",
  },
  {
    "image": "assets/images/bookings_imgs/maldivesholiday.jpeg",
    "title": "Maldives Vacation",
    "subtitle": "Done on November 22",
    "progress": 1.0,
    "progressColor": Color(0xFFF7B53A),
    "badge": true,
    "percentage": 100,
    "status": "Completed",
  },
];

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String selectedTab = "All";

  List<Map<String, dynamic>> get filteredBookings {
    if (selectedTab == "All") return dummyBookings;
    return dummyBookings.where((b) => b["status"] == selectedTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF23262B) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF1D3C4E);
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark, 
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar, title, search, tabs (fixed)
              Padding(
                padding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 22.h, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, color: iconColor, size: 32.sp),
                    Center(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF337687)
                              : const Color(0xFF337687),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          'assets/icon/logos/logo.png',
                          height: 40.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Icon(Icons.notifications_none,
                        color: iconColor, size: 32.sp),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Bookings",
                      style: GoogleFonts.montserrat(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1D3C4E),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Add Bookings",
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            color: const Color(0xFF1D3C4E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFFF7B53A),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.add,
                              color: const Color(0xFFF7B53A), size: 20.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.only(
                    top: 10.w, left: 20.w, right: 20.w, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar and filter icon row
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F7F9),
                              borderRadius: BorderRadius.circular(28.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 18.w),
                                Icon(Icons.search,
                                    size: 26.sp, color: Colors.black87),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 14.h),
                                      hintText: "Search",
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 16.sp,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 18.w),
                        Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7B53A),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.filter_list,
                              color: Colors.white, size: 24.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    // Tabs
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _BookingTab(
                            label: "All",
                            selected: selectedTab == "All",
                            color: selectedTab == "All"
                                ? const Color(0xFFF7B53A)
                                : (isDarkMode
                                    ? const Color(0xFF23262B)
                                    : const Color(0xFFF6F7F9)),
                            textColor: selectedTab == "All"
                                ? Colors.white
                                : const Color(0xFF1D3C4E),
                            onTap: () => setState(() => selectedTab = "All"),
                          ),
                          SizedBox(width: 12.w),
                          _BookingTab(
                            label: "Completed",
                            selected: selectedTab == "Completed",
                            color: selectedTab == "Completed"
                                ? const Color(0xFFF7B53A)
                                : (isDarkMode
                                    ? const Color(0xFF23262B)
                                    : const Color(0xFFF6F7F9)),
                            textColor: selectedTab == "Completed"
                                ? Colors.white
                                : Colors.white,
                            onTap: () =>
                                setState(() => selectedTab = "Completed"),
                          ),
                          SizedBox(width: 12.w),
                          _BookingTab(
                            label: "Active",
                            selected: selectedTab == "Active",
                            color: selectedTab == "Active"
                                ? const Color(0xFFF7B53A)
                                : (isDarkMode
                                    ? const Color(0xFF23262B)
                                    : const Color(0xFFF6F7F9)),
                            textColor: selectedTab == "Active"
                                ? Colors.white
                                : Colors.white,
                            onTap: () => setState(() => selectedTab = "Active"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
              // Bookings List (scrollable)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = filteredBookings[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BookingDetailsPage(booking: booking),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(18.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Asset image or placeholder
                                booking["image"] != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        child: Image.asset(
                                          booking["image"],
                                          width: 60.w,
                                          height: 60.w,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 60.w,
                                        height: 60.w,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                SizedBox(width: 18.w),
                                // Title, subtitle, progress
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              booking["title"],
                                              style: GoogleFonts.montserrat(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w700,
                                                color: textColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        booking["subtitle"],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13.sp,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 14.h),
                                      // Progress bar (dashed)
                                      Row(
                                        children: List.generate(10, (i) {
                                          double fill =
                                              booking["progress"] * 10;
                                          bool filled = i < fill.round();
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(right: 4.w),
                                            child: Container(
                                              width: 16.w,
                                              height: 6.h,
                                              decoration: BoxDecoration(
                                                color: filled
                                                    ? booking["progressColor"]
                                                    : Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                // Badge and Percentage (right column)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (booking["progress"] == 1.0)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: Icon(Icons.verified,
                                            color: Color(0xFFF7B53A),
                                            size: 28.sp),
                                      ),
                                    if (booking["progress"] != 1.0)
                                      SizedBox(
                                          height: 22
                                              .h), // Move percentage lower for non-100%
                                    Text(
                                      "${booking["percentage"]}%",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      "Saved",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingTab extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _BookingTab({
    required this.label,
    required this.selected,
    required this.color,
    required this.textColor,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
