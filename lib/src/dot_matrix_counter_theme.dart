import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Available transition styles for each character update.
enum DotMatrixAnimationStyle {
  fadeScale,
  slide,
  flip,
}

@immutable
class DotMatrixCounterThemeData extends ThemeExtension<DotMatrixCounterThemeData> {
  final double dotSize;
  final double dotSpacing;
  final double digitSpacing;
  final Color glowColor;
  final Color onColor;
  final Color offColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final DotMatrixAnimationStyle animationStyle;
  final double glowBlurRadius;
  final double glowSpreadRadius;
  final EdgeInsetsGeometry padding;

  const DotMatrixCounterThemeData({
    this.dotSize = 10,
    this.dotSpacing = 2,
    this.digitSpacing = 10,
    this.glowColor = Colors.cyanAccent,
    this.onColor = Colors.white,
    this.offColor = const Color(0xFF1A1A1A),
    this.animationDuration = const Duration(milliseconds: 350),
    this.animationCurve = Curves.easeOutCubic,
    this.animationStyle = DotMatrixAnimationStyle.fadeScale,
    this.glowBlurRadius = 12,
    this.glowSpreadRadius = 3,
    this.padding = EdgeInsets.zero,
  });

  static const fallback = DotMatrixCounterThemeData();

  @override
  DotMatrixCounterThemeData copyWith({
    double? dotSize,
    double? dotSpacing,
    double? digitSpacing,
    Color? glowColor,
    Color? onColor,
    Color? offColor,
    Duration? animationDuration,
    Curve? animationCurve,
    DotMatrixAnimationStyle? animationStyle,
    double? glowBlurRadius,
    double? glowSpreadRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return DotMatrixCounterThemeData(
      dotSize: dotSize ?? this.dotSize,
      dotSpacing: dotSpacing ?? this.dotSpacing,
      digitSpacing: digitSpacing ?? this.digitSpacing,
      glowColor: glowColor ?? this.glowColor,
      onColor: onColor ?? this.onColor,
      offColor: offColor ?? this.offColor,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      animationStyle: animationStyle ?? this.animationStyle,
      glowBlurRadius: glowBlurRadius ?? this.glowBlurRadius,
      glowSpreadRadius: glowSpreadRadius ?? this.glowSpreadRadius,
      padding: padding ?? this.padding,
    );
  }

  DotMatrixCounterThemeData merge(DotMatrixCounterThemeData? other) {
    if (other == null) {
      return this;
    }

    return copyWith(
      dotSize: other.dotSize,
      dotSpacing: other.dotSpacing,
      digitSpacing: other.digitSpacing,
      glowColor: other.glowColor,
      onColor: other.onColor,
      offColor: other.offColor,
      animationDuration: other.animationDuration,
      animationCurve: other.animationCurve,
      animationStyle: other.animationStyle,
      glowBlurRadius: other.glowBlurRadius,
      glowSpreadRadius: other.glowSpreadRadius,
      padding: other.padding,
    );
  }

  @override
  DotMatrixCounterThemeData lerp(
    ThemeExtension<DotMatrixCounterThemeData>? other,
    double t,
  ) {
    if (other is! DotMatrixCounterThemeData) {
      return this;
    }

    return DotMatrixCounterThemeData(
      dotSize: lerpDouble(dotSize, other.dotSize, t) ?? dotSize,
      dotSpacing: lerpDouble(dotSpacing, other.dotSpacing, t) ?? dotSpacing,
      digitSpacing: lerpDouble(digitSpacing, other.digitSpacing, t) ?? digitSpacing,
      glowColor: Color.lerp(glowColor, other.glowColor, t) ?? glowColor,
      onColor: Color.lerp(onColor, other.onColor, t) ?? onColor,
      offColor: Color.lerp(offColor, other.offColor, t) ?? offColor,
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      animationCurve: t < 0.5 ? animationCurve : other.animationCurve,
      animationStyle: t < 0.5 ? animationStyle : other.animationStyle,
      glowBlurRadius: lerpDouble(glowBlurRadius, other.glowBlurRadius, t) ?? glowBlurRadius,
      glowSpreadRadius: lerpDouble(glowSpreadRadius, other.glowSpreadRadius, t) ?? glowSpreadRadius,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
    );
  }
}

/// Helper that applies [DotMatrixCounterThemeData] into Flutter's [ThemeData]
/// extensions for the wrapped subtree.
class DotMatrixCounterTheme extends StatelessWidget {
  final DotMatrixCounterThemeData data;
  final Widget child;

  const DotMatrixCounterTheme({
    super.key,
    required this.data,
    required this.child,
  });

  static DotMatrixCounterThemeData of(BuildContext context) {
    return Theme.of(context).extension<DotMatrixCounterThemeData>() ??
        DotMatrixCounterThemeData.fallback;
  }

  static ThemeData apply(ThemeData baseTheme, DotMatrixCounterThemeData data) {
    final extensions = List<ThemeExtension<dynamic>>.from(
      baseTheme.extensions.values.where(
        (extension) => extension is! DotMatrixCounterThemeData,
      ),
    )..add(data);

    return baseTheme.copyWith(
      extensions: extensions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: apply(Theme.of(context), data),
      child: child,
    );
  }
}
