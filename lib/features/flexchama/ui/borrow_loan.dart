import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/ui/shimmer_chama_products.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void showBorrowLoanModalSheet(BuildContext context) {
  final TextEditingController amountController = TextEditingController();
  final chamaCubit = context.read<ChamaCubit>();

  bool loanSuccess = false;
  String? loanSuccessMessage;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return BlocProvider.value(
        value: chamaCubit,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: BlocConsumer<ChamaCubit, ChamaState>(
            listener: (context, state) {
              // Wait for ChamaSavingsFetched after loan request
              if (loanSuccess && state is ChamaSavingsFetched) {
                Navigator.pop(context);
                // Trigger a fetch on the parent context after popping
                Future.microtask(() {
                  final parentContext = Navigator.of(
                    context,
                    rootNavigator: true,
                  ).context;
                  try {
                    parentContext.read<ChamaCubit>().fetchChamaUserSavings();
                  } catch (_) {
                    try {
                      context.read<ChamaCubit>().fetchChamaUserSavings();
                    } catch (_) {}
                  }
                });
                CustomSnackBar.showSuccess(
                  context,
                  title: "Loan Request Sent",
                  message:
                      "✅ ${loanSuccessMessage ?? 'Your loan request was submitted successfully!'}",
                );
                loanSuccess = false;
                loanSuccessMessage = null;
              } else if (state is RequestChamaLoanSuccess) {
                loanSuccess = true;
                loanSuccessMessage = state.response.message;
                // Do not pop yet, wait for ChamaSavingsFetched
              } else if (state is RequestChamaLoanFailure) {
                Navigator.pop(context);
                // Always trigger a fetch on the parent context after popping (even on failure)
                Future.microtask(() {
                  final parentContext = Navigator.of(
                    context,
                    rootNavigator: true,
                  ).context;
                  try {
                    parentContext.read<ChamaCubit>().fetchChamaUserSavings();
                  } catch (_) {
                    try {
                      context.read<ChamaCubit>().fetchChamaUserSavings();
                    } catch (_) {}
                  }
                });
                CustomSnackBar.showError(
                  context,
                  title: "Loan Request Failed",
                  message: "⚠️ ${state.message}",
                );
                loanSuccess = false;
                loanSuccessMessage = null;
              }
            },
            builder: (context, state) {
              final isLoading = state.runtimeType.toString().endsWith(
                'Loading',
              );

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header indicator bar
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Title
                    Text(
                      "Request a Loan",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // --- Info Text
                    Text(
                      "Enter the amount you’d like to borrow. Your request will be reviewed and processed based on your Chama loan limit.",
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- Quick Amount Chips
                    Text(
                      "Quick Amounts",
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
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

                    // --- Input Field
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.montserrat(),
                      decoration: InputDecoration(
                        hintText: "Enter amount to borrow",
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefixIcon: Icon(
                          Icons.money_outlined,
                          color: Colors.blue[800],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
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
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                final amount = amountController.text.trim();
                                if (amount.isEmpty) {
                                  CustomSnackBar.showError(
                                    context,
                                    title: "Missing Amount",
                                    message: "Please enter a loan amount",
                                  );
                                  return;
                                }

                                final parsedAmount = double.tryParse(amount);
                                if (parsedAmount == null || parsedAmount <= 0) {
                                  CustomSnackBar.showError(
                                    context,
                                    title: "Invalid Amount",
                                    message: "Please enter a valid amount",
                                  );
                                  return;
                                }

                                context.read<ChamaCubit>().requestChamaLoan(
                                  amount: parsedAmount,
                                );
                              },
                        child: isLoading
                            ? const SpinKitWave(
                                color: Colors.white,
                                size: 22.0,
                              )
                            
                            : Text(
                                "Submit Loan Request",
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

Widget _amountChip(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[800]!, width: 1),
      ),
      child: Text(
        "Ksh $label",
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.blue[800],
        ),
      ),
    ),
  );
}
