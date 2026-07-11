import 'package:flutter/material.dart';

@immutable
class AppBrandingExtension extends ThemeExtension<AppBrandingExtension> {
  const AppBrandingExtension({
    required this.splashGradientStart,
    required this.splashGradientEnd,
  });

  final Color splashGradientStart;
  final Color splashGradientEnd;

  @override
  AppBrandingExtension copyWith({
    Color? splashGradientStart,
    Color? splashGradientEnd,
  }) {
    return AppBrandingExtension(
      splashGradientStart: splashGradientStart ?? this.splashGradientStart,
      splashGradientEnd: splashGradientEnd ?? this.splashGradientEnd,
    );
  }

  @override
  AppBrandingExtension lerp(
    covariant ThemeExtension<AppBrandingExtension>? other,
    double t,
  ) {
    if (other is! AppBrandingExtension) return this;
    return AppBrandingExtension(
      splashGradientStart:
          Color.lerp(splashGradientStart, other.splashGradientStart, t) ??
              splashGradientStart,
      splashGradientEnd:
          Color.lerp(splashGradientEnd, other.splashGradientEnd, t) ??
              splashGradientEnd,
    );
  }
}
