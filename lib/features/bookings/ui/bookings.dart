import 'package:flexpay/features/bookings/cubit/bookings_state.dart';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/features/bookings/ui/booking_details.dart';
import 'package:flexpay/features/bookings/cubit/bookings_cubit.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  String selectedTab = "all";

  @override
  void initState() {
    super.initState();
    // fetch bookings immediately
    context.read<BookingsCubit>().fetchBookingsByType("all");
  }

  void _onTabSelected(String tab) {
    setState(() => selectedTab = tab);
    context.read<BookingsCubit>().fetchBookingsByType(tab.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF23262B) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF1D3C4E);
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Padding(
                padding: EdgeInsets.only(
                    left: 12.w, right: 12.w, top: 22.h, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, color: iconColor, size: 32.sp),
                    Center(
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF337687),
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
              SizedBox(height: 22.h),

              // Title + Add Bookings
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 14.w),
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
              SizedBox(height: 22.h),

              // Search + Tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
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
                          decoration: const BoxDecoration(
                            color: Color(0xFFF7B53A),
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // _BookingTab(
                            //   label: "All",
                            //   selected: selectedTab == "All",
                            //   color: selectedTab == "All"
                            //       ? const Color(0xFFF7B53A)
                            //       : const Color(0xFFF6F7F9),
                            //   textColor: selectedTab == "All"
                            //       ? Colors.white
                            //       : const Color(0xFF1D3C4E),
                            //   onTap: () => _onTabSelected("All"),
                            // ),
                            // SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Active",
                              selected: selectedTab == "active",
                              color: selectedTab == "active"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("active"),
                            ),
                            SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Overdue",
                              selected: selectedTab == "Overdue",
                              color: selectedTab == "Overdue"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("Overdue"),
                            ),
                            SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Unpaid",
                              selected: selectedTab == "unserviced",
                              color: selectedTab == "unserviced"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("unserviced"),
                            ),
                            SizedBox(width: 12.w),
                            _BookingTab(
                              label: "Completed",
                              selected: selectedTab == "complete",
                              color: selectedTab == "complete"
                                  ? const Color(0xFFF7B53A)
                                  : const Color(0xFFF6F7F9),
                              textColor: Colors.black,
                              onTap: () => _onTabSelected("complete"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),

              // Bookings List
              Expanded(
                child: BlocBuilder<BookingsCubit, BookingsState>(
                  builder: (context, state) {
                      if (state is BookingsLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/images/LoadingPlane.json',
                                width: 360.w,
                                height: 360.w,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        );
                      } else if (state is BookingsError) {
                      // Show snack bar with real error message
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        CustomSnackBar.showError(
                          context,
                          title: "Error",
                          message: state.message,
                        );
                      });

                      // Show friendly error UI
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/images/chamatype.json', // 👈 error animation file
                              width: 220.w,
                              height: 220.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "An error occurred",
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is BookingsFetched) {
                      final bookings = state.bookings;

                      if (bookings.isEmpty) {
                        return Center(
                          child: Text(
                            "No ${state.bookingType} bookings yet",
                            style: GoogleFonts.montserrat(),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return _BookingCard(
                            booking: booking,
                            cardColor: cardColor,
                            textColor: textColor,
                          );
                        },
                      );
                    }

                    return const SizedBox();
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

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final Color cardColor;
  final Color textColor;

  const _BookingCard({
    Key? key,
    required this.booking,
    required this.cardColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingDetailsPage(booking: booking),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: const [
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
                booking.image != null
                    ?  ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            "assets/images/bookings_imgs/maldivesholiday.jpeg",
            width: 46.w,
            height: 46.w,
            fit: BoxFit.cover,
          ),
        )
      : Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey[400],
            size: 26.sp,
          ),
        ),
              
                    // : SizedBox(width: 46.w), // keep space consistent

                SizedBox(
                    width: 12.w), // 👈 spacing between image and info column

                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.productName ?? "Unknown Product",
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        booking.deadlineDate != null
                            ? "Due on ${booking.deadlineDate}"
                            : "Created on ${booking.createdAt}",
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          color:  textColor,
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Progress bar row
                      Row(
                        children: List.generate(10, (i) {
                          double total = (booking.total ?? 0).toDouble();
                          double price = (booking.bookingPrice ?? 1).toDouble();
                          double progress = total / price;
                          double fill = progress * 10;
                          bool filled = i < fill.round();

                          return Padding(
                            padding: EdgeInsets.only(right: 4.w),
                            child: Container(
                              width: 16.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: filled ? Colors.green : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Right column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if ((booking.progress ?? 0) >= 1.0)
                      Icon(Icons.verified,
                          color: const Color(0xFFF7B53A), size: 28.sp),
                    SizedBox(height: 8.h),
                    Text(
                      "${(((booking.total ?? 0) / (booking.bookingPrice ?? 1)) * 100).round()}%",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "Paid",
                      style: GoogleFonts.montserrat(fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
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
