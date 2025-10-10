import 'package:flutter/material.dart';
import 'fonts_manager.dart';

// THE FIX: Change 'Color color' to 'Color? color' to make it nullable
TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color? color) {
  // If color is null, TextStyle will inherit its color from the theme
  return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: 'NothingDotted');
}

// THE FIX: Change 'required Color color' to 'Color? color' on all functions below

// light style 300
TextStyle getLightStyle({double fontSize = MyFonts.size14, Color? color}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

// regular style 400
TextStyle getRegularStyle({double fontSize = MyFonts.size16, Color? color}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

// medium style 500
TextStyle getMediumStyle({double fontSize = MyFonts.size16, Color? color}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

// semibold style 600
TextStyle getSemiBoldStyle({double fontSize = MyFonts.size14, Color? color}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}

// bold style 700
TextStyle getBoldStyle({double fontSize = MyFonts.size14, Color? color}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}

// extra bold style 800
TextStyle getExtraBoldStyle({double fontSize = MyFonts.size14, Color? color}) {
  return _getTextStyle(fontSize, FontWeightManager.extraBold, color);
}
