import 'package:flexpay/features/auth/cubit/auth_cubit.dart';
import 'package:flexpay/features/auth/cubit/auth_state.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isSnackBarShowing = false; // Flag to track if a SnackBar is showing

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final textTheme =
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is AuthOtpSent) {
              if (ModalRoute.of(context)?.settings.name != Routes.otp) {
                setState(() {
                  _isLoading = false;
                });
                CustomSnackBar.showSuccess(
                  context,
                  title: 'Success',
                  message: state.message,
                );
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pushNamed(context, Routes.otp);
                });
              }
            } else if (state is AuthError && !_isSnackBarShowing) {
              setState(() {
                _isLoading = false;
                _isSnackBarShowing = true;
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
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/onboardingSlide1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  Text(
                    "Sign In to Flexpay",
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: screenWidth * 0.090,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "We provide top-quality services and support for your needs.",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: screenWidth * 0.040,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  TextFormField(
                    controller: phoneController,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: screenWidth * 0.045,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                      labelText: "Phone Number",
                      hintText: "Enter your phone number",
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: screenWidth * 0.045,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        borderSide: BorderSide(
                          color: isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        borderSide: BorderSide(
                          color: ColorName.primaryColor,
                        ),
                      ),
                      filled: isDarkMode,
                      fillColor: isDarkMode ? Colors.grey[900] : null,
                    ),
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              // Handle Forgot Password
                            },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: screenWidth * 0.04,
                          color: const Color(0xFF337687),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorName.primaryColor,
                        elevation: isDarkMode ? 2 : 5,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              final phoneNumber = phoneController.text.trim();
                              if (phoneNumber.isNotEmpty) {
                                SharedPreferences.getInstance().then((prefs) {
                                  prefs.setString('phone_number', phoneNumber);
                                });

                                context
                                    .read<AuthCubit>()
                                    .requestOtp(phoneNumber);
                              } else {
                                CustomSnackBar.showError(
                                  context,
                                  title: 'Error',
                                  message: 'Please enter your phone number',
                                );
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Sign in",
                              style: textTheme.titleMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.register);
                            },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: screenWidth * 0.045,
                          color: ColorName.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
