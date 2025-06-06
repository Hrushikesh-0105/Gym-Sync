import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  // Your provided theme colors
  static const Color scaffoldBackgroundColor = Color(0xff2C3639);
  static const Color primaryColor = Color(0xff3F4E4F);
  static const Color highlightColor = Color(0xffDCD7C9);

  // Additional complementary colors for snackbars
  static const Color successColor = Color(
    0xff4C9A75,
  ); // Green tone that fits the theme
  static const Color errorColor = Color(
    0xffA75D5D,
  ); // Reddish tone that fits the theme
  static const Color infoColor = Color(
    0xff5D7599,
  ); // Bluish tone that fits the theme
}

enum SnackType { success, error, info }

class AppSnackBar {
  static void show({
    required String message,
    String? title,
    SnackType type = SnackType.info,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
  }) {
    // Define colors and icons based on type
    late final Color backgroundColor;
    late final Color borderColor;
    late final IconData icon;

    switch (type) {
      case SnackType.success:
        backgroundColor = AppTheme.successColor;
        borderColor = AppTheme.successColor.withOpacity(0.7);
        icon = Icons.check_circle_outline;
        break;
      case SnackType.error:
        backgroundColor = AppTheme.errorColor;
        borderColor = AppTheme.errorColor.withOpacity(0.7);
        icon = Icons.error_outline;
        break;
      default:
        backgroundColor = AppTheme.infoColor;
        borderColor = AppTheme.infoColor.withOpacity(0.7);
        icon = Icons.info_outline;
        break;
    }

    Get.snackbar(
      title ?? _getDefaultTitle(type),
      message,
      snackPosition: position,
      backgroundColor: backgroundColor.withOpacity(0.9),
      colorText: AppTheme.highlightColor,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCirc,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: AppTheme.scaffoldBackgroundColor.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      borderColor: borderColor,
      borderWidth: 2,
      icon: Icon(icon, color: AppTheme.highlightColor, size: 28),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          'Dismiss',
          style: TextStyle(
            color: AppTheme.highlightColor,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      shouldIconPulse: true,
      leftBarIndicatorColor: borderColor,
    );
  }

  static String _getDefaultTitle(SnackType type) {
    switch (type) {
      case SnackType.success:
        return 'Success';
      case SnackType.error:
        return 'Error';
      // case SnackType.info:
      default:
        return 'Warning';
    }
  }

  // Convenience methods for quick access
  static void showSuccess(String message, {String? title}) {
    show(message: message, title: title, type: SnackType.success);
  }

  static void showError(String message, {String? title}) {
    show(message: message, title: title, type: SnackType.error);
  }

  static void showInfo(String message, {String? title}) {
    show(message: message, title: title, type: SnackType.info);
  }
}
