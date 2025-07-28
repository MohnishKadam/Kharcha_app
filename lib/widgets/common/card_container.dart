import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? borderRadius;
  final BoxBorder? border;

  const CardContainer({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(borderRadius ?? AppBorderRadius.lg),
        border: border ?? Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: child,
    );
  }
}

class GradientCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final List<Color>? gradientColors;
  final double? borderRadius;

  const GradientCardContainer({
    super.key,
    required this.child,
    this.padding,
    this.gradientColors,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors ??
              [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? AppBorderRadius.lg),
        boxShadow: AppShadow.medium,
      ),
      child: child,
    );
  }
}
