
import 'package:flutter/material.dart';
import 'styl.dart'; //


InputDecoration dekoracjainput({
  required String labelText,
  required String hintText,
  Color? borderColor,
  Color? focusColor,
}) {
  final backcolor = AppColor.inputbackground;
  final bordercolor = borderColor ?? AppColor.border;
  final focusbordercolor = focusColor ?? Colors.blue;

  return InputDecoration(
    filled: true,
    fillColor: backcolor,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: bordercolor,
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: focusbordercolor,
        width: 2.5,
      ),
    ),
    labelText: labelText,
    labelStyle: TextStyle(
      color: AppColor.text,
      fontSize: 14,
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: AppColor.text,
      fontSize: 14,
    ),
  );
}
