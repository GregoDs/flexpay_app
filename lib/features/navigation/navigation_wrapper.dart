import 'package:flexpay/features/bookings/ui/bookings.dart';
import 'package:flexpay/features/goals/ui/goals.dart';
import 'package:flexpay/features/navigation/chamanav.dart';
import 'package:flutter/material.dart';
import 'package:flexpay/features/home/ui/homescreen.dart';
import 'package:flexpay/features/merchants/ui/merchants.dart';
import 'package:flexpay/features/navigation/navigation.dart';

class NavigationWrapper extends StatefulWidget {
  final int initialIndex;

  const NavigationWrapper({Key? key, this.initialIndex = 0}) : super(key: key);

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
        HomeScreen(isDarkModeOn: false),
        GoalsPage(),
        FlexChamaTab(
          showOnBoard: showOnBoard,
          onOptIn: _onOptIn,
        ),
        BookingsPage(),
        MerchantsScreen(),
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

    return Scaffold(
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
    );
  }
}
