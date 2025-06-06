import 'package:flutter/material.dart';

class AppColors {
  static Color active = Colors.green[300]!;
  static Color expired = Colors.orange[300]!;
  static Color inactive = Colors.red[300]!;
}

Widget customDatePickerTheme(BuildContext context, Widget child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.dark(
        primary: Theme.of(context).highlightColor,
        onPrimary: Theme.of(context).primaryColor,
        surface: Theme.of(context).primaryColor,
        onSurface: Theme.of(context).highlightColor,
      ),
      scaffoldBackgroundColor: Theme.of(context).primaryColor,
    ),
    child: child,
  );
}

InputDecoration customTextFieldInputDecoration(
  BuildContext context,
  String label,
  IconData icon,
) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Theme.of(context).highlightColor),
    prefixIcon: Icon(icon, color: Theme.of(context).highlightColor),
    filled: true,
    fillColor: Theme.of(context).primaryColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Theme.of(context).highlightColor, width: 2),
    ),
  );
}
