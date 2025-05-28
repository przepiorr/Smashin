import 'package:flutter/material.dart';
import 'styl.dart'; // zakładam, że masz tam AppColor

ButtonStyle dekoracjabutton({
  Color? backgroundColor,
  Color? borderColor,
  Color? textColor,
  Color? overlayColor,
}) {
  final backcolor = backgroundColor ?? AppColor.inputbackground;
  final bordercolor = borderColor ?? AppColor.border;
  final textcolor = textColor ?? AppColor.text;
  final highlightcolor = overlayColor ?? Colors.white.withValues(alpha: (0.3)); // efekt kliknięcia

  return ButtonStyle(
    backgroundColor: WidgetStateProperty.all(backcolor),
    foregroundColor: WidgetStateProperty.all(textcolor),
    side: WidgetStateProperty.all(
      BorderSide(
        color: bordercolor,
        width: 2.0,
      ),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // większe zaokrąglenie
      ),
    ),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(vertical: 14.0, horizontal: 32.0), // więcej przestrzeni
    ),
    elevation: WidgetStateProperty.all(1), // delikatny cień
    overlayColor: WidgetStateProperty.all(highlightcolor), // kliknięcie efekt
    textStyle: WidgetStateProperty.all(
      TextStyle(
        fontSize: 16,
      ),
    ),
  );
}
