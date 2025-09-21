import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flexpay/gen/colors.gen.dart';

class ChamaRegistrationPage extends StatefulWidget {
  const ChamaRegistrationPage({super.key});

  @override
  State<ChamaRegistrationPage> createState() => _ChamaRegistrationPageState();
}

class _ChamaRegistrationPageState extends State<ChamaRegistrationPage> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  // Validation state (UI only for now)
  String? firstNameError;
  String? lastNameError;
  String? idError;
  String? phoneError;
  String? dobError;
  String? genderError;

  String? gender;
  bool agreedToTerms = false;

  void _validateFields() {
    setState(() {
      firstNameError = firstNameController.text.trim().isEmpty
          ? "First name is required"
          : null;

      lastNameError = lastNameController.text.trim().isEmpty
          ? "Last name is required"
          : null;

      idError = idController.text.trim().isEmpty
          ? "ID number is required"
          : (!RegExp(r'^\d{6,10}$').hasMatch(idController.text.trim())
              ? "Enter a valid ID number"
              : null);

      phoneError = phoneController.text.trim().isEmpty
          ? "Phone number is required"
          : (!RegExp(r'^\d{10,13}$').hasMatch(phoneController.text.trim())
              ? "Enter a valid phone number"
              : null);

      dobError = null; // optional

      genderError = gender == null ? "Select your gender" : null;
    });
  }

  void _submit() {
    _validateFields();

    if (firstNameError == null &&
        lastNameError == null &&
        idError == null &&
        phoneError == null &&
        genderError == null &&
        agreedToTerms) {
      // For now, just show a snackbar since API isn’t hooked yet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form is valid, ready to send to API")),
      );
    }
  }

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
          "Chama Registration",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // First + Last Name
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: firstNameController,
                        label: "First Name",
                        hint: "John",
                        icon: Icons.person_outline,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: firstNameError,
                        onChanged: (_) => _validateFields(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: lastNameController,
                        label: "Last Name",
                        hint: "Doe",
                        icon: Icons.person_outline,
                        fieldColor: fieldColor,
                        textColor: textColor,
                        errorText: lastNameError,
                        onChanged: (_) => _validateFields(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ID Number
                _buildTextField(
                  controller: idController,
                  label: "ID Number",
                  hint: "12345678",
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  fieldColor: fieldColor,
                  textColor: textColor,
                  errorText: idError,
                  onChanged: (_) => _validateFields(),
                ),
                SizedBox(height: 12.h),

                // Phone
                _buildTextField(
                  controller: phoneController,
                  label: "Phone",
                  hint: "0712345678",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  fieldColor: fieldColor,
                  textColor: textColor,
                  errorText: phoneError,
                  onChanged: (_) => _validateFields(),
                ),
                SizedBox(height: 12.h),

                // DOB
                _buildDobField(
                  label: "Date of Birth (optional)",
                  controller: dobController,
                  fieldColor: fieldColor,
                  textColor: textColor,
                  errorText: dobError,
                  onChanged: (_) => _validateFields(),
                ),
                SizedBox(height: 12.h),

                // Gender
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Gender",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600, color: textColor)),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    _buildGenderButton("Male", Icons.male),
                    const SizedBox(width: 12),
                    _buildGenderButton("Female", Icons.female),
                  ],
                ),
                if (genderError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        genderError!,
                        style: GoogleFonts.montserrat(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ),
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
                SizedBox(height: 20.h),

                // Register button
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
                    onPressed: _submit,
                    child: Text(
                      "Register",
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
      ),
    );
  }

  // Helpers

  Widget _buildDobField({
    required String label,
    required TextEditingController controller,
    required Color fieldColor,
    required Color textColor,
    String? errorText,
    ValueChanged<String>? onChanged,
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
                  style:
                      GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
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
                          if (onChanged != null) onChanged(controller.text);
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
              onChanged: onChanged,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText,
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

  Widget _buildGenderButton(String label, IconData icon) {
    final isSelected = gender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            gender = label;
            _validateFields();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? ColorName.primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black87),
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
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
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
          onChanged: onChanged,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                errorText,
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
}