import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/ui/shimmer_chama_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';

import '../../../utils/services/logger.dart';

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
  final Color textColor = const Color(0xFF1D3C4E);

  final cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 16.r,
      offset: Offset(0, 4.h),
    ),
  ];

  bool isYearly = true;
  int selectedChamaType = 1;

  int myChamaCount = 0;
  int ourChamasCount = 0;

  @override
  void initState() {
    super.initState();
    context.read<ChamaCubit>().fetchChamaUserSavings();
  }

  void _fetchOurChamas() {
    final type = isYearly ? "yearly" : "half_yearly";
    context.read<ChamaCubit>().getAllChamaProducts(type: type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocListener<ChamaCubit, ChamaState>(
          listener: (context, state) {
            if (state is ChamaSavingsFetched &&
                state.savingsResponse.statusCode != 400 &&
                state.savingsResponse.errors?.isNotEmpty == true) {
              final response = state.savingsResponse;
              if ((response.errors?.isNotEmpty ?? false) &&
                  response.statusCode != 400) {
                final errorMsg = response.errors!.first.toString();
                CustomSnackBar.showError(
                  context,
                  title: "Error",
                  message: errorMsg,
                );
              } else if (response.statusCode == 400) {
                AppLogger.log("ℹ️ 400 error ignored for UI: ${response.errors?.first}");
              }
            }
          },
          child: BlocBuilder<ChamaCubit, ChamaState>(
            builder: (context, state) {
              String totalSavings = "_";
              String maturityDate = "_";
              double progress = 0.0;
              String progressText = "0%";

              myChamaCount = 0;
              ourChamasCount = 0;

              if (state is ChamaSavingsFetched) {
                final chamaDetails = state.savingsResponse.data?.chamaDetails;
                if (chamaDetails != null) {
                  myChamaCount = 1;
                  totalSavings = chamaDetails.totalSavings.toString();
                  maturityDate = chamaDetails.maturityDate;
                }
              }

              if (state is ChamaAllProductsFetched) {
                ourChamasCount = state.productsResponse.data.length;
              }

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back,
                              color: textColor, size: 22.sp),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Center(
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              textColor,
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
                            color: textColor, size: 22.sp),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    /// Wallet
                    Text(
                      "Wallet",
                      style: GoogleFonts.montserrat(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    if (state is ChamaSavingsLoading)
                      const WalletShimmer()
                    else
                      _buildWalletCard(
                        totalSavings,
                        maturityDate,
                        progress,
                        progressText,
                      ),

                    SizedBox(height: 20.h),
                    _buildCampaignCard(context),
                    SizedBox(height: 20.h),

                    /// Chama Cards Row
                    if (state is ChamaSavingsLoading ||
                        state is ChamaAllProductsLoading)
                      const ChamaCardsRowShimmer()
                    else
                      _buildChamaCardsRow(),

                    SizedBox(height: 24.h),

                    /// Chamas Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedChamaType == 2)
                            Row(
                              children: [
                                _ChamaTab(
                                  label: "Yearly",
                                  selected: isYearly,
                                  onTap: () {
                                    setState(() => isYearly = true);
                                    _fetchOurChamas();
                                  },
                                ),
                                SizedBox(width: 20.w),
                                _ChamaTab(
                                  label: "Half Yearly",
                                  selected: !isYearly,
                                  onTap: () {
                                    setState(() => isYearly = false);
                                    _fetchOurChamas();
                                  },
                                ),
                              ],
                            ),
                          if (selectedChamaType == 2) SizedBox(height: 12.h),

                          Text(
                            selectedChamaType == 1 ? "My Chama" : "Our Chamas",
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              color: const Color(0xFF3399CC),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          if (selectedChamaType == 1 &&
                              state is ChamaSavingsLoading)
                            const MyChamaListShimmer(),

                          if (selectedChamaType == 1 &&
                              state is ChamaSavingsFetched)
                            _ChamaListItem(
                              icon: Icons.group,
                              title: "My Chama Plan",
                              savings: "KES $totalSavings",
                              onSave: () {},
                            ),

                          if (selectedChamaType == 2 &&
                              state is ChamaAllProductsLoading)
                            const OurChamaListShimmer(),

                          if (selectedChamaType == 2 &&
                              state is ChamaAllProductsFetched)
                            ...List.generate(
                              state.productsResponse.data.length,
                              (index) {
                                final product =
                                    state.productsResponse.data[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 14.h),
                                  child: _ChamaListItem(
                                    icon: Icons.savings,
                                    title: product.name,
                                    savings: "KES ${product.targetAmount}",
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
              );
            },
          ),
        ),
      ),
    );
  }

  /// ✅ Wallet card helper
  Widget _buildWalletCard(String savings, String maturity, double progress, String progressText) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7FB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.account_balance_wallet,
                color: primaryColor, size: 26.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Savings Balance",
                    style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    )),
                FittedBox(
                  child: Text(savings,
                      style: GoogleFonts.montserrat(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      )),
                ),
                Text("Maturity date: $maturity",
                    style: GoogleFonts.montserrat(
                      fontSize: 11.sp,
                      color: textColor,
                    )),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.calendar_month,
                          color: Colors.blue, size: 16.sp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6.h,
                          backgroundColor: Colors.blue.withOpacity(0.15),
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(progressText,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Chama Cards row helper
  Widget _buildChamaCardsRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              selectedChamaType = 1;
              context.read<ChamaCubit>().fetchChamaUserSavings();
            }),
            child: _buildSelectedChamaCard(
              FontAwesomeIcons.creditCard,
              'My Chama',
              myChamaCount.toString(),
              loanIconColor,
              textColor,
              loanBg,
              isSelected: selectedChamaType == 1,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              selectedChamaType = 2;
              _fetchOurChamas();
            }),
            child: _buildSelectedChamaCard(
              FontAwesomeIcons.handHoldingDollar,
              'Our Chamas',
              ourChamasCount.toString(),
              flexcoinIconColor,
              textColor,
              flexcoinBg,
              isSelected: selectedChamaType == 2,
            ),
          ),
        ),
      ],
    );
  }
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
                    Icon(Icons.emoji_people, color: Colors.orange, size: 30.sp),
                    SizedBox(width: 12.w),
                    Icon(Icons.card_giftcard, color: Colors.blue, size: 30.sp),
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

Widget _buildSelectedChamaCard(
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
    height: 158.h,
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
          child: Divider(color: Colors.grey[300], thickness: 1, height: 1),
        ),
      ],
    );
  }
}
