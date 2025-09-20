import 'package:flexpay/exports.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/features/bookings/ui/bookings.dart';
import 'package:flexpay/features/goals/ui/goals.dart';
import 'package:flexpay/features/navigation/chamanav.dart';
import 'package:flexpay/features/home/ui/homescreen.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation.dart';

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
        FlexChamaTab(
          showOnBoard: showOnBoard,
          onOptIn: _onOptIn,
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
          // Not on Home → go back to Home instead of exiting
          setState(() {
            _currentIndex = 0;
          });
          return false; // prevent exiting
        }
        return false; // already on Home → do nothing
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
