import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? gender;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final textTheme =
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme);

    final fieldColor = isDark ? Colors.grey[850]! : Colors.grey[200]!;
    final textColor = isDark ? Colors.white : Colors.black87;

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
          "Create Account",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Fields
                  Column(
                    children: [
                      // First + Last Name
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: firstNameController,
                              label: "First Name",
                              hint: "George",
                              icon: Icons.person_outline,
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: lastNameController,
                              label: "Last Name",
                              hint: "Kiplagat",
                              icon: Icons.person_outline,
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      _buildTextField(
                        controller: emailController,
                        label: "Email",
                        hint: "example@email.com",
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        fieldColor: fieldColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 12.h),

                      _buildTextField(
                        controller: phoneController,
                        label: "Phone",
                        hint: "0712345678",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        fieldColor: fieldColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 12.h),

                      // DOB
                      _buildDobField(
                        label: "Date of Birth",
                        controller: dobController,
                        fieldColor: fieldColor,
                        textColor: textColor,
                      ),
                      SizedBox(height: 12.h),

                      // Gender
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Gender",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                color: textColor)),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          _buildGenderButton("Male", Icons.male),
                          const SizedBox(width: 12),
                          _buildGenderButton("Female", Icons.female),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Passwords
                      Row(
                        children: [
                          Expanded(
                            child: _buildPasswordField(
                              controller: passwordController,
                              label: "Password",
                              hint: "Enter password",
                              visible: passwordVisible,
                              toggleVisibility: () =>
                                  setState(() => passwordVisible = !passwordVisible),
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPasswordField(
                              controller: confirmPasswordController,
                              label: "Confirm Password",
                              hint: "Re-enter password",
                              visible: confirmPasswordVisible,
                              toggleVisibility: () => setState(() =>
                                  confirmPasswordVisible = !confirmPasswordVisible),
                              fieldColor: fieldColor,
                              textColor: textColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Terms
                      Row(
                        children: [
                          Checkbox(
                            value: agreedToTerms,
                            activeColor: ColorName.primaryColor,
                            onChanged: (val) =>
                                setState(() => agreedToTerms = val ?? false),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text("I agree to the ",
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: textColor)),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Terms & Conditions",
                                    style: textTheme.bodySmall?.copyWith(
                                      color: ColorName.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(" and Privacy Policy",
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: textColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Sign up button + already have account
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorName.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: agreedToTerms
                              ? () {
                                  // Handle sign up
                                }
                              : null,
                          child: Text(
                            "Sign Up",
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ",
                              style: textTheme.bodyMedium?.copyWith(
                                color: textColor,
                              )),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushReplacementNamed(context, '/login'),
                            child: Text(
                              "Sign In",
                              style: textTheme.bodyMedium?.copyWith(
                                color: ColorName.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- same helpers as before (dob, gender, text/password fields) ---
  Widget _buildDobField({
    required String label,
    required TextEditingController controller,
    required Color fieldColor,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
            await showModalBottomSheet(
              context: context,
              builder: (_) {
                return DefaultTextStyle(
                  style: GoogleFonts.montserrat(
                      fontSize: 18, color: Colors.black),
                  child: SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime(2000, 1, 1),
                      maximumDate: DateTime.now(),
                      onDateTimeChanged: (date) {
                        setState(() {
                          controller.text =
                              "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              style: GoogleFonts.montserrat(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: fieldColor,
                prefixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.blue[800]),
                hintText: "yyyy-MM-dd",
                hintStyle: GoogleFonts.montserrat(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, IconData icon) {
    final isSelected = gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => gender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? ColorName.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? Colors.white : Colors.black87),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color fieldColor,
    required Color textColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.montserrat(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(icon, color: Colors.blue[800]),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool visible,
    required VoidCallback toggleVisibility,
    required Color fieldColor,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: !visible,
          style: GoogleFonts.montserrat(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldColor,
            prefixIcon: Icon(Icons.lock_outline, color: Colors.blue[800]),
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                visible ? Icons.visibility : Icons.visibility_off,
                color: Colors.blue[800],
              ),
              onPressed: toggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}