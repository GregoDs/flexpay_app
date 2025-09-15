import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class MerchantsScreen extends StatefulWidget {
  @override
  State<MerchantsScreen> createState() => _MerchantsScreenState();
}

class _MerchantsScreenState extends State<MerchantsScreen> {
  final List<Map<String, String>> merchants = [
    {"name": "Smart Devices", "link": "Go to shop", "image": "assets/merchantspageimg/Quickmart.png"},
    {"name": "Moko", "link": "Go to shop", "image": "assets/merchantspageimg/Moko.png"},
    {"name": "Leviticus", "link": "Go to shop", "image": "assets/merchantspageimg/Leviticus.png"},
    {"name": "PataBay", "link": "Go to shop", "image": "assets/merchantspageimg/Patabay.png"},
    {"name": "Compland Company", "link": "Go to shop", "image": "assets/merchantspageimg/Compland.png"},
    {"name": "Hotpoint Appliances Limited", "link": "Go to shop", "image": "assets/merchantspageimg/Hotpoint.png"},
    {"name": "Electromart Kenya", "link": "Go to shop", "image": "assets/merchantspageimg/Electromart.png"},
    {"name": "Naivas Supermarket", "link": "Go to shop", "image": "assets/merchantspageimg/Naivas.png"},
    {"name": "ZuriMall Limited", "link": "Go to shop", "image": "assets/merchantspageimg/Zurimall.png"},
    {"name": "Citywalk Limited", "link": "Go to shop", "image": "assets/merchantspageimg/Quickmart.png"},
    {"name": "Quickmart Supermarket", "link": "Go to shop", "image": "assets/merchantspageimg/Quickmart.png"},
  ];

  final Set<int> favoriteIndices = {};

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDarkMode ? Colors.black : Colors.white;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF1D3C4E);
    final Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.black54;
    final Color inputBg = isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF6F7F9);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black)
          : SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.w),
                Center(
                  child: Image.asset(
                    'assets/icon/logos/logo.png',
                    height: 60.h,
                    fit: BoxFit.contain,
                  ),
                ),

                _buildWelcomeSection(isDarkMode),

                // Search + filter
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 56.h,
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
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: "Search",
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
                        child: Icon(Icons.filter_list, color: Colors.white, size: 24.sp),
                      ),
                    ],
                  ),
                ),

                // Category icons
                SizedBox(
                  height: 86.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _MerchantCategoryIcon(icon: Icons.shopping_cart_outlined, label: "Shopping", selected: false, isDarkMode: isDarkMode),
                      SizedBox(width: 28.w),
                      _MerchantCategoryIcon(icon: Icons.chair_outlined, label: "Furniture", selected: false, isDarkMode: isDarkMode),
                      SizedBox(width: 28.w),
                      _MerchantCategoryIcon(icon: Icons.luggage_outlined, label: "Travel", selected: false, isDarkMode: isDarkMode),
                      SizedBox(width: 28.w),
                      _MerchantCategoryIcon(icon: Icons.blender_outlined, label: "Appliances", selected: false, isDarkMode: isDarkMode),
                      SizedBox(width: 28.w),
                      _MerchantCategoryIcon(icon: Icons.grid_view_rounded, label: "All", selected: true, isDarkMode: isDarkMode),
                    ],
                  ),
                ),

                // Merchants grid
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: merchants.length,
                    itemBuilder: (context, index) {
                      return MerchantCard(
                        name: merchants[index]["name"]!,
                        link: merchants[index]["link"]!,
                        imageUrl: merchants[index]["image"]!,
                        isDarkMode: isDarkMode,
                        isFavorite: favoriteIndices.contains(index),
                        onFavoriteToggle: () {
                          setState(() {
                            favoriteIndices.contains(index)
                                ? favoriteIndices.remove(index)
                                : favoriteIndices.add(index);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildWelcomeSection(bool isDarkMode) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Text(
              "Save polepole",
              style: GoogleFonts.montserrat(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 64.w,
                height: 5.h,
                color: const Color(0xFFF7B53A),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          'You can save with us through these merchants:',
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            color: isDarkMode ? Colors.grey[300] : Colors.black87,
          ),
        ),
      ],
    ),
  );
}

class _MerchantCategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isDarkMode;

  const _MerchantCategoryIcon({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bg = selected
        ? const Color(0xFF4CA0C6)
        : (isDarkMode ? const Color(0xFF2C2C2C) : const Color(0xFFF6F7F9));
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Column(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(
            icon,
            color: selected ? Colors.white : const Color(0xFF1D3C4E),
            size: 20.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 11.sp,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class MerchantCard extends StatelessWidget {
  final String name;
  final String link;
  final String imageUrl;
  final bool isDarkMode;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final String location;
  final String rating;

  const MerchantCard({
    required this.name,
    required this.link,
    required this.imageUrl,
    required this.isDarkMode,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.location = "Kenya",
    this.rating = "4k",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        color: cardColor,
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image.asset(imageUrl, height: 200.h, width: double.infinity, fit: BoxFit.cover),
          ),

          // Heart button
          Positioned(
            top: 10.h,
            right: 10.w,
            child: CircleAvatar(
              radius: 16.r,
              backgroundColor: cardColor,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 18.sp,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFFF7B53A) : subTextColor),
                onPressed: onFavoriteToggle,
              ),
            ),
          ),

          // Arrow button
          Positioned(
            bottom: 56.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CA0C6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(Icons.arrow_outward, color: Colors.white, size: 20.sp),
              ),
            ),
          ),

          // Bottom info
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(18.r)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                fontSize: 15.sp, fontWeight: FontWeight.w600, color: textColor)),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 13.sp, color: subTextColor),
                            SizedBox(width: 3.w),
                            Text(location,
                                style: GoogleFonts.montserrat(fontSize: 11.sp, color: subTextColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: const Color(0xFFF7B53A), size: 15.sp),
                      SizedBox(width: 2.w),
                      Text(rating,
                          style: GoogleFonts.montserrat(
                              fontSize: 12.sp, fontWeight: FontWeight.w500, color: textColor)),
                    ],
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