import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';


class BookingPaymentModal {
  static Future<void> show(
    BuildContext context, {
    required String bookingName,
    required String initialPhone,
  }) async {
    final amountController = TextEditingController();

    /// Fetch user model to get stored phone number
    final userModel = await SharedPreferencesHelper.getUserModel();
    final prefilledPhone = userModel?.user.phoneNumber ?? initialPhone;

    final phoneController = TextEditingController(text: prefilledPhone);

    // ✅ Default to M-Pesa
    String selectedSource = "M-Pesa";

    final fieldColor = const Color(0xFFF3F4F6);
    final textColor = Colors.black87;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 22.h,
                        horizontal: 16.w,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF009AC1), Color(0xFF1D3C4E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.payment, size: 40.sp, color: Colors.white),
                          SizedBox(height: 8.h),
                          Text(
                            "Pay for $bookingName",
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Choose payment method and enter details",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Body
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Payment Method
                          Text(
                            "Payment Method",
                            style: GoogleFonts.montserrat(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _PaymentOptionCard(
                                imagePath:
                                    "assets/images/payment_platform/mpesa_img.png",
                                label: "M-Pesa",
                                isSelected: selectedSource == "M-Pesa",
                                onTap: () => setState(() {
                                  selectedSource = "M-Pesa";
                                }),
                              ),
                              _PaymentOptionCard(
                                imagePath:
                                    "assets/images/payment_platform/wallet_img.webp",
                                label: "Wallet",
                                isSelected: selectedSource == "Wallet",
                                onTap: () => setState(() {
                                  selectedSource = "Wallet";
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Phone Number (only for M-Pesa)
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child: selectedSource == "M-Pesa"
                                ? Column(
                                    key: const ValueKey("mpesaField"),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Phone Number",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      TextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: GoogleFonts.montserrat(
                                            color: textColor),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: fieldColor,
                                          prefixIcon: Icon(Icons.phone,
                                              color: Colors.blue[800]),
                                          hintText: "Enter phone number",
                                          hintStyle: GoogleFonts.montserrat(
                                              color: Colors.grey),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),

                          // Amount
                          Text(
                            "Amount",
                            style: GoogleFonts.montserrat(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.montserrat(color: textColor),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fieldColor,
                              prefixIcon: Icon(Icons.currency_exchange,
                                  color: Colors.blue[800]),
                              hintText: "Enter amount",
                              hintStyle:
                                  GoogleFonts.montserrat(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 28.h),

                          // Make Payment
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: () {
                                final amount = double.tryParse(
                                  amountController.text.trim(),
                                );
                                final phone = phoneController.text.trim();

                                if (amount == null || amount <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Enter valid amount")),
                                  );
                                  return;
                                }

                                if (selectedSource == "M-Pesa" &&
                                    phone.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Enter phone number")),
                                  );
                                  return;
                                }

                                debugPrint(
                                    "📤 Payment: $amount via $selectedSource, phone=$phone");
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF009AC1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              child: Text(
                                "Make Payment",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PaymentOptionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionCard({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),

            // ✅ Only add border if selected
            border: isSelected
                ? Border.all(
                    color: Colors.amber,
                    width: 2.5,
                  )
                : null,

            // ✅ Only add shadow if selected
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: AnimatedScale(
            scale: isSelected ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                Image.asset(imagePath, width: 75.w, height: 85.w),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.amber[800] : Colors.black87,
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
