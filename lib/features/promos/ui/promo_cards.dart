import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

class PromoCardsPage extends StatefulWidget {
  final UserModel? userModel;

  const PromoCardsPage({super.key, this.userModel});

  @override
  _PromoCardsPageState createState() => _PromoCardsPageState();
}

class _PromoCardsPageState extends State<PromoCardsPage> {
  final List<Map<String, dynamic>> merchants = [
    {
      'name': 'Jaza',
      'amount': 14200.00,
      'color': const Color(
        0xFF761B1A,
      ), // Brand blue (vibrant, fresh discount vibe)
    },

    {
      'name': 'Quickmart Supermarket',
      'amount': 12850.00,
      'color': const Color(
        0xFF111111,
      ), // Authentic brand red (deep Persian Plum from logos/signage)
    },
    {
      'name': 'Naivas supermarket',
      'amount': 9800.00,
      'color': const Color(
        0xFFFFB020,
      ), // Brand green (freshness icon in stores)
    },

    {
      'name': 'Azone Supermarket',
      'amount': 7250.00,
      'color': const Color(
        0xFF6C63FF,
      ), // Brand purple (tech/modern appliance feel)
    },
    {
      'name': 'Open Wallet',
      'amount': 6300.00,
      'color': const Color(
        0xFF00A86B,
      ), // Financial orange (energetic, accessible)
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredMerchants = [];

  @override
  void initState() {
    super.initState();


  // ✅ Precache the promo background pattern to remove delay
  WidgetsBinding.instance.addPostFrameCallback((_) {
    precacheImage(
      const AssetImage('assets/images/home_images/promo_card_pattern.jpg'),
      context,
    );
  });

    _filteredMerchants = merchants;
    _searchController.addListener(() {
      _filterMerchants(_searchController.text);
    });


  }

  void _filterMerchants(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredMerchants = merchants
          .where(
            (merchant) =>
                merchant['name'].toString().toLowerCase().contains(lowerQuery),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final Color inputBg = isDarkMode
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF6F7F9);
    final Color subTextColor = isDarkMode ? Colors.grey[300]! : Colors.black54;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIcon(
                    context,
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      // Navigate back to the NavigationWrapper's home screen
                      if (widget.userModel != null) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/home',
                          arguments: widget.userModel,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    isDark: isDarkMode,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Christmas Kapu',
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Promos',
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                  _circleIcon(
                    context,
                    icon: Icons.more_vert,
                    onTap: () {},
                    isDark: isDarkMode,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Welcome Section
              Text(
                'Select your Christmas Kapu 🎅\nfrom our wide varieties',
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
              // SizedBox(height: 10.h),
              // Text(
              //   'Choose your Kapu',
              //   style: GoogleFonts.montserrat(
              //     fontSize: 14.sp,
              //     color: isDarkMode ? Colors.grey[300] : Colors.black87,
              //   ),
              // ),
              SizedBox(height: 20.h),

              // Search Bar
              Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 18.w),
                    Icon(Icons.search, size: 26.sp, color: subTextColor),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "Search for a kapu...",
                          hintStyle: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            color: subTextColor,
                          ),
                        ),
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          color: textColor,
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
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Merchant Cards
              Expanded(
                child: _filteredMerchants.isEmpty
                    ? Center(
                        child: Text(
                          'No merchants found',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            color: subTextColor,
                          ),
                        ),
                      )
                    : ListView(
                        children: _filteredMerchants
                            .map((merchant) => _buildMerchantCard(merchant))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF6F7F9),
          shape: BoxShape.circle,
          border: isDark
              ? Border.all(color: Colors.grey[700]!, width: 0.5)
              : null,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildMerchantCard(Map<String, dynamic> merchant) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      height: 160.h,
      decoration: BoxDecoration(
        color: merchant['color'],
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: merchant['color'].withOpacity(isDarkMode ? 0.25 : 0.35),
            blurRadius: isDarkMode ? 12 : 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern background
          Positioned.fill(
            child: Opacity(
              opacity: isDarkMode ? 0.05 : 0.08,
              child: Image.asset(
                'assets/images/home_images/promo_card_pattern.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Card content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        merchant['name'],
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Tap to view button
                    GestureDetector(
                      onTap: () {
                        // Add your navigation logic here
                        print('Tapped on ${merchant['name']}');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app_rounded,
                              size: 12.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Tap to view",
                              style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "Withdrawable Amount",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Ksh ${merchant['amount'].toStringAsFixed(2)}",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "FlexPay Merchant",
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
