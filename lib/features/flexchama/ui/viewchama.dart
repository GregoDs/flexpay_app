import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewChamas extends StatefulWidget {
  const ViewChamas({super.key});

  @override
  State<ViewChamas> createState() => _ViewChamasState();
}

class _ViewChamasState extends State<ViewChamas> {
  final primaryColor = const Color(0xFF009AC1);
  final flexcoinBg = const Color(0xFFEFE5D2);
  final loanBg = const Color(0xFFF1F3F6);
  final flexcoinIconColor = const Color(0xFFF5A623);
  final loanIconColor = const Color(0xFF6FCF97);
  final cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 16.r,
      offset: Offset(0, 4.h),
    ),
  ];

  // Dummy values for balances
  final int loanBalance = 2;
  final int flexcoinBalance = 11;
  final Color textColor = const Color(0xFF1D3C4E);

  // Tab state
  bool isYearly = true;

  // Add selection state
  int selectedChamaType = 1; // 1 = My Chama, 2 = Our Chamas

  // Example data for My Chama
  final List<Map<String, dynamic>> myChamas = [
    {
      "icon": Icons.group,
      "title": "Umoja@5k",
      "savings": "Ksh 20,000",
    },
    {
      "icon": Icons.savings,
      "title": "My Savings Squad",
      "savings": "Ksh 12,000",
    },
  ];

  // Example data
  final List<Map<String, dynamic>> yearlyChamas = [
    {
      "icon": Icons.calendar_today,
      "title": "52 Weeks Challenge",
      "savings": "Ksh 77,000",
    },
    {
      "icon": Icons.emoji_events,
      "title": "52 Weeks Challenge",
      "savings": "Ksh 77,000",
    },
    {
      "icon": Icons.savings,
      "title": "52 Weeks Challenge",
      "savings": "Ksh 77,000",
    },
    {
      "icon": Icons.group,
      "title": "Umoja@5k",
      "savings": "Ksh 20,000",
    },
  ];

  final List<Map<String, dynamic>> halfYearlyChamas = [
    {
      "icon": Icons.star,
      "title": "26 Weeks Saver",
      "savings": "Ksh 40,000",
    },
    {
      "icon": Icons.flash_on,
      "title": "Half Year Hustle",
      "savings": "Ksh 35,000",
    },
    {
      "icon": Icons.account_balance,
      "title": "Quick Six",
      "savings": "Ksh 25,000",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: const Color(0xFF1D3C4E), size: 24.w),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Center(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF337687)
                            : const Color(0xFF337687),
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        'assets/icon/logos/logo.png',
                        height: 40.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Icon(Icons.notifications_none,
                      color: const Color(0xFF1D3C4E), size: 24.w),
                ],
              ),
              SizedBox(height: 2.h),
              // Wallet Title
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Text(
                  "Wallet",
                  style: GoogleFonts.montserrat(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              // Wallet Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: cardShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F7FB),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.account_balance_wallet_rounded,
                          color: primaryColor, size: 28.w),
                    ),
                    SizedBox(width: 18.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Savings Balance",
                          style: GoogleFonts.montserrat(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          "22,000",
                          style: GoogleFonts.montserrat(
                            fontSize: 38.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "Maturity date: 30th Aug 2025",
                          style: GoogleFonts.montserrat(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Progress Indicator Row
                        Row(
                          children: [
                            // Flame icon
                            Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Progress bar
                            SizedBox(
                              width: 160.w,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: 0.4, // 40% progress
                                    child: Container(
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            // Percentage text
                            Text(
                              "40%",
                              style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              //Refer Card
              _buildCampaignCard(context),
              SizedBox(height: 24.h),
              // Chama Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChamaType = 1;
                      });
                    },
                    child: _buildBalanceCard(
                      FontAwesomeIcons.creditCard,
                      'My Chama',
                      loanBalance.toString(),
                      loanIconColor,
                      textColor,
                      loanBg,
                      isSelected: selectedChamaType == 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedChamaType = 2;
                      });
                    },
                    child: _buildBalanceCard(
                      FontAwesomeIcons.handHoldingDollar,
                      'Our Chamas',
                      flexcoinBalance.toString(),
                      flexcoinIconColor,
                      textColor,
                      flexcoinBg,
                      isSelected: selectedChamaType == 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              // Chamas section
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 24.h),
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tabs (only show for Our Chamas)
                    if (selectedChamaType == 2)
                      Row(
                        children: [
                          _ChamaTab(
                            label: "Yearly",
                            selected: isYearly,
                            onTap: () {
                              setState(() {
                                isYearly = true;
                              });
                            },
                          ),
                          SizedBox(width: 24.w),
                          _ChamaTab(
                            label: "Half Yearly",
                            selected: !isYearly,
                            onTap: () {
                              setState(() {
                                isYearly = false;
                              });
                            },
                          ),
                        ],
                      ),
                    if (selectedChamaType == 2) SizedBox(height: 10.h),
                    // Chama label
                    Text(
                      selectedChamaType == 1 ? "My Chama" : "Our Chamas",
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        color: const Color(0xFF3399CC),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // Chama List with icons
                    ...List.generate(
                      selectedChamaType == 1
                          ? myChamas.length
                          : (isYearly
                              ? yearlyChamas.length
                              : halfYearlyChamas.length),
                      (index) {
                        final chama = selectedChamaType == 1
                            ? myChamas[index]
                            : (isYearly
                                ? yearlyChamas[index]
                                : halfYearlyChamas[index]);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: _ChamaListItem(
                            icon: chama["icon"] as IconData,
                            title: chama["title"] as String,
                            savings: chama["savings"] as String,
                            onSave: () {},
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaignCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCampaignModal(context);
      },
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/appbarbackground.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.campaign, color: Colors.white, size: 28.sp),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'Spread the word!\nClick to refer a friend and earn',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCampaignModal(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(32.w, 24.h, 18.w, 24.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top underline indicator
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Animated or lively icons row
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_people,
                          color: Colors.orange, size: 30.sp),
                      SizedBox(width: 12.w),
                      Icon(Icons.card_giftcard,
                          color: Colors.blue, size: 30.sp),
                      SizedBox(width: 12.w),
                      Icon(Icons.star, color: Colors.amber, size: 30.sp),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                // Title
                Center(
                  child: Text(
                    'Refer & Earn',
                    style: GoogleFonts.montserrat(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D3C4E),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                // Subtitle
                Text(
                  'Share the love—get KES 100 when your friend tops up KES 500!',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 26.h),
                // Phone Number Label
                Text(
                  "Phone Number",
                  style: GoogleFonts.montserrat(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10.h),
                // Phone Number Input
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: TextField(
                    style: GoogleFonts.montserrat(
                      fontSize: 15.sp,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter Phone number",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.grey[500],
                        fontSize: 15.sp,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                SizedBox(height: 22.h),
                // Refer Button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF337687),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Refer",
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 10.h),
                // Referral Rewards Section
                Text(
                  "My Referral Rewards",
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D3C4E),
                  ),
                ),
                SizedBox(height: 16.h),
                _referralRow("Friends Joined", "50"),
                _referralRow("Total Earned", "Kes 5,000"),
                _referralRow("Amount Used", "Kes 250"),
                _referralRow("Current Balance", "Kes 4,750"),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _referralRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 15.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 15.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    IconData icon,
    String title,
    String amount,
    Color iconColor,
    Color textColor,
    Color cardColor, {
    bool isSelected = false,
  }) {
    return Container(
      width: 160.w,
      height: 148.h,
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
        border: isSelected ? Border.all(color: Colors.amber, width: 3) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 24.sp),
          SizedBox(height: 10.h),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            amount,
            style: GoogleFonts.montserrat(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChamaTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChamaTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFF3399CC) : Colors.grey[500],
            ),
          ),
          SizedBox(height: 4.h),
          if (selected)
            Container(
              width: 48.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3399CC),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChamaListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String savings;
  final VoidCallback onSave;

  const _ChamaListItem({
    required this.icon,
    required this.title,
    required this.savings,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Icon for chama
            Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7FB),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: const Color(0xFF3399CC), size: 28.sp),
            ),
            // Chama info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Total Savings: $savings",
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Save button
            SizedBox(
              width: 90.w,
              height: 44.h,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CA0C6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Bottom divider
        Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: Divider(
            color: Colors.grey[300],
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}
