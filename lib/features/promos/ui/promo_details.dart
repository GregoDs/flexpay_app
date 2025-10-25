import 'package:flexpay/features/promos/ui/modals/debit_modal.dart';
import 'package:flexpay/features/promos/ui/modals/transfer_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoCardDetailPage extends StatefulWidget {
  final Map<String, dynamic> merchant;
  final double balance;

  const PromoCardDetailPage({
    super.key,
    required this.merchant,
    required this.balance,
  });

  @override
  State<PromoCardDetailPage> createState() => _PromoCardDetailPageState();
}

class _PromoCardDetailPageState extends State<PromoCardDetailPage> {
  bool _hideBalance = false;

  @override
void initState() {
  super.initState();
  _hideBalance = true; // 👈 Always hide balance when entering this page
}

  @override
  Widget build(BuildContext context) {
    final merchant = widget.merchant;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1113) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header - matches screenshot exactly
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIcon(
                    context,
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "CARD DETAILS",
                    style: GoogleFonts.montserrat(
                      color: isDark ? Colors.white : const Color(0xFF1D2935),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: isDark ? Colors.white : const Color(0xFF1D2935),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // 🔹 Main content row - matches screenshot layout
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left vertical action buttons - matches screenshot
                    Column(
                      children: [
                        _buildActionButton(
                        icon: Icons.transfer_within_a_station,
                        label: "Transfer",
                        isDark: isDark,
                        onTap: () {
                          showKapuTransferModalSheet(
                            context,
                            fromMerchantId: widget.merchant['merchant_id'].toString(),
                          );
                        },
                      ),
                        SizedBox(height: 20.h),
                        _buildActionButton(
                            icon: Icons.edit_outlined,
                            label: "Deposit",
                            isDark: isDark,
                            onTap: () {
                              showKapuDebitModalSheet(
                                context,
                                merchantId: widget.merchant['merchant_id'].toString(),
                              );
                            },
                          ),
                        SizedBox(height: 20.h),
                        _buildActionButton(
                          icon: _hideBalance ? Icons.visibility : Icons.visibility_off,
                          label: _hideBalance ? "Show Info" : "Hide Info",
                          isDark: isDark,
                          onTap: () {
                            setState(() {
                              _hideBalance = !_hideBalance;
                            });
                          },
                        ),
                      ],
                    ),
                   

                    SizedBox(width: 20.w),

                    // Right side — Hero card positioned at far right, partially visible
                    Expanded(
                      child: Hero(
                        tag: 'kapu_card_${merchant['merchant_id']}',
                        child: Container(
                          height: 210.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _shadeColor(
                                  merchant['color'],
                                  0.85,
                                ).withOpacity(0.98),
                                _shadeColor(
                                  merchant['color'],
                                  1.12,
                                ).withOpacity(0.95),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: merchant['color'].withOpacity(0.4),
                                blurRadius: 25,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20.w),
                          child: Stack(
                            children: [
                              // Pattern overlay
                              Positioned.fill(
                                child: Opacity(
                                  opacity: isDark ? 0.04 : 0.06,
                                  child: Image.asset(
                                    'assets/images/home_images/promo_card_pattern.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Card chip and contactless icons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 24.w,
                                            height: 18.h,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.wifi,
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            size: 16.sp,
                                          ),
                                        ],
                                      ),
                                      // Text(
                                      //   "VISA",
                                      //   style: GoogleFonts.montserrat(
                                      //     color: Colors.white,
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 14.sp,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),

                                  // Card number
                                  // Text(
                                  //   "3456 1234 8765 0982",
                                  //   style: GoogleFonts.montserrat(
                                  //     color: Colors.white,
                                  //     fontSize: 16.sp,
                                  //     fontWeight: FontWeight.w500,
                                  //   ),
                                  // ),
                                  SizedBox(height: 26.h),

                                  // Balance - hides or shows based on _hideBalance
                                    Material(
                                      type: MaterialType.transparency,
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 350),
                                        switchInCurve: Curves.easeOut,
                                        switchOutCurve: Curves.easeIn,
                                        child: _hideBalance
                                            ? Text(
                                                "•••••••",
                                                key: const ValueKey("hidden_balance"),
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white70,
                                                  fontSize: 26.sp,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 2,
                                                ),
                                              )
                                            : Text(
                                                "Ksh ${widget.balance.toStringAsFixed(2)}",
                                                key: const ValueKey("visible_balance"),
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 26.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),

                                  // Merchant name - matches screenshot font size
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      merchant['name'],
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Card Info section - matches screenshot styling
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "CARD INFORMATION",
                    style: GoogleFonts.montserrat(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  // Hide Info button - matches screenshot position and styling
                  GestureDetector(
                    onTap: () => setState(() => _hideBalance = !_hideBalance),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _hideBalance
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _hideBalance ? "Show info" : "Hide info",
                            style: GoogleFonts.montserrat(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildInfoRow("Merchant", merchant['name'], isDark),
              _buildInfoRow(
                "Balance",
                _hideBalance
                    ? "•••••••"
                    : "Ksh ${widget.balance.toStringAsFixed(2)}",
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildActionButton({
  required IconData icon,
  required String label,
  required bool isDark,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white : Colors.black54,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}




  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 13.sp,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create lighter/darker shades
  Color _shadeColor(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

Widget _circleIcon(
  BuildContext context, {
  required IconData icon,
  required VoidCallback onTap,
}) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
