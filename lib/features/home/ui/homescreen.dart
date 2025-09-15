import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/ui/appbarhome.dart';
import 'package:flexpay/features/home/ui/transactiondetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkModeOn;
  final UserModel userModel;

  const HomeScreen({
    super.key,
    required this.isDarkModeOn,
    required this.userModel,
    });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> outlets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.40),
            child: AppBarHome(
              context,
              userName: "${widget.userModel.user.username}",
              balance: 1234.56,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 36.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampaignCard(context),
                  SizedBox(height: 40.h),
                  _buildVoucherSection(context),
                  SizedBox(height: 15.h),
                  _buildMerchantImages(context),
                  SizedBox(height: 25.h),
                  _buildTransactionsSection(context),
                ],
              ),
            ),
          ),
        );
      },
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
                  'Spread the word!\nRefer a friend and earn',
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

  Widget _buildVoucherSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Buy a shopping voucher',
          style: GoogleFonts.montserrat(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Add navigation logic here if needed
          },
          child: Text(
            'View All',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMerchantImages(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMerchantCard(
            context,
            "assets/merchants/hotpoint.svg",
            110.w,
            "Hotpoint",
          ),
          SizedBox(width: 30.w),
          _buildMerchantCard(
            context,
            "assets/merchants/naivas.png",
            110.w,
            "Naivas",
          ),
          SizedBox(width: 30.w),
          _buildMerchantCard(
            context,
            "assets/merchants/quickmart.png",
            100.w,
            "Quickmart",
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantCard(BuildContext context, String imagePath,
      double width, String merchantName) {
    return GestureDetector(
      onTap: () => _showMerchantVoucherModal(context, merchantName),
      child: Container(
        width: width,
        height: 60.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: imagePath.endsWith('.svg')
            ? SvgPicture.asset(imagePath, fit: BoxFit.contain)
            : Image.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildTransactionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Transactions",
          style: GoogleFonts.montserrat(
              fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        _buildTransactionTile(
            "03 Feb 2025 21:35", "Booking", "Ksh 1", true, context),
            // Second booking (Boxer Motor Booking)
      _buildTransactionTile(
        "Feb 19, 2025",
        "Boxer Motor Booking",
        "+Ksh 2,000.00",
        true,
        context,
      ),

      // Third booking (another Booking)
      _buildTransactionTile(
        "03 Feb 2025 21:35",
        "Booking",
        "Ksh 1",
        false,
        context,
      ),
      ],
    );
  }

  Widget _buildTransactionTile(String dateTime, String description,
      String amount, bool isIncome, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(_createSlideUpRoute());
        },
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      isIncome ? Icons.north_east : Icons.south_west,
                      color: isIncome ? Colors.green : Colors.red,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateTime,
                        style: GoogleFonts.montserrat(
                          fontSize: 13.sp,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                amount,
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createSlideUpRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) =>
          TransactionDetailsPage(
        transactionId: '',
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  void _showMerchantVoucherModal(BuildContext context, String merchantName) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(6.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 3.h,
                  color: Colors.black54,
                  margin: EdgeInsets.only(bottom: 8.h),
                ),
                Text(
                  "Save for voucher",
                  style: GoogleFonts.montserrat(
                      fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15.h),
                Wrap(
                  spacing: 20.w,
                  runSpacing: 20.h,
                  children: [
                    _buildVoucherAmountButton("5,000"),
                    _buildVoucherAmountButton("10,000"),
                    _buildVoucherAmountButton("20,000"),
                    _buildVoucherAmountButton("50,000"),
                    _buildVoucherAmountButton("100,000"),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Voucher Amount",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10.h),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: GoogleFonts.montserrat(fontSize: 14.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Once created, the voucher can only be redeemed for any $merchantName products at any $merchantName outlet countrywide.",
                  style: GoogleFonts.montserrat(
                      color: Colors.red, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF337687),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                    child: Text(
                      "Create Goal",
                      style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVoucherAmountButton(String amount) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        side: const BorderSide(color: Color(0xFF0081B1)),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      ),
      child: Text(
        amount,
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
