import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final List<BottomNavBarItem> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Shadow color adapts
    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.4)
        : Colors.grey.withOpacity(0.3);

    // Active and inactive colors adapt
    final activeColor = isDarkMode ? Colors.amber : Colors.amber;
    final inactiveColor = Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        // ✅ Dark mode = solid dark bg, Light mode = background image
        color: isDarkMode ? Colors.grey[900] : null,
        image:  const DecorationImage(
                image: AssetImage('assets/images/appbarbackground.png'),
                fit: BoxFit.cover,
              ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.02,
            horizontal: screenWidth * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = currentIndex == index;

              return GestureDetector(
                onTap: () => onTabTapped(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: screenWidth * 0.06,
                      color: isSelected ? activeColor : inactiveColor,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavBarItem {
  final IconData icon;
  final String label;

  BottomNavBarItem({
    required this.icon,
    required this.label,
  });
}