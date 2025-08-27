import 'package:flexpay/exports.dart';
import 'package:flexpay/features/home/ui/topupscreen.dart';
import 'package:flexpay/features/home/ui/withdrawpage.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarChama extends StatefulWidget {
  const AppBarChama(BuildContext context, {super.key});

  @override
  State<AppBarChama> createState() => _AppBarChamaState();
}

class _AppBarChamaState extends State<AppBarChama> {
  bool _isHomeBalanceVisible = true;

  @override
  void initState() {
    super.initState();
  }

  void toggleBalanceVisibility() {
    setState(() {
      _isHomeBalanceVisible = !_isHomeBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.040, vertical: screenHeight * 0.066),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/appbarbackground.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(58),
        ),
      ),
      child: SingleChildScrollView(
        // <-- Optional if content height grows
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  // Flexpay Logo
            //               Center(
            //                 child: ColorFiltered(
            //                   colorFilter: ColorFilter.mode(
            //                     Theme.of(context).brightness == Brightness.dark
            //                         ?  Colors.white
            //                         : Colors.white,
            //                     BlendMode.srcIn,
            //                   ),
            //                   child: Image.asset(
            //                     'assets/icon/logos/logo.png',
            //                     height: 30.h,
            //                     fit: BoxFit.contain,
            //                   ),
            //                 ),
            //               ),
            //               SizedBox(height: 8.h),

            /// Profile and Notifications
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

            SizedBox(height: screenHeight * 0.04),

            /// Wallet Balance Label
            Text(
              'Matured Savings',
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: screenWidth.clamp(12.0, 20.0) * 1.0,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: screenHeight * 0.008),

            /// Balance & Toggle Visibility
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _isHomeBalanceVisible ? 'Kshs 14,009.65' : '******',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: screenWidth.clamp(20.0, 40.0) * 0.75,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: toggleBalanceVisibility,
                  child: Icon(
                    _isHomeBalanceVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white70,
                    size: screenWidth.clamp(16.0, 28.0) * 0.8,
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.048),

            /// Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: _buildActionButton(Icons.account_balance_wallet,
                        'Withdraw', WithdrawPage(), context, screenWidth)),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                    child: _buildActionButton(Icons.arrow_downward, 'Top up',
                        TopUpPage(), context, screenWidth)),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                    child: _buildNavigationActionButton(
                        FontAwesomeIcons.handHoldingDollar,
                        'Borrow',
                        4,
                        MerchantsScreen(),
                        context,
                        screenWidth)),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                    child: _buildNavigationActionButton(
                        FontAwesomeIcons.fileInvoiceDollar,
                        'Statement',
                        2,
                        MerchantsScreen(),
                        context,
                        screenWidth)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildActionButton(IconData icon, String label, Widget page,
      BuildContext context, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: screenWidth.clamp(28.0, 40.0) * 0.40,
            child: Icon(icon,
                color: Colors.white, size: screenWidth.clamp(18.0, 28.0) * 0.8),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: screenWidth.clamp(10.0, 16.0) * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationActionButton(IconData icon, String label, int index,
      Widget page, BuildContext context, double screenWidth) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            radius: screenWidth.clamp(28.0, 40.0) * 0.4,
            child: Icon(icon,
                color: Colors.white, size: screenWidth.clamp(18.0, 28.0) * 0.8),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: screenWidth.clamp(10.0, 16.0) * 0.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
