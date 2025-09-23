import 'package:flexpay/features/flexchama/ui/chama_reg.dart';
import 'package:flexpay/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

class OnBoardFlexChama extends StatelessWidget {
  final String? message;
  final VoidCallback onOptIn;
  final UserModel userModel;

  const OnBoardFlexChama({
    Key? key,
    this.message,
    required this.onOptIn,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final textTheme = GoogleFonts.montserratTextTheme(
      Theme.of(context).textTheme,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/optflexchama.png',
              fit: BoxFit.cover,
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF003638).withOpacity(0.9),
                    const Color(0xFF337687).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Top-right Close Button → Go to Home
          // Positioned(
          //   top: 52,
          //   right: 24,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) =>
          //               NavigationWrapper(userModel: userModel, initialIndex: 0),
          //         ),
          //       );
          //     },
          //     child: Container(
          //       padding: const EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(0.85),
          //         shape: BoxShape.circle,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black26,
          //             blurRadius: 6,
          //             offset: const Offset(0, 3),
          //           ),
          //         ],
          //       ),
          //       child: const Icon(Icons.close, color: Colors.black87, size: 22),
          //     ),
          //   ),
          // ),

          // Bottom Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: 28,
              ),
              decoration: BoxDecoration(
                // color: Colors.black.withOpacity(0.4),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message ??
                        "FlexChama allows you to save for either 6 or 12 months. As you save, you earn up to 10% returns on your savings and can access emergency loans from 80% up to 3x your savings.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Opt In Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.registerChama);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorName.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Opt In",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NavigationWrapper(
                            userModel: userModel,
                            initialIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Maybe Later",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
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
