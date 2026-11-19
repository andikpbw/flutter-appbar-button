import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

/// Visual surface style variants for [AppBarButton].
enum AppBarButtonVariant {
  /// A modern soft translucent/tinted surface that automatically adapts to
  /// light, dark, and colored [AppBar] backgrounds.
  tonal,

  /// A high-emphasis solid surface using the active theme's primary accent.
  filled,

  /// A minimal button framed by a crisp hairline border.
  outlined,

  /// A lightweight transparent surface that reveals a soft backdrop on
  /// hover, focus, or press.
  ghost,

  /// A floating surface with soft ambient elevation, ideal over media or maps.
  elevated,

  /// A frosted glassmorphic surface backed by a [BackdropFilter] blur and
  /// subtle specular border, ideal over gradients and imagery.
  glass,
}

/// Geometric shape presets for [AppBarButton].
enum AppBarButtonShape {
  /// Smooth rounded rectangle with size-matched corner radius.
  rounded,

  /// Continuous superellipse ("squircle") shape with organic corner curvature.
  squircle,

  /// Circular button when icon-only, gracefully adapting to a stadium capsule
  /// when a text label is displayed.
  circle,

  /// Full capsule / pill shape regardless of content width.
  stadium,
}

/// Preset size tokens for [AppBarButton].
enum AppBarButtonSize {
  /// Compact 34dp height button, ideal for dense toolbars or desktop headers.
  small,

  /// Balanced 40dp height button (default), fitting comfortably in standard
  /// 56dp [AppBar] toolbars.
  medium,

  /// Prominent 44dp height button for hero headers and large touch targets.
  large,
}

/// Optional haptic feedback intensity triggered when an [AppBarButton] is
/// tapped.
enum AppBarButtonHaptic {
  /// No haptic feedback.
  none,

  /// Subtle selection click feedback.
  selection,

  /// Light impact haptic feedback.
  light,

  /// Medium impact haptic feedback.
  medium,

  /// Heavy impact haptic feedback.
  heavy,
}

/// Internal dimensional metrics associated with each [AppBarButtonSize].
extension AppBarButtonSizeMetrics on AppBarButtonSize {
  /// Default visual height (and width for square/circular buttons).
  double get dimension => switch (this) {
    AppBarButtonSize.small => 34.0,
    AppBarButtonSize.medium => 40.0,
    AppBarButtonSize.large => 44.0,
  };

  /// Default icon size.
  double get iconSize => switch (this) {
    AppBarButtonSize.small => 18.0,
    AppBarButtonSize.medium => 20.0,
    AppBarButtonSize.large => 22.0,
  };

  /// Default label font size.
  double get fontSize => switch (this) {
    AppBarButtonSize.small => 12.5,
    AppBarButtonSize.medium => 13.5,
    AppBarButtonSize.large => 14.5,
  };

  /// Default horizontal padding for pill/labeled buttons.
  double get horizontalPadding => switch (this) {
    AppBarButtonSize.small => 10.0,
    AppBarButtonSize.medium => 13.0,
    AppBarButtonSize.large => 16.0,
  };

  /// Default corner radius for [AppBarButtonShape.rounded] and
  /// [AppBarButtonShape.squircle].
  double get radius => switch (this) {
    AppBarButtonSize.small => 10.0,
    AppBarButtonSize.medium => 12.0,
    AppBarButtonSize.large => 14.0,
  };

  /// Default horizontal gap between icon and label.
  double get gap => switch (this) {
    AppBarButtonSize.small => 5.0,
    AppBarButtonSize.medium => 6.0,
    AppBarButtonSize.large => 8.0,
  };
}

/// Comprehensive visual and behavioral styling configuration for
/// [AppBarButton].
///
/// Any null property falls back to the nearest [AppBarButtonTheme] or to
/// intelligent Material 3 defaults derived from the ambient [ThemeData] and
/// [IconTheme].
@immutable
class AppBarButtonStyle with Diagnosticable {
  /// Creates an [AppBarButtonStyle].
  const AppBarButtonStyle({
    this.variant,
    this.shape,
    this.size,
    this.backgroundColor,
    this.foregroundColor,
    this.hoverColor,
    this.pressedColor,
    this.splashColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.selectedBorderColor,
    this.borderColor,
    this.borderWidth,
    this.focusRingColor,
    this.focusRingWidth,
    this.borderRadius,
    this.customShape,
    this.width,
    this.height,
    this.minWidth,
    this.padding,
    this.margin,
    this.iconSize,
    this.gap,
    this.textStyle,
    this.elevation,
    this.shadowColor,
    this.boxShadow,
    this.blurSigma,
    this.disabledOpacity,
    this.pressedScale,
    this.enableScaleAnimation,
    this.animationDuration,
    this.scaleDuration,
    this.animationCurve,
    this.hapticFeedback,
    this.mouseCursor,
  });

  /// Visual variant of the button surface.
  final AppBarButtonVariant? variant;

  /// Preset shape of the button.
  final AppBarButtonShape? shape;

  /// Preset size token of the button.
  final AppBarButtonSize? size;

  /// Background fill color in the unselected idle state.
  final Color? backgroundColor;

  /// Icon and label color in the unselected idle state.
  final Color? foregroundColor;

  /// Background overlay color when hovered with a pointer.
  final Color? hoverColor;

  /// Background overlay color while actively pressed.
  final Color? pressedColor;

  /// Ink splash color emitted on tap.
  final Color? splashColor;

  /// Background color when the button is selected/toggled on.
  final Color? selectedBackgroundColor;

  /// Foreground color when the button is selected/toggled on.
  final Color? selectedForegroundColor;

  /// Border color when the button is selected/toggled on.
  final Color? selectedBorderColor;

  /// Border color in the idle unselected state.
  final Color? borderColor;

  /// Width of the border stroke in logical pixels.
  final double? borderWidth;

  /// Color of the keyboard focus ring.
  final Color? focusRingColor;

  /// Width of the keyboard focus ring stroke in logical pixels.
  final double? focusRingWidth;

  /// Custom corner radius applied to [AppBarButtonShape.rounded] and
  /// [AppBarButtonShape.squircle].
  final BorderRadiusGeometry? borderRadius;

  /// Explicit [ShapeBorder] that overrides [shape] and [borderRadius].
  final ShapeBorder? customShape;

  /// Explicit visual width of the button.
  final double? width;

  /// Explicit visual height of the button.
  final double? height;

  /// Minimum width of the button.
  final double? minWidth;

  /// Inner padding around the button content.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the button.
  final EdgeInsetsGeometry? margin;

  /// Explicit icon size in logical pixels.
  final double? iconSize;

  /// Spacing between icon and label when both are displayed.
  final double? gap;

  /// Custom [TextStyle] for the button label.
  final TextStyle? textStyle;

  /// Elevation amount used to synthesize default shadows for
  /// [AppBarButtonVariant.elevated].
  final double? elevation;

  /// Shadow color used when [boxShadow] is not explicitly supplied.
  final Color? shadowColor;

  /// Explicit list of [BoxShadow]s drawn behind the button.
  final List<BoxShadow>? boxShadow;

  /// Blur sigma applied to the backdrop when using [AppBarButtonVariant.glass].
  final double? blurSigma;

  /// Opacity multiplier applied to the foreground when disabled.
  final double? disabledOpacity;

  /// Scale factor applied while the button is pressed down (defaults to `0.93`).
  final double? pressedScale;

  /// Whether the micro-interaction press scale animation is enabled.
  final bool? enableScaleAnimation;

  /// Duration for color, border, and surface transitions.
  final Duration? animationDuration;

  /// Duration for the press scale micro-interaction.
  final Duration? scaleDuration;

  /// Curve used for state transitions.
  final Curve? animationCurve;

  /// Haptic feedback intensity triggered on tap.
  final AppBarButtonHaptic? hapticFeedback;

  /// Mouse cursor displayed when hovering over an enabled button.
  final MouseCursor? mouseCursor;

  /// Returns a copy of this style with the specified fields overridden.
  AppBarButtonStyle copyWith({
    AppBarButtonVariant? variant,
    AppBarButtonShape? shape,
    AppBarButtonSize? size,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? hoverColor,
    Color? pressedColor,
    Color? splashColor,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    Color? selectedBorderColor,
    Color? borderColor,
    double? borderWidth,
    Color? focusRingColor,
    double? focusRingWidth,
    BorderRadiusGeometry? borderRadius,
    ShapeBorder? customShape,
    double? width,
    double? height,
    double? minWidth,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? iconSize,
    double? gap,
    TextStyle? textStyle,
    double? elevation,
    Color? shadowColor,
    List<BoxShadow>? boxShadow,
    double? blurSigma,
    double? disabledOpacity,
    double? pressedScale,
    bool? enableScaleAnimation,
    Duration? animationDuration,
    Duration? scaleDuration,
    Curve? animationCurve,
    AppBarButtonHaptic? hapticFeedback,
    MouseCursor? mouseCursor,
  }) {
    return AppBarButtonStyle(
      variant: variant ?? this.variant,
      shape: shape ?? this.shape,
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      hoverColor: hoverColor ?? this.hoverColor,
      pressedColor: pressedColor ?? this.pressedColor,
      splashColor: splashColor ?? this.splashColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      selectedForegroundColor:
          selectedForegroundColor ?? this.selectedForegroundColor,
      selectedBorderColor: selectedBorderColor ?? this.selectedBorderColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      customShape: customShape ?? this.customShape,
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
      textStyle: textStyle ?? this.textStyle,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      boxShadow: boxShadow ?? this.boxShadow,
      blurSigma: blurSigma ?? this.blurSigma,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      pressedScale: pressedScale ?? this.pressedScale,
      enableScaleAnimation: enableScaleAnimation ?? this.enableScaleAnimation,
      animationDuration: animationDuration ?? this.animationDuration,
      scaleDuration: scaleDuration ?? this.scaleDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  /// Merges [other] on top of this style, preferring non-null values from
  /// [other].
  AppBarButtonStyle merge(AppBarButtonStyle? other) {
    if (other == null) {
      return this;
    }
    return copyWith(
      variant: other.variant,
      shape: other.shape,
      size: other.size,
      backgroundColor: other.backgroundColor,
      foregroundColor: other.foregroundColor,
      hoverColor: other.hoverColor,
      pressedColor: other.pressedColor,
      splashColor: other.splashColor,
      selectedBackgroundColor: other.selectedBackgroundColor,
      selectedForegroundColor: other.selectedForegroundColor,
      selectedBorderColor: other.selectedBorderColor,
      borderColor: other.borderColor,
      borderWidth: other.borderWidth,
      focusRingColor: other.focusRingColor,
      focusRingWidth: other.focusRingWidth,
      borderRadius: other.borderRadius,
      customShape: other.customShape,
      width: other.width,
      height: other.height,
      minWidth: other.minWidth,
      padding: other.padding,
      margin: other.margin,
      iconSize: other.iconSize,
      gap: other.gap,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      elevation: other.elevation,
      shadowColor: other.shadowColor,
      boxShadow: other.boxShadow,
      blurSigma: other.blurSigma,
      disabledOpacity: other.disabledOpacity,
      pressedScale: other.pressedScale,
      enableScaleAnimation: other.enableScaleAnimation,
      animationDuration: other.animationDuration,
      scaleDuration: other.scaleDuration,
      animationCurve: other.animationCurve,
      hapticFeedback: other.hapticFeedback,
      mouseCursor: other.mouseCursor,
    );
  }

  /// Linearly interpolates between two [AppBarButtonStyle] instances.
  static AppBarButtonStyle? lerp(
    AppBarButtonStyle? a,
    AppBarButtonStyle? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }
    return AppBarButtonStyle(
      variant: t < 0.5 ? a?.variant : b?.variant,
      shape: t < 0.5 ? a?.shape : b?.shape,
      size: t < 0.5 ? a?.size : b?.size,
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
      hoverColor: Color.lerp(a?.hoverColor, b?.hoverColor, t),
      pressedColor: Color.lerp(a?.pressedColor, b?.pressedColor, t),
      splashColor: Color.lerp(a?.splashColor, b?.splashColor, t),
      selectedBackgroundColor: Color.lerp(
        a?.selectedBackgroundColor,
        b?.selectedBackgroundColor,
        t,
      ),
      selectedForegroundColor: Color.lerp(
        a?.selectedForegroundColor,
        b?.selectedForegroundColor,
        t,
      ),
      selectedBorderColor: Color.lerp(
        a?.selectedBorderColor,
        b?.selectedBorderColor,
        t,
      ),
      borderColor: Color.lerp(a?.borderColor, b?.borderColor, t),
      borderWidth: lerpDouble(a?.borderWidth, b?.borderWidth, t),
      focusRingColor: Color.lerp(a?.focusRingColor, b?.focusRingColor, t),
      focusRingWidth: lerpDouble(a?.focusRingWidth, b?.focusRingWidth, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a?.borderRadius,
        b?.borderRadius,
        t,
      ),
      customShape: ShapeBorder.lerp(a?.customShape, b?.customShape, t),
      width: lerpDouble(a?.width, b?.width, t),
      height: lerpDouble(a?.height, b?.height, t),
      minWidth: lerpDouble(a?.minWidth, b?.minWidth, t),
      padding: EdgeInsetsGeometry.lerp(a?.padding, b?.padding, t),
      margin: EdgeInsetsGeometry.lerp(a?.margin, b?.margin, t),
      iconSize: lerpDouble(a?.iconSize, b?.iconSize, t),
      gap: lerpDouble(a?.gap, b?.gap, t),
      textStyle: TextStyle.lerp(a?.textStyle, b?.textStyle, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      boxShadow: BoxShadow.lerpList(a?.boxShadow, b?.boxShadow, t),
      blurSigma: lerpDouble(a?.blurSigma, b?.blurSigma, t),
      disabledOpacity: lerpDouble(a?.disabledOpacity, b?.disabledOpacity, t),
      pressedScale: lerpDouble(a?.pressedScale, b?.pressedScale, t),
      enableScaleAnimation: t < 0.5
          ? a?.enableScaleAnimation
          : b?.enableScaleAnimation,
      animationDuration: t < 0.5 ? a?.animationDuration : b?.animationDuration,
      scaleDuration: t < 0.5 ? a?.scaleDuration : b?.scaleDuration,
      animationCurve: t < 0.5 ? a?.animationCurve : b?.animationCurve,
      hapticFeedback: t < 0.5 ? a?.hapticFeedback : b?.hapticFeedback,
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppBarButtonStyle &&
        other.variant == variant &&
        other.shape == shape &&
        other.size == size &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.hoverColor == hoverColor &&
        other.pressedColor == pressedColor &&
        other.splashColor == splashColor &&
        other.selectedBackgroundColor == selectedBackgroundColor &&
        other.selectedForegroundColor == selectedForegroundColor &&
        other.selectedBorderColor == selectedBorderColor &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.focusRingColor == focusRingColor &&
        other.focusRingWidth == focusRingWidth &&
        other.borderRadius == borderRadius &&
        other.customShape == customShape &&
        other.width == width &&
        other.height == height &&
        other.minWidth == minWidth &&
        other.padding == padding &&
        other.margin == margin &&
        other.iconSize == iconSize &&
        other.gap == gap &&
        other.textStyle == textStyle &&
        other.elevation == elevation &&
        other.shadowColor == shadowColor &&
        listEquals(other.boxShadow, boxShadow) &&
        other.blurSigma == blurSigma &&
        other.disabledOpacity == disabledOpacity &&
        other.pressedScale == pressedScale &&
        other.enableScaleAnimation == enableScaleAnimation &&
        other.animationDuration == animationDuration &&
        other.scaleDuration == scaleDuration &&
        other.animationCurve == animationCurve &&
        other.hapticFeedback == hapticFeedback &&
        other.mouseCursor == mouseCursor;
  }

  @override
  int get hashCode => Object.hashAll([
    variant,
    shape,
    size,
    backgroundColor,
    foregroundColor,
    hoverColor,
    pressedColor,
    splashColor,
    selectedBackgroundColor,
    selectedForegroundColor,
    selectedBorderColor,
    borderColor,
    borderWidth,
    focusRingColor,
    focusRingWidth,
    borderRadius,
    customShape,
    width,
    height,
    minWidth,
    padding,
    margin,
    iconSize,
    gap,
    textStyle,
    elevation,
    shadowColor,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    blurSigma,
    disabledOpacity,
    pressedScale,
    enableScaleAnimation,
    animationDuration,
    scaleDuration,
    animationCurve,
    hapticFeedback,
    mouseCursor,
  ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        EnumProperty<AppBarButtonVariant>(
          'variant',
          variant,
          defaultValue: null,
        ),
      )
      ..add(EnumProperty<AppBarButtonShape>('shape', shape, defaultValue: null))
      ..add(EnumProperty<AppBarButtonSize>('size', size, defaultValue: null))
      ..add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null),
      )
      ..add(
        ColorProperty('foregroundColor', foregroundColor, defaultValue: null),
      )
      ..add(ColorProperty('borderColor', borderColor, defaultValue: null))
      ..add(DoubleProperty('borderWidth', borderWidth, defaultValue: null))
      ..add(DoubleProperty('width', width, defaultValue: null))
      ..add(DoubleProperty('height', height, defaultValue: null))
      ..add(DoubleProperty('iconSize', iconSize, defaultValue: null))
      ..add(DoubleProperty('blurSigma', blurSigma, defaultValue: null))
      ..add(DoubleProperty('pressedScale', pressedScale, defaultValue: null))
      ..add(
        EnumProperty<AppBarButtonHaptic>(
          'hapticFeedback',
          hapticFeedback,
          defaultValue: null,
        ),
      );
  }
}
