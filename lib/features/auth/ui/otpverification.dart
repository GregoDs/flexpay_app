import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/cubit/auth_state.dart';
import 'package:flexpay/features/home/ui/homescreen.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  String? _phoneNumber;
  bool _isLoading = false;
  bool _isSnackBarShowing = false;
  bool _isResendingOtp = false;
  bool _isVerifyingOtp = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phone_number');
    });
  }

  void onOtpCompleted(String otp) {
    if (_phoneNumber != null) {
      setState(() {
        _isLoading = true;
        _isVerifyingOtp = true;
      });
      authCubit.verifyOtp(_phoneNumber!, otp);
    }
  }

  void _resendOtp() {
    if (_phoneNumber != null) {
      setState(() {
        _isResendingOtp = true;
      });
      authCubit.requestOtp(_phoneNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final availableHeight = size.height - padding.top - padding.bottom;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1A1A) : ColorName.whiteColor,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthUserUpdated) {
              if (_isVerifyingOtp) {
                setState(() {
                  _isVerifyingOtp = false;
                  _isLoading = false;
                });

                // Navigate to the HomeScreen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      isDarkModeOn:
                          Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                );
              }
            } else if (state is AuthOtpSent) {
              setState(() {
                _isResendingOtp = false;
                _isLoading = false;
              });
              CustomSnackBar.showSuccess(
                context,
                title: 'Success',
                message: state.message,
              );
            } else if (state is AuthError && !_isSnackBarShowing) {
              setState(() {
                _isSnackBarShowing = true;
                _isResendingOtp = false;
                _isLoading = false;
                _isVerifyingOtp = false;
              });

              CustomSnackBar.showError(
                context,
                title: 'Error',
                message: state.errorMessage,
                actionLabel: 'Dismiss',
                onAction: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  setState(() {
                    _isSnackBarShowing = false;
                  });
                },
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                height: availableHeight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                      ),
                      child: Lottie.asset(
                        "assets/images/otpver.json",
                        height: availableHeight * 0.3,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? ColorName.primaryColor.withOpacity(0.2)
                            : ColorName.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "OTP Verification",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : ColorName.primaryColor,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Enter the OTP sent to",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isDarkMode ? Colors.grey[400] : ColorName.mainGrey,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phoneNumber ?? "+00-0000-000-0000",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : ColorName.blackColor,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 32),
                    PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 65,
                        fieldWidth: 60,
                        activeFillColor:
                            isDarkMode ? Colors.grey[800] : Colors.white,
                        inactiveFillColor:
                            isDarkMode ? Colors.grey[900] : Colors.white,
                        selectedFillColor:
                            isDarkMode ? Colors.grey[800] : Colors.white,
                        activeColor: ColorName.primaryColor,
                        inactiveColor:
                            isDarkMode ? Colors.grey[700] : ColorName.lightGrey,
                        selectedColor: ColorName.primaryColor,
                      ),
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : ColorName.blackColor,
                        fontFamily: 'Montserrat',
                      ),
                      cursorColor: ColorName.primaryColor,
                      enableActiveFill: true,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      onCompleted: onOtpCompleted,
                      beforeTextPaste: (text) => true,
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: _isResendingOtp ? null : _resendOtp,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isResendingOtp
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorName.blue200),
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.refresh,
                                    size: 18, color: ColorName.blue200),
                                SizedBox(width: 8),
                                Text(
                                  "Resend OTP",
                                  style: TextStyle(
                                    color: ColorName.blue200,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
