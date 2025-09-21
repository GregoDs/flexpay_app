import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/home/ui/topupscreen.dart';
import 'package:flexpay/features/home/ui/withdrawpage.dart';
import 'package:flexpay/features/navigation/navigation_wrapper.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarHome extends StatefulWidget {
  final String userName;
  final double balance;
  final UserModel userModel;

  const AppBarHome(
    BuildContext context, {
    super.key,
    required this.userName,
    required this.balance, 
    required this.userModel,
  });

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  bool isBalanceVisible = true;

  void toggleBalanceVisibility() {
    setState(() {
      isBalanceVisible = !isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 54.h),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/appbarbackground.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                  onPressed: () {},
                ),
                Center(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/icon/logos/logo.png',
                      height: 30.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),
            
            //Username
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await SharedPreferencesHelper.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      },
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.white,
                        child:
                            Icon(Icons.person, size: 24.sp, color: Colors.blue),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      widget.userName,
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Icon(Icons.notifications, color: Colors.white, size: 28.sp),
              ],
            ),
            SizedBox(height: 22.h),

            /// Balance Label
            Text(
              'Total balance',
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4.h),

            /// Balance Value + Visibility Toggle
            Row(
              children: [
                Expanded(
                  child: Text(
                    isBalanceVisible
                        ? 'Ksh ${widget.balance.toStringAsFixed(2)}'
                        : '••••••',
                    style: GoogleFonts.montserrat(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: toggleBalanceVisibility,
                  child: Icon(
                    isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white70,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                    Icons.shopping_cart,
                    "Shop",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationWrapper(
                          initialIndex: 4, // Merchants tab index
                          userModel: widget.userModel,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(Icons.arrow_downward, "Top up",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TopUpPage()))),
                _buildActionButton(Icons.account_balance_wallet, "Withdraw",
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WithdrawPage()))),
                _buildActionButton(Icons.sync_alt, "Transfer"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: 24.r,
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
