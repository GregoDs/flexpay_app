import 'package:flexpay/features/goals/ui/make_goal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final List<Map<String, dynamic>> goals = [
    {
      "image": "assets/images/goals_imgs/rent_goals.png",
      "title": "Rent Goal",
      "subtitle": "Pay your rent on time",
      "amount": "\$500.00",
      "favorite": true,
    },
    // {
    //   "image": "assets/images/goals/land.png",
    //   "title": "Land/Plot",
    //   "subtitle": "Own your dream land",
    //   "amount": "\$2,000.00",
    //   "favorite": false,
    // },
    // {
    //   "image": "assets/images/goals/shopping.png",
    //   "title": "Shopping",
    //   "subtitle": "Shop your wishlist",
    //   "amount": "\$350.00",
    //   "favorite": false,
    // },
    {
      "image": "assets/images/goals_imgs/vacation.png",
      "title": "Vacation",
      "subtitle": "Plan your getaway",
      "amount": "\$1,200.00",
      "favorite": true,
    },
    {
      "image": "assets/images/goals_imgs/christmass_goals.png",
      "title": "Christmas Goal",
      "subtitle": "Festive savings",
      "amount": "\$400.00",
      "favorite": false,
    },
    {
      "image": "assets/images/goals_imgs/school_fees.png",
      "title": "School Fees",
      "subtitle": "Pay school fees easily",
      "amount": "\$800.00",
      "favorite": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? Colors.black : const Color(0xFFF6F7F9);
    final Color cardColor = isDarkMode ? theme.cardColor : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    final Color shadowColor = isDarkMode ? Colors.black45 : Colors.black12;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light // White status bar icons for dark mode
          : SystemUiOverlayStyle.dark, // Dark status bar icons for light mode
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.h),
                // Top bar (remains fixed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "Goals Categories ",
                        style: GoogleFonts.montserrat(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                // Everything below is scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 22.h),
                        // Search bar and filter
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 14.w),
                                    Icon(Icons.menu,
                                        color: subtitleColor, size: 22.sp),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Goals",
                                          hintStyle: GoogleFonts.montserrat(
                                            fontSize: 16.sp,
                                            color: isDarkMode
                                                ? Colors.white38
                                                : Colors.black38,
                                          ),
                                        ),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16.sp,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(Icons.tune,
                                  color: iconColor, size: 24.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.h),
                        // Results text
                        Text(
                          "Achieve your Goals",
                          style: GoogleFonts.montserrat(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // Goals grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18.h,
                            crossAxisSpacing: 18.w,
                            childAspectRatio: 0.60,
                          ),
                          itemCount: goals.length,
                          itemBuilder: (context, index) {
                            final goal = goals[index];
                            return InkWell(
                              borderRadius: BorderRadius.circular(18.r),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MakeGoalPage(goal: goal),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(18.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Use Expanded for the image to fill available space
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                          child: Container(
                                            width: double.infinity,
                                            color: isDarkMode
                                                ? Colors.grey[800]
                                                : Colors.grey[200],
                                            child: Image.asset(
                                              goal["image"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          width: 32.w,
                                          height: 32.w,
                                          decoration: BoxDecoration(
                                            color: cardColor,
                                            borderRadius:
                                                BorderRadius.circular(14.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: shadowColor,
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            iconSize: 20.sp,
                                            icon: Icon(
                                              goal["favorite"]
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: goal["favorite"]
                                                  ? Colors.amber
                                                  : isDarkMode
                                                      ? Colors.white54
                                                      : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                goals[index]["favorite"] =
                                                    !goals[index]["favorite"];
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Text(
                                        goal["title"],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        goal["subtitle"],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12.sp,
                                          color: subtitleColor,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
}
