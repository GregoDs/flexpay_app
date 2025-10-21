import 'package:flexpay/features/home/cubits/home_cubit.dart';
import 'package:flexpay/features/home/cubits/home_states.dart';
import 'package:flexpay/features/payments/cubits/payments_cubit.dart';
import 'package:flexpay/features/payments/cubits/payments_state.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopUpHomePage extends StatefulWidget {

  const TopUpHomePage({
    super.key,
  });

  @override
  State<TopUpHomePage> createState() => _TopUpHomePageState();
}

class _TopUpHomePageState extends State<TopUpHomePage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? phoneError;
  String? amountError;

  void _validateFields() {
    setState(() {
      phoneError = phoneController.text.trim().isEmpty
          ? "Phone number is required"
          : null;

      amountError = amountController.text.trim().isEmpty
          ? "Enter an amount"
          : null;
    });
  }

  void _submit(BuildContext context) {
  _validateFields();

  if (phoneError == null && amountError == null) {
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    String phone = phoneController.text.trim();

    // ✅ Clean & Normalize the phone number
    if (phone.startsWith('0')) {
      // Replace starting 0 with +254 or 254 depending on backend format
      phone = '254${phone.substring(1)}';
    } else if (phone.startsWith('+254')) {
      // Remove '+' if backend expects plain 254
      phone = phone.replaceFirst('+', '');
    }

    context.read<PaymentsCubit>().topUpWalletViaMpesa(
          amount: amount,
          phoneNumber: phone,
        );
  }
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final fieldColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;

    final textTheme = GoogleFonts.montserratTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Top Up",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PaymentsCubit, PaymentsState>(
            listener: (context, state) {
              if (state is WalletTopUpSuccess) {
                CustomSnackBar.showSuccess(
                  context,
                  title: "Success",
                  message: "Wait for Mpesa confirmation to top up",
                );

                // 🔄 Refresh wallet balance after refund
                context.read<HomeCubit>().fetchUserWallet();
              } else if (state is WalletTopUpFailure) {
                CustomSnackBar.showError(
                  context,
                  title: "Error",
                  message: state.message,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {

            final isLoading = context.watch<PaymentsCubit>().state is WalletTopUpLoading;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Info text
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              color: ColorName.primaryColor, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Top Up to your wallet via M-Pesa to facilitate easy purchases on the Flexpay ecosystem.",
                              style: GoogleFonts.montserrat(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      /// Mpesa target
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: fieldColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.phone_android,
                              color: ColorName.primaryColor,
                              size: 60,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "M-Pesa",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 28.h),

                      /// Phone Number
                      _buildTextField(
                        controller: phoneController,
                        label: "Phone Number",
                        hint: "Enter phone number",
                        icon: Icons.phone_outlined,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: phoneError,
                        keyboardType: TextInputType.phone,
                        onChanged: (_) => _validateFields(),
                      ),
                      SizedBox(height: 16.h),

                      /// Amount
                      _buildTextField(
                        controller: amountController,
                        label: "Enter Amount (KES)",
                        hint: "e.g. 500",
                        icon: Icons.payments_outlined,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: amountError,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _validateFields(),
                      ),
                      SizedBox(height: 28.h),

                      /// Top up button
                      SizedBox(
                        width: double.infinity,
                        child: isLoading
                            ? Center(
                                child: SpinKitWave(
                                  color: ColorName.primaryColor,
                                  size: 30,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorName.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: () => _submit(context),
                                child: Text(
                                  "Top Up",
                                  style: textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(icon, color: ColorName.primaryColor),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText!,
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }
