import 'package:flexpay/features/goals/ui/create_goal.dart';
import 'package:flexpay/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'goal_details_page.dart';

class GoalsPage extends StatelessWidget {
  GoalsPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> flexGoals = [
    {
      "product_category_name": "Private home",
      "targetAmount": "from Kshs 48k",
      "image": "assets/images/goals_imgs/rent_goals.png",
      "color": const Color(0xFFD9EAD3),
      "isSelected": true,
    },
    {
      "product_category_name": "College",
      "targetAmount": "from Kshs 21k",
      "image": "assets/images/goals_imgs/school_fees.png",
      "color": const Color(0xFF2F3237),
      "isSelected": false,
    },
    {
      "product_category_name": "Christmas",
      "targetAmount": "from Kshs 10k",
      "image": "assets/images/goals_imgs/christmass_goals.png",
      "color": const Color(0xFF2F3237),
      "isSelected": false,
    },
  ];

  final List<Map<String, dynamic>> goals = const [
    {
      "image": "assets/images/goals_imgs/rent_goals.png",
      "product_category_name": "Rent Goal",
      "product_type_name": "Housing deals",
      "amountSaved": 320,
      "targetAmount": 500,
    },
    {
      "image": "assets/images/goals_imgs/vacation.png",
      "product_category_name": "Vacation",
      "product_type_name": "Travel deals",
      "amountSaved": 700,
      "targetAmount": 1200,
    },
    {
      "image": "assets/images/goals_imgs/christmass_goals.png",
      "product_category_name": "Christmas Goal",
      "product_type_name": "Festive szn deals",
      "amountSaved": 150,
      "targetAmount": 400,
    },
    {
      "image": "assets/images/goals_imgs/school_fees.png",
      "product_category_name": "School Fees",
      "product_type_name": "Education goals",
      "amountSaved": 400,
      "targetAmount": 800,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final bgColor = isDarkMode ? Colors.black : const Color(0xFFF5F6F8);
    final cardColor = isDarkMode ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final product_type_nameColor = isDarkMode ? Colors.white70 : Colors.black54;
    final iconBorderColor =
        isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black54;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side — Profile + Greeting
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor:
                            isDarkMode ? Colors.white10 : Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 24.sp,
                          color: ColorName.primaryColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Vincent",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "Click the add button to create a goal",
                            style: GoogleFonts.montserrat(
                              fontSize: 12.sp,
                              color: product_type_nameColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Right side — outlined plus button
                  GestureDetector(
                     onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateGoalPage()),
                      );
                    },
                    child: Container(
                      height: 56.h,
                      width: 56.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconBorderColor,
                          width: 1.6,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: iconColor,
                          size: 32.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ✅ FlexPay Goals Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select FlexGoals",
                    style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Scroll to see our FlexGoals or make your own",
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      color: product_type_nameColor,
                    ),
                  ),
                  SizedBox(height: 20.h),


                  SizedBox(
                      height: 206.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: flexGoals.length,
                        itemBuilder: (context, index) {
                          final goal = flexGoals[index];
                          final isSelected = goal["isSelected"];

                          return GestureDetector(
                            onTap: () {
                              // 🧮 Extract numeric value and handle 'k' as *1000
                              String targetText = goal["targetAmount"].toString();
                              double numericValue = 0;

                              // Remove everything except numbers and 'k'
                              if (targetText.toLowerCase().contains('k')) {
                                final number = double.tryParse(
                                  targetText.replaceAll(RegExp(r'[^0-9.]'), ''),
                                );
                                if (number != null) numericValue = number * 1000;
                              } else {
                                final number = double.tryParse(
                                  targetText.replaceAll(RegExp(r'[^0-9.]'), ''),
                                );
                                if (number != null) numericValue = number;
                              }

                              // 🟢 Navigate to CreateGoalPage with proper prefilled data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateGoalPage(
                                    prefilledGoal: {
                                      'product_name': goal["product_category_name"],
                                      'amount': numericValue.toStringAsFixed(0), // e.g. "48000"
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 180.w,
                              margin: EdgeInsets.only(right: 18.w),
                              decoration: BoxDecoration(
                                color: goal["color"],
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Image.asset(
                                        goal["image"],
                                        height: 100.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      goal["product_category_name"],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.black : Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      goal["targetAmount"],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12.sp,
                                        color: isSelected
                                            ? Colors.black.withOpacity(0.7)
                                            : Colors.white70,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 22.h,
                                        width: 22.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 3,
                                              offset: const Offset(1, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          isSelected ? Icons.remove : Icons.add,
                                          color: isSelected
                                              ? Colors.black
                                              : ColorName.primaryColor,
                                          size: 22.sp,
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
                ],
              ),

              const SizedBox(height: 20),

              // My Goals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My goals",
                    style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "View All",
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      color: ColorName.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Goal Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  double progress =
                      goal['amountSaved'] / goal['targetAmount'];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GoalDetailsPage(goal: goal),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white10
                              : Colors.grey.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Container(
                            height: 120.h,
                            width: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                image: AssetImage(goal['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),

                          // Text + Progress
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goal['product_category_name'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  goal['product_type_name'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13.sp,
                                    color: product_type_nameColor,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "${(progress * 100).toStringAsFixed(0)}%",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorName.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Stack(
                                  children: [
                                    Container(
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                    ),
                                    Container(
                                      height: 4.h,
                                      width: progress * 140.w,
                                      decoration: BoxDecoration(
                                        color: ColorName.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  "Ksh ${goal['amountSaved'].toStringAsFixed(0)} / Ksh ${goal['targetAmount'].toStringAsFixed(0)}",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.sp,
                                    color: product_type_nameColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}