import 'package:flexpay/exports.dart' hide CustomSnackBar;
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/bookings/ui/bookings.dart';
import 'package:flexpay/features/flexchama/cubits/chama_cubit.dart';
import 'package:flexpay/features/flexchama/cubits/chama_state.dart';
import 'package:flexpay/features/flexchama/ui/chama_home.dart';
import 'package:flexpay/features/flexchama/ui/opt_chama_screen.dart';
import 'package:flexpay/features/goals/ui/goals.dart';
import 'package:flexpay/features/home/ui/homescreen.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation.dart';
import 'package:flexpay/utils/widgets/scaffold_messengers.dart';

class NavigationWrapper extends StatefulWidget {
  final int initialIndex;
  final UserModel userModel;

  const NavigationWrapper(
      {Key? key, this.initialIndex = 0, required this.userModel})
      : super(key: key);

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  late int _currentIndex;
  bool showOnBoard = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // Fetch profile (savings will auto-fetch inside cubit)
    Future.microtask(() {
      context.read<ChamaCubit>().fetchChamaUserProfile();
    });
  }

  void _onTabTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onOptIn() {
    setState(() {
      showOnBoard = false;
    });
  }

  List<Widget> get _pages => [
        HomeScreen(
          isDarkModeOn: false,
          userModel: widget.userModel,
        ),

        GoalsPage(),

        /// FlexChama Tab
        BlocListener<ChamaCubit, ChamaState>(
          listener: (context, state) {
            if (state is ChamaError) {
              CustomSnackBar.showError(
                context,
                title: "Oops!",
                message: state.message,
              );
              if (_currentIndex != 0) {
                setState(() {
                  _currentIndex = 0;
                });
              }
            }
          },
          child: BlocBuilder<ChamaCubit, ChamaState>(
            builder: (context, state) {
              // Handle loading & initial states
              if (state is ChamaInitial || state is ChamaProfileLoading || state is ChamaSavingsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Not a member → show onboarding
              if (state is ChamaNotMember) {
                return OnBoardFlexChama(
                  onOptIn: _onOptIn,
                  userModel: widget.userModel,
                );
              }

              // Profile + savings fetched → show FlexChama
              if (state is ChamaProfileFetched || state is ChamaSavingsFetched) {
                final profile = (state is ChamaProfileFetched)
                    ? state.profile
                    : (state as ChamaSavingsFetched).savingsResponse.data!.chamaDetails;

                if (showOnBoard) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      showOnBoard = false;
                    });
                  });
                }

                return FlexChama(profile: profile);
              }

              // Fallback loader
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),

        BlocProvider.value(
          value: bookingsCubit,
          child: const BookingsPage(),
        ),

        BlocProvider.value(
          value: merchantsCubit,
          child: MerchantsScreen(),
        ),
      ];

  final List<BottomNavBarItem> _navItems = [
    BottomNavBarItem(icon: Icons.home, label: "Home"),
    BottomNavBarItem(icon: Icons.credit_card, label: "Goals"),
    BottomNavBarItem(icon: Icons.people, label: "FlexChama"),
    BottomNavBarItem(icon: Icons.savings, label: "Bookings"),
    BottomNavBarItem(icon: Icons.store, label: "Merchants"),
  ];

  @override
  Widget build(BuildContext context) {
    bool hideNavBar = _currentIndex == 2 && showOnBoard;

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: hideNavBar
            ? null
            : BottomNavBar(
                currentIndex: _currentIndex,
                onTabTapped: _onTabTapped,
                items: _navItems,
              ),
      ),
    );
  }
}