import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flexpay/features/auth/models/user_model.dart';
import 'package:flexpay/utils/cache/shared_preferences_helper.dart';
import 'package:flexpay/gen/colors.gen.dart';

class FlexPaySideMenu extends StatefulWidget {
  final UserModel userModel;
  final userName;
  final Function(int) onPageSelected;

  const FlexPaySideMenu({
    super.key,
    required this.userName,
    required this.userModel,
    required this.onPageSelected,
  });

  @override
  State<FlexPaySideMenu> createState() => _FlexPaySideMenuState();
}

class _FlexPaySideMenuState extends State<FlexPaySideMenu> {
  int selectedIndex = 0;

  final List<_MenuItem> _menuItems = [
    _MenuItem(title: "Home", icon: Icons.home),
    _MenuItem(title: "Goals", icon: Icons.credit_card),
    _MenuItem(title: "FlexChama", icon: Icons.people),
    _MenuItem(title: "Bookings", icon: Icons.savings),
    _MenuItem(title: "Merchants", icon: Icons.store),
  ];

  Future<void> _logout() async {
    await SharedPreferencesHelper.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Colors.white;

    return Container(
      width: MediaQuery.of(context).size.width * 0.72,
      color: const Color(0xFF17203A),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧍 Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: ColorName.primaryColor.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName ?? "User",
                          style: GoogleFonts.montserrat(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.userModel.user.phoneNumber ?? "",
                          style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24, thickness: 0.3),

            // 📄 Navigation Links
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  final isSelected = selectedIndex == index;

                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? ColorName.primaryColor : Colors.white,
                    ),
                    title: Text(
                      item.title,
                      style: GoogleFonts.montserrat(
                        color: isSelected
                            ? ColorName.primaryColor
                            : Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      setState(() => selectedIndex = index);
                      widget.onPageSelected(index); // ✅ callback to parent
                      Navigator.pop(context); // close drawer
                    },
                  );
                },
              ),
            ),

            const Divider(color: Colors.white24, thickness: 0.3),

            // 🚪 Logout Section (Pinned Bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: _logout,
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: GoogleFonts.montserrat(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  _MenuItem({required this.title, required this.icon});
}
