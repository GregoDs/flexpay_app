import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/promos/cubits/kapu_cubit.dart';
import 'package:flexpay/features/promos/cubits/kapu_state.dart';
import 'package:flexpay/features/promos/models/kapu_balance_model/kapu_wallet_models.dart';
import 'package:flexpay/features/promos/repo/kapu_repo.dart';
import 'package:flexpay/features/promos/ui/promo_cards_shimmer.dart';
import 'package:flexpay/features/promos/ui/promo_details.dart';
import 'package:flexpay/utils/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoCardsSwiperPage extends StatefulWidget {
  final UserModel? userModel;

  const PromoCardsSwiperPage({super.key, this.userModel});

  @override
  State<PromoCardsSwiperPage> createState() => _PromoCardsSwiperPageState();
}

class _PromoCardsSwiperPageState extends State<PromoCardsSwiperPage> {
  late KapuCubit _kapuCubit;
  bool _isBalanceHidden = true;

  final List<Map<String, dynamic>> merchants = [
    {'name': 'Jaza', 'merchant_id': '403', 'color': const Color(0xFF761B1A)},
    {
      'name': 'Quickmart Supermarket',
      'merchant_id': '347',
      'color': const Color(0xFF111111),
    },
    {
      'name': 'Naivas Supermarket',
      'merchant_id': '107',
      'color': const Color(0xFFFFB020),
    },
    {
      'name': 'HotPoint Appliances',
      'merchant_id': '73',
      'color': const Color(0xFFCD0000),
    },
    {
      'name': 'Azone Supermarket',
      'merchant_id': '252',
      'color': const Color(0xFF6C63FF),
    },
    {
      'name': 'Open Wallet',
      'merchant_id': '4',
      'color': const Color(0xFF00A86B),
    },
  ];

  List<Map<String, dynamic>> _visibleMerchants = [];
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
void initState() {
  super.initState();

  _visibleMerchants = merchants;
  _kapuCubit = KapuCubit(KapuRepo(ApiService()));

  final merchantIds = merchants
      .map((m) => m['merchant_id'] as String)
      .toList();
  _kapuCubit.fetchMultipleKapuWalletBalances(merchantIds);

  
  _pageController = PageController(viewportFraction: 0.78, initialPage: 1);

  _pageController.addListener(() {
    setState(() {
      _currentPage =
          _pageController.page ?? _pageController.initialPage.toDouble();
    });
  });
}

  @override
  void dispose() {
    _kapuCubit.close();
    _pageController.dispose();
    super.dispose();
  }

  KapuWalletBalances? _walletForMerchantIndex(
    int merchantIndex,
    List<KapuWalletBalances> wallets,
  ) {
    if (merchantIndex < 0 || merchantIndex >= wallets.length) return null;
    return wallets[merchantIndex];
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F1113) : const Color(0xFFF5F7FA);

    final headlineStyle = GoogleFonts.montserrat(
      fontSize: 36.sp,
      fontWeight: FontWeight.w500,
      height: 1.24,
      color: isDark ? Colors.white : const Color(0xFF1D2935),
    );

    final subtitleStyle = GoogleFonts.montserrat(
      fontSize: 13.sp,
      color: isDark ? Colors.grey[400] : Colors.black54,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.0,
    );

    return BlocProvider(
      create: (_) => _kapuCubit,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleIcon(
                      context,
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () {
                        if (widget.userModel != null) {
                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                            arguments: widget.userModel,
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                    Text(
                      'Christmas Kapu'.toUpperCase(),
                      style: subtitleStyle.copyWith(letterSpacing: 1.6),
                    ),
                    Text(
                      '${(_currentPage.round() + 1)}/${merchants.length}',
                      style: subtitleStyle,
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                Text.rich(
                  TextSpan(
                    text: 'Select your\n',
                    children: [
                      TextSpan(
                        text: 'Christmas Kapu 🎅 ',
                        style: headlineStyle,
                      ),
                      TextSpan(
                        text: 'from our wide varieties',
                        style: headlineStyle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    style: headlineStyle,
                  ),
                ),

                SizedBox(height: 26.h),

                Expanded(
                  child: BlocBuilder<KapuCubit, KapuState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: _buildStateChild(state),
                      );
                    },
                  ),
                ),

                Center(
                  child: Text(
                    'Swipe to view more',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateChild(KapuState state) {
    if (state is KapuWalletLoading) {
      return const PromoCardsShimmer(key: ValueKey('shimmer'));
    } else if (state is KapuWalletListFetched) {
      return _buildSwiper(state.wallets);
    } else if (state is KapuWalletFailure) {
      return Center(
        key: const ValueKey('error'),
        child: Text(
          "⚠️ ${state.message}",
          style: GoogleFonts.montserrat(
            color: Colors.redAccent,
            fontSize: 14.sp,
          ),
        ),
      );
    }
    return const PromoCardsShimmer(key: ValueKey('shimmer_fallback'));
  }

  Widget _buildSwiper(List<KapuWalletBalances> wallets) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _visibleMerchants.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index.toDouble();
              });
            },
            itemBuilder: (context, index) {
              final merchant = _visibleMerchants[index];
              final walletModel = _walletForMerchantIndex(index, wallets);
              final balance = walletModel?.data?.balance ?? 0.0;
              final bool isCurrent = index == _currentPage.round();

              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                margin: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: isCurrent ? 36.h : 48.h,
                ),
                transform: Matrix4.identity()
                  ..scale(isCurrent ? 1.0 : 0.93)
                  ..setEntry(3, 2, 0.001),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: (merchant['color'] as Color).withOpacity(
                          isCurrent ? 0.35 : 0.12,
                        ),
                        blurRadius: isCurrent ? 25 : 10,
                        spreadRadius: isCurrent ? 2 : 0,
                        offset: Offset(0, isCurrent ? 6 : 3),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final tappedIndex = index;
                      setState(() {
                        _currentPage = tappedIndex.toDouble();
                      });

                      await Future.delayed(const Duration(milliseconds: 120));
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 700),
                          reverseTransitionDuration: const Duration(
                            milliseconds: 600,
                          ),
                          pageBuilder: (_, animation, __) => SlideTransition(
                            position:
                                Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  ),
                                ),
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                              child: BlocProvider.value(
                                value: context.read<KapuCubit>(),
                                child: PromoCardDetailPage(
                                  merchant: merchant,
                                  balance: balance,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                      // 🩶 Refresh balances when returning
                      final merchantIds = merchants
                          .map((m) => m['merchant_id'].toString())
                          .toList();
                      _kapuCubit.fetchMultipleKapuWalletBalances(merchantIds);
                    },
                    child: _buildCard(merchant, balance, index),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_visibleMerchants.length, (index) {
            final bool isActive = index == _currentPage.round();
            final Color color = _visibleMerchants[index]['color'] as Color;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: isActive ? 22.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: isActive
                    ? color.withOpacity(0.9)
                    : color.withOpacity(0.25),
                borderRadius: BorderRadius.circular(6.r),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> merchant, double balance, int index) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color base = merchant['color'] as Color;
    final Color darker = _shadeColor(base, 0.85);
    final Color lighter = _shadeColor(base, 1.12);

    return Hero(
      tag: 'kapu_card_${merchant['merchant_id']}',
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darker.withOpacity(0.98), lighter.withOpacity(0.95)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: isDarkMode ? 0.04 : 0.06,
                  child: Image.asset(
                    'assets/images/home_images/promo_card_pattern.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            merchant['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.24),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.touch_app_rounded,
                                size: 12.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Tap to view",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount",
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // 👁️ Hide/Show button
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isBalanceHidden = !_isBalanceHidden;
                                });
                              },
                              child: Icon(
                                _isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),

                        Text(
                          _isBalanceHidden ? "Ksh •••••" : "Ksh ${balance.toStringAsFixed(2)}",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "FlexPay Merchant",
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
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

  Color _shadeColor(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  Widget _circleIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF6F7F9),
          shape: BoxShape.circle,
          border: isDark
              ? Border.all(color: Colors.grey[700]!, width: 0.5)
              : null,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black,
          size: 20.sp,
        ),
      ),
    );
  }
}
