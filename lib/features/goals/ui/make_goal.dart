import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MakeGoalPage extends StatefulWidget {
  final Map<String, dynamic> goal;
  const MakeGoalPage({Key? key, required this.goal}) : super(key: key);

  @override
  State<MakeGoalPage> createState() => _MakeGoalPageState();
}

class _MakeGoalPageState extends State<MakeGoalPage> {
  String? selectedSex;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color bgColor = isDark ? Colors.black : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF22343C);
    final Color fieldColor = isDark ? Colors.grey[900]! : const Color(0xFFF6F7F9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18.h),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Make Goal",
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Center(
                child: Text(
                  widget.goal["title"] ?? "Create Goal",
                  style: GoogleFonts.montserrat(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              _buildLabel("Goal Name"),
              _buildField("Enter Goal Name"),
              SizedBox(height: 24.h),
              _buildLabel("Target Amount"),
              _buildField("Enter Amount"),
              SizedBox(height: 24.h),
              _buildLabel("Target Date"),
              Row(
                children: [
                  Expanded(child: _buildDropdown("Day", ["1", "2", "3"], (v) => setState(() => selectedDay = v))),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildDropdown("Month", ["Jan", "Feb", "Mar"], (v) => setState(() => selectedMonth = v))),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildDropdown("Year", ["2024", "2025"], (v) => setState(() => selectedYear = v))),
                ],
              ),
              SizedBox(height: 24.h),
              _buildLabel("Goal Type"),
              Row(
                children: [
                  _buildSexButton("Personal"),
                  SizedBox(width: 16.w),
                  _buildSexButton("Group"),
                ],
              ),
              SizedBox(height: 48.h),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDA843),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    minimumSize: Size(double.infinity, 60.h),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Create Goal",
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF22343C),
          ),
        ),
      );

  Widget _buildField(String hint) => Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(40.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: GoogleFonts.montserrat(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Widget _buildDropdown(String hint, List<String> items, ValueChanged<String?> onChanged) => Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(40.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              hint,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: onChanged,
            value: null,
          ),
        ),
      );

  Widget _buildSexButton(String label) => Expanded(
        child: Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7F9),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                label == "Personal" ? Icons.person : Icons.group,
                color: const Color(0xFF22343C),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF22343C),
                ),
              ),
            ],
          ),
        ),
      );
}