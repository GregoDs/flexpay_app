import 'package:flexpay/features/promos/cubits/kapu_cubit.dart';
import 'package:flexpay/features/promos/cubits/kapu_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';




Future<bool?> showKapuTransferModalSheet(
  BuildContext context, {
  required String fromMerchantId,
}) async {
  final TextEditingController amountController = TextEditingController();
  final kapuCubit = context.read<KapuCubit>();

  final List<Map<String, dynamic>> merchants = [
    {'name': 'Jaza', 'merchant_id': '403', 'color': const Color(0xFF761B1A)},
    {'name': 'Quickmart Supermarket', 'merchant_id': '347', 'color': const Color(0xFF111111)},
    {'name': 'Naivas Supermarket', 'merchant_id': '107', 'color': const Color(0xFFFFB020)},
    {'name': 'HotPoint Appliances', 'merchant_id': '73', 'color': const Color(0xFFCD0000)},
    {'name': 'Azone Supermarket', 'merchant_id': '252', 'color': const Color(0xFF6C63FF)},
    {'name': 'Open Wallet', 'merchant_id': '4', 'color': const Color(0xFF00A86B)},
  ];

  String? selectedMerchantId;
  String? selectedMerchantName;

  return showModalBottomSheet<bool>(  // ✅ Add <bool> type
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
          dropdownMenuTheme: const DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
            ),
          ),
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
                    if (state is KapuTransferSuccess) {
                      Future.delayed(
                        const Duration(milliseconds: 600),
                        () async {
                          await kapuCubit.fetchKapuWalletBalance(fromMerchantId);
                          if (selectedMerchantId != null) {
                            await kapuCubit.fetchKapuWalletBalance(selectedMerchantId!);
                          }
                        },
                      );
                      Navigator.pop(context, true); // ✅ Return true on success
                      CustomSnackBar.showSuccess(
                        context,
                        title: "Transfer Successful",
                        message: "✅ ${state.response.message}",
                      );
                    } else if (state is KapuTransferFailure) {
                      Navigator.pop(context, false); // ✅ Return false on failure
                      CustomSnackBar.showError(
                        context,
                        title: "Transfer Failed",
                        message: "⚠️ ${state.message}",
                      );
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is KapuTransferLoading;
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
                            "Transfer Funds",
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // --- Description
                          Text(
                            "Send money securely from your Kapu merchant wallet to another merchant. Choose the recipient and enter amount.",
                            style: GoogleFonts.montserrat(
                              fontSize: 13.sp,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // --- Recipient Merchant Dropdown
                          Text(
                            "Select Recipient Merchant",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white, // always white
                                value: selectedMerchantName,
                                isExpanded: true,
                                hint: Text(
                                  "Select merchant",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: ColorName.primaryColor,
                                ),
                                items: merchants.map((merchant) {
                                  return DropdownMenuItem<String>(
                                    value: merchant['name'],
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 10.w,
                                          height: 10.w,
                                          decoration: BoxDecoration(
                                            color: merchant['color'],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          merchant['name'],
                                          style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMerchantName = value;
                                    selectedMerchantId = merchants.firstWhere(
                                      (m) => m['name'] == value,
                                    )['merchant_id'];
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // --- Quick Amounts
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
                              for (final amt in [
                                "500",
                                "1000",
                                "5000",
                                "10000",
                                "20000",
                              ])
                                _amountChip(amt, () {
                                  amountController.text = amt;
                                }),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // --- Amount Input Field
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.montserrat(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Enter amount to transfer",
                              hintStyle: GoogleFonts.montserrat(
                                color: Colors.grey[600],
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(
                                Icons.payments_outlined,
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

                          // --- Submit Button
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
                                      final amountText = amountController.text
                                          .trim();

                                      if (selectedMerchantId == null) {
                                        CustomSnackBar.showError(
                                          context,
                                          title: "Missing Merchant",
                                          message:
                                              "Please select a recipient merchant.",
                                        );
                                        return;
                                      }

                                      final parsedAmount = double.tryParse(
                                        amountText,
                                      );
                                      if (parsedAmount == null ||
                                          parsedAmount <= 0) {
                                        CustomSnackBar.showError(
                                          context,
                                          title: "Invalid Amount",
                                          message:
                                              "Please enter a valid transfer amount.",
                                        );
                                        return;
                                      }

                                      context.read<KapuCubit>().transferFunds(
                                        fromMerchantId: fromMerchantId,
                                        toMerchantId: selectedMerchantId!,
                                        amount: parsedAmount,
                                      );
                                    },
                              child: isLoading
                                  ? const SpinKitWave(
                                      color: Colors.white,
                                      size: 22.0,
                                    )
                                  : Text(
                                      "Transfer Now",
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
