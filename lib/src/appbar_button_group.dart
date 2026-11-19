import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'appbar_button_style.dart';
import 'appbar_button_theme.dart';

/// Groups multiple [AppBarButton] widgets inside [AppBar.actions] or a custom
/// toolbar with consistent spacing, trailing inset padding, or a sleek unified
/// segmented capsule container.
class AppBarButtonGroup extends StatelessWidget {
  /// Creates a spaced group of app bar buttons.
  const AppBarButtonGroup({
    super.key,
    required this.children,
    this.spacing = 8.0,
    this.padding = const EdgeInsetsDirectional.only(end: 12.0),
    this.unified = false,
    this.variant = AppBarButtonVariant.tonal,
    this.shape = AppBarButtonShape.stadium,
    this.size = AppBarButtonSize.medium,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.showDividers = true,
    this.dividerColor,
    this.dividerWidth = 1.0,
    this.dividerHeight,
    this.blurSigma = 12.0,
    this.boxShadow,
  });

  /// Creates a unified segmented capsule grouping [children] inside a single
  /// modern container with optional hairline dividers.
  const AppBarButtonGroup.unified({
    super.key,
    required this.children,
    this.padding = const EdgeInsetsDirectional.only(end: 12.0),
    this.variant = AppBarButtonVariant.tonal,
    this.shape = AppBarButtonShape.stadium,
    this.size = AppBarButtonSize.medium,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.showDividers = true,
    this.dividerColor,
    this.dividerWidth = 1.0,
    this.dividerHeight,
    this.blurSigma = 12.0,
    this.boxShadow,
  })  : unified = true,
        spacing = 0.0;

  /// Buttons or toolbar widgets arranged horizontally.
  final List<Widget> children;

  /// Horizontal gap between buttons when [unified] is `false`.
  final double spacing;

  /// Outer padding around the group.
  ///
  /// Defaults to `EdgeInsetsDirectional.only(end: 12.0)` so trailing action
  /// buttons align cleanly with modern app bar margins.
  final EdgeInsetsGeometry padding;

  /// When `true`, merges all [children] into a single unified capsule surface.
  final bool unified;

  /// Surface variant used by the outer container when [unified] is `true`.
  final AppBarButtonVariant variant;

  /// Shape of the outer capsule when [unified] is `true`.
  final AppBarButtonShape shape;

  /// Size token coordinating capsule height and inner button heights when
  /// [unified] is `true`.
  final AppBarButtonSize size;

  /// Optional background color override for the unified capsule.
  final Color? backgroundColor;

  /// Optional border color override for the unified capsule.
  final Color? borderColor;

  /// Optional border width override for the unified capsule.
  final double? borderWidth;

  /// Optional corner radius override for [AppBarButtonShape.rounded] and
  /// [AppBarButtonShape.squircle] unified capsules.
  final BorderRadiusGeometry? borderRadius;

  /// Whether to render subtle vertical dividers between buttons in [unified]
  /// mode.
  final bool showDividers;

  /// Color of the hairline dividers in [unified] mode.
  final Color? dividerColor;

  /// Thickness of the vertical dividers in [unified] mode.
  final double dividerWidth;

  /// Explicit height of the vertical dividers in [unified] mode.
  final double? dividerHeight;

  /// Backdrop blur sigma used when [unified] is `true` and [variant] is
  /// [AppBarButtonVariant.glass].
  final double blurSigma;

  /// Optional custom shadows for the unified capsule.
  final List<BoxShadow>? boxShadow;

  ShapeBorder _resolveShape(BorderSide side, TextDirection textDirection) {
    final BorderRadiusGeometry effectiveRadius =
        borderRadius ?? BorderRadius.circular(size.radius);
    return switch (shape) {
      AppBarButtonShape.rounded => RoundedRectangleBorder(
          borderRadius: effectiveRadius,
          side: side,
        ),
      AppBarButtonShape.squircle => () {
          final BorderRadius resolved = effectiveRadius.resolve(textDirection);
          return ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(
                resolved.topLeft.x * 2.15,
                resolved.topLeft.y * 2.15,
              ),
              topRight: Radius.elliptical(
                resolved.topRight.x * 2.15,
                resolved.topRight.y * 2.15,
              ),
              bottomLeft: Radius.elliptical(
                resolved.bottomLeft.x * 2.15,
                resolved.bottomLeft.y * 2.15,
              ),
              bottomRight: Radius.elliptical(
                resolved.bottomRight.x * 2.15,
                resolved.bottomRight.y * 2.15,
              ),
            ),
            side: side,
          );
        }(),
      AppBarButtonShape.circle ||
      AppBarButtonShape.stadium =>
        StadiumBorder(side: side),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!unified) {
      final List<Widget> spaced = <Widget>[];
      for (int i = 0; i < children.length; i++) {
        if (i > 0 && spacing > 0) {
          spaced.add(SizedBox(width: spacing));
        }
        spaced.add(children[i]);
      }

      return Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: spaced,
          ),
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color ambientFg = IconTheme.of(context).color ?? cs.onSurface;
    final bool lightFg = ambientFg.computeLuminance() > 0.5;

    late Color resolvedBg;
    Color resolvedBorder = Colors.transparent;
    double resolvedBorderWidth = 0.0;
    List<BoxShadow>? resolvedShadows = boxShadow;

    switch (variant) {
      case AppBarButtonVariant.tonal:
        resolvedBg = backgroundColor ??
            ambientFg.withValues(alpha: lightFg ? 0.14 : 0.075);
      case AppBarButtonVariant.filled:
        resolvedBg = backgroundColor ?? cs.primary;
      case AppBarButtonVariant.outlined:
        resolvedBg = backgroundColor ?? Colors.transparent;
        resolvedBorder =
            borderColor ?? ambientFg.withValues(alpha: lightFg ? 0.30 : 0.18);
        resolvedBorderWidth = borderWidth ?? 1.0;
      case AppBarButtonVariant.ghost:
        resolvedBg = backgroundColor ?? Colors.transparent;
      case AppBarButtonVariant.elevated:
        resolvedBg =
            backgroundColor ?? (isDark ? cs.surfaceContainerHigh : cs.surface);
        resolvedBorder = borderColor ??
            cs.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.45);
        resolvedBorderWidth = borderWidth ?? 0.75;
        resolvedShadows ??= [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.34 : 0.10),
            blurRadius: 9.0,
            offset: const Offset(0, 2.5),
          ),
        ];
      case AppBarButtonVariant.glass:
        resolvedBg = backgroundColor ??
            (lightFg
                ? Colors.white.withValues(alpha: 0.18)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.68)));
        resolvedBorder = borderColor ??
            (lightFg
                ? Colors.white.withValues(alpha: 0.34)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.22)
                    : Colors.black.withValues(alpha: 0.10)));
        resolvedBorderWidth = borderWidth ?? 1.0;
    }

    if (borderColor != null) {
      resolvedBorder = borderColor!;
      resolvedBorderWidth = borderWidth ?? 1.0;
    }

    final Color resolvedDivider = dividerColor ??
        switch (variant) {
          AppBarButtonVariant.filled => cs.onPrimary.withValues(alpha: 0.24),
          AppBarButtonVariant.elevated => cs.onSurface.withValues(alpha: 0.14),
          _ => ambientFg.withValues(alpha: lightFg ? 0.22 : 0.14),
        };

    final double resolvedDividerHeight =
        dividerHeight ?? (size.dimension * 0.45);

    final List<Widget> segmentedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0 && showDividers) {
        segmentedChildren.add(
          Container(
            width: dividerWidth,
            height: resolvedDividerHeight,
            color: resolvedDivider,
          ),
        );
      }
      segmentedChildren.add(children[i]);
    }

    final AppBarButtonStyle inheritedStyle =
        AppBarButtonTheme.of(context).style;
    final Color? segmentForeground = switch (variant) {
      AppBarButtonVariant.filled =>
        backgroundColor == null ? cs.onPrimary : inheritedStyle.foregroundColor,
      AppBarButtonVariant.elevated =>
        backgroundColor == null ? cs.onSurface : inheritedStyle.foregroundColor,
      _ => inheritedStyle.foregroundColor,
    };
    final AppBarButtonStyle childSegmentStyle = inheritedStyle.copyWith(
      variant: AppBarButtonVariant.ghost,
      size: size,
      foregroundColor: segmentForeground,
      customShape: const RoundedRectangleBorder(),
      enableScaleAnimation: false,
      margin: EdgeInsets.zero,
    );

    final TextDirection textDirection =
        Directionality.maybeOf(context) ?? TextDirection.ltr;
    final BorderSide side = resolvedBorderWidth > 0 && resolvedBorder.a > 0
        ? BorderSide(color: resolvedBorder, width: resolvedBorderWidth)
        : BorderSide.none;
    final ShapeBorder outerShape = _resolveShape(side, textDirection);
    final ShapeBorder clipShape = _resolveShape(BorderSide.none, textDirection);

    final Widget capsuleContent = AppBarButtonTheme(
      data: AppBarButtonThemeData(style: childSegmentStyle),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: segmentedChildren,
      ),
    );

    Widget capsule;
    if (variant == AppBarButtonVariant.glass && blurSigma > 0) {
      capsule = DecoratedBox(
        decoration: resolvedShadows != null
            ? ShapeDecoration(shape: clipShape, shadows: resolvedShadows)
            : const BoxDecoration(),
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: clipShape),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: resolvedBg,
                shape: outerShape,
              ),
              child: capsuleContent,
            ),
          ),
        ),
      );
    } else {
      capsule = DecoratedBox(
        decoration: ShapeDecoration(
          color: resolvedBg,
          shape: outerShape,
          shadows: resolvedShadows,
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: clipShape),
          child: capsuleContent,
        ),
      );
    }

    return Center(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: Padding(
        padding: padding,
        child: capsule,
      ),
    );
  }
}
