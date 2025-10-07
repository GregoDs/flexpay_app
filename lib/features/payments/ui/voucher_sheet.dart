import 'package:flexpay/features/payments/cubits/payments_cubit.dart';
import 'package:flexpay/features/payments/cubits/payments_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class VoucherModalSheet extends StatelessWidget {
  const VoucherModalSheet({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Buy a shopping voucher',
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            // later: maybe show all vouchers page
          },
          child: Text(
            'View All',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
void showMerchantVoucherModal(
  BuildContext context,
  String merchantName,
  int merchantId,
) {
  final TextEditingController amountController = TextEditingController();
  final paymentsCubit = context.read<PaymentsCubit>();

  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: paymentsCubit,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: BlocConsumer<PaymentsCubit, PaymentsState>(
            listener: (context, state) {
              if (state is VoucherSuccess) {
                Navigator.pop(context);
                CustomSnackBar.showSuccess(
                  context,
                  title: "Success!",
                  message: "✅ Voucher created successfully!",
                );
              } else if (state is VoucherFailure) {
                Navigator.pop(context);
                CustomSnackBar.showError(
                  context,
                  title: "Voucher creation Failed",
                  message: "⚠️ ${state.message}",
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is VoucherLoading;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[700] : Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      "Create Voucher Goal",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Text(
                      "Quick Amounts",
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: [
                        for (final amt in [
                          "5,000",
                          "10,000",
                          "20,000",
                          "50,000",
                          "100,000",
                        ])
                          _voucherChip(
                            amt,
                            () => amountController.text = amt.replaceAll(",", ""),
                            isDark,
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter amount",
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor:
                            isDark ? Colors.grey[850] : Colors.grey[200],
                        prefixIcon: Icon(
                          Icons.payments_outlined,
                          color: isDark ? Colors.blue[300] : Colors.blue[800],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Text(
                      "This voucher can only be redeemed for any $merchantName products at any $merchantName outlet countrywide.",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: isDark ? Colors.red[300] : Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                final amount = amountController.text.trim();
                                if (amount.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter amount"),
                                    ),
                                  );
                                  return;
                                }

                                context.read<PaymentsCubit>().generateVoucher(
                                      merchantId: merchantId,
                                      voucherAmount: amount,
                                    );
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Generate Voucher",
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
          ),
        ),
      );
    },
  );
}

Widget _voucherChip(String label, VoidCallback onTap, bool isDark) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.blue[300]! : Colors.blue[800]!,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.blue[300] : Colors.blue[800],
        ),
      ),
    ),
  );
}