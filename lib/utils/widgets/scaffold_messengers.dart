import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar {
  // Custom Snackbar
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    Duration? duration,
  }) {
    // Hide any existing SnackBar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Detect system brightness (light/dark)
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Dynamic colors
    final Color bgColor = backgroundColor ??
        (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white);
    final Color iconBgColor = isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);
    final Color iconClr =
        iconColor ?? (isDarkMode ? Colors.white : Colors.black);
    final Color txtColor =
        textColor ?? (isDarkMode ? Colors.white : Colors.black87);

    // Get screen width for responsive sizing
    final double screenWidth = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // 5% padding from sides
          vertical: 10,
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
                blurRadius: isDarkMode ? 15 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon wrapper
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconClr,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: txtColor,
                      ),
                    ),
                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      // Message
                      Text(
                        message,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: txtColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                    // Action Button
                    if (actionLabel != null && onAction != null)
                      TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(top: 8),
                        ),
                        child: Text(
                          actionLabel,
                          style: GoogleFonts.montserrat(
                            color: isDarkMode
                                ? Colors.redAccent.shade200
                                : Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: duration ?? const Duration(seconds: 4),
      ),
    );
  }

  // Success Snackbar
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    show(
      context,
      title: title,
      message: message,
      icon: Icons.check_circle_outline,
      actionLabel: actionLabel,
      onAction: onAction,
      backgroundColor: isDarkMode
          ? Color(0xFF0A3320) // Dark green background
          : Colors.green.shade50,
      iconColor: isDarkMode
          ? Color(0xFF4ADE80) // Bright green icon
          : Colors.green,
      textColor: isDarkMode ? Colors.white : null,
    );
  }

  // Error Snackbar
  static void showError(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    show(
      context,
      title: title,
      message: message,
      icon: Icons.error_outline,
      actionLabel: actionLabel,
      onAction: onAction,
      backgroundColor: isDarkMode
          ? Color(0xFF331111) // Dark red background
          : Colors.red.shade50,
      iconColor: isDarkMode
          ? Color(0xFFFF5252) // Bright red icon
          : Colors.red,
      textColor: isDarkMode ? Colors.white : null,
    );
  }

  // Warning Snackbar
  static void showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    show(
      context,
      title: title,
      message: message,
      icon: Icons.warning_amber_outlined,
      actionLabel: actionLabel,
      onAction: onAction,
      backgroundColor: isDarkMode
          ? Color(0xFF332711) // Dark orange background
          : Colors.orange.shade50,
      iconColor: isDarkMode
          ? Color(0xFFFFB74D) // Bright orange icon
          : Colors.orange,
      textColor: isDarkMode ? Colors.white : null,
    );
  }

  // Info Snackbar
  static void showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    show(
      context,
      title: title,
      message: message,
      icon: Icons.info_outline,
      actionLabel: actionLabel,
      onAction: onAction,
      backgroundColor: isDarkMode
          ? Color(0xFF0A1B33) // Dark blue background
          : Colors.blue.shade50,
      iconColor: isDarkMode
          ? Color(0xFF64B5F6) // Bright blue icon
          : Colors.blue,
      textColor: isDarkMode ? Colors.white : null,
    );
  }
}
