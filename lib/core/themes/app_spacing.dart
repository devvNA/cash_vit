import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing (4px)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // Screen padding
  static const double paddingScreen = 24;
  static const double paddingCard = 20;

  // EdgeInsets helpers
  static const EdgeInsets screenPadding = EdgeInsets.all(paddingScreen);
  static const EdgeInsets cardPadding = EdgeInsets.all(paddingCard);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: paddingScreen,
  );
}

class AppRadius {
  AppRadius._();

  static const double small = 12;
  static const double medium = 16;
  static const double large = 20;
  static const double card = 24;
  static const double button = 24;
  static const double full = 999;

  // BorderRadius helpers
  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
}

class AppShadow {
  AppShadow._();

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: const Color(0xFF1565C0).withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
