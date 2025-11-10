import 'package:flexpay/features/kapu/cubits/kapu_cubit.dart';
import 'package:flexpay/features/kapu/cubits/kapu_state.dart';
import 'package:flexpay/features/kapu/models/kapu_booking_model/kapu_booking_model.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

void showKapuTopUpModalSheet(
  BuildContext context, {
  required String initialPhoneNumber, // 👈 renamed for clarity
  required BookingData booking,
}) {
  final TextEditingController phoneController =
      TextEditingController(text: initialPhoneNumber);
  final TextEditingController amountController = TextEditingController();
  final kapuCubit = context.read<KapuCubit>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: ColorName.primaryColor,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        child: BlocProvider.value(
          value: kapuCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 20.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return BlocConsumer<KapuCubit, KapuState>(
                  listener: (context, state) {
                    if (state is KapuTopUpSuccess) {
                      Navigator.pop(context);
                      CustomSnackBar.showInfo(
                        context,
                        title: "Initiating Mpesa Stk prompt",
                        message:
                            "Kindly wait for the Stk prompted.....",
                      );
                    } else if (state is KapuTopUpFailure) {
                      Navigator.pop(context);
                      CustomSnackBar.showError(
                        context,
                        title: "Top-Up Failed",
                        message: "⚠️ ${state.message}",
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is KapuTopUpLoading;

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Header indicator
                          Center(
                            child: Container(
                              width: 50.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // --- Title
                          Text(
                            "Top-Up Kapu Wallet",
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          Text(
                            "Enter your phone number and amount to top-up your Kapu wallet.",
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // --- PHONE INPUT FIELD 👇
                          TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.montserrat(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter phone number (e.g. 2547XXXXXXXX)",
                              hintStyle: GoogleFonts.montserrat(
                                color: Colors.grey[600],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.phone_outlined,
                                color: ColorName.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                borderSide: BorderSide(
                                  color: ColorName.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // --- QUICK AMOUNTS
                          Text(
                            "Quick Amounts",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          Wrap(
                            spacing: 12.w,
                            runSpacing: 12.h,
                            children: [
                              for (final amt in ["100", "500", "1000", "5000", "10000"])
                                _amountChip(amt, () {
                                  amountController.text = amt;
                                }),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // --- AMOUNT INPUT FIELD
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.montserrat(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter amount to top-up",
                              hintStyle: GoogleFonts.montserrat(
                                color: Colors.grey[600],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: ColorName.primaryColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: ColorName.primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),

                          // --- SUBMIT BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorName.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 3,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                              ),
                              onPressed: isLoading
                                ? null
                                : () {
                                    final amountText = amountController.text.trim();
                                    final rawPhone = phoneController.text.trim();
                                    final parsedAmount = double.tryParse(amountText);

                                    // --- Validate and normalize phone number ---
                                    if (rawPhone.isEmpty) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Invalid Phone Number",
                                        message: "Please enter your phone number.",
                                      );
                                      return;
                                    }

                                    // Allow both 07xxxxxxx and 2547xxxxxxx, but always send 2547xxxxxxx
                                    String formattedPhone = rawPhone;
                                    if (rawPhone.startsWith("07")) {
                                      formattedPhone = "254${rawPhone.substring(1)}";
                                    } else if (rawPhone.startsWith("+254")) {
                                      formattedPhone = rawPhone.substring(1); // remove +
                                    } else if (!rawPhone.startsWith("254")) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Invalid Phone Number",
                                        message: "Phone must start with 07 or 254.",
                                      );
                                      return;
                                    }

                                    if (formattedPhone.length != 12) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Invalid Phone Number",
                                        message: "Phone number should be 12 digits (e.g., 2547XXXXXXXX).",
                                      );
                                      return;
                                    }

                                    // --- Validate amount ---
                                    if (parsedAmount == null || parsedAmount <= 0) {
                                      CustomSnackBar.showError(
                                        context,
                                        title: "Invalid Amount",
                                        message: "Please enter a valid top-up amount.",
                                      );
                                      return;
                                    }

                                    // --- Proceed with top-up ---
                                    context.read<KapuCubit>().topUpKapuWallet(
                                          amount: parsedAmount,
                                          phoneNumber: formattedPhone, // 👈 always 2547xxxxxxxx
                                          booking: booking,
                                        );
                                  },
                              child: isLoading
                                  ? const SpinKitWave(
                                      color: Colors.white,
                                      size: 22.0,
                                    )
                                  : Text(
                                      "Top-Up Now",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Widget _amountChip(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorName.primaryColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        "Ksh $label",
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: ColorName.primaryColor,
        ),
      ),
    ),
  );
}