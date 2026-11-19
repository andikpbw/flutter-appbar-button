import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'appbar_button_badge.dart';
import 'appbar_button_style.dart';
import 'appbar_button_theme.dart';

enum _AppBarButtonPresetAction {
  none,
  back,
  close,
  drawer,
  endDrawer,
}

/// A modern, lightweight, and highly customizable button designed for
/// [AppBar.leading], [AppBar.actions], [SliverAppBar], and custom toolbars.
///
/// Features six built-in visual variants ([AppBarButtonVariant]), four shape
/// presets ([AppBarButtonShape]), three size tokens ([AppBarButtonSize]),
/// smooth press-scale micro-interactions, notification badges
/// ([AppBarButtonBadge]), inline loading states, toggle selection animations,
/// keyboard focus indicators, RTL awareness, and automatic color adaptation
/// across light, dark, and colored app bars.
class AppBarButton extends StatefulWidget {
  /// Creates a customizable [AppBarButton].
  ///
  /// At least one of [icon], [label], or [child] must be provided.
  const AppBarButton({
    super.key,
    this.icon,
    this.selectedIcon,
    this.label,
    this.selectedLabel,
    this.child,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.isSelected = false,
    this.enabled = true,
    this.iconAlignment = IconAlignment.start,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : assert(
          icon != null || label != null || child != null,
          'At least one of icon, label, or child must be provided.',
        ),
        _iconData = null,
        _selectedIconData = null,
        _presetAction = _AppBarButtonPresetAction.none,
        _hideWhenCannotPop = false,
        _isAvatar = false;

  /// Creates an icon-only [AppBarButton] from an [IconData].
  const AppBarButton.icon(
    IconData icon, {
    super.key,
    IconData? selectedIcon,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.isSelected = false,
    this.enabled = true,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : _iconData = icon,
        _selectedIconData = selectedIcon,
        icon = null,
        selectedIcon = null,
        label = null,
        selectedLabel = null,
        child = null,
        iconAlignment = IconAlignment.start,
        _presetAction = _AppBarButtonPresetAction.none,
        _hideWhenCannotPop = false,
        _isAvatar = false;

  /// Creates an adaptive back navigation button.
  ///
  /// When [onPressed] is `null` and [enabled] is `true`, tapping calls
  /// `Navigator.maybePop(context)`. Automatically selects a platform-adaptive
  /// back icon (chevron on iOS/macOS, arrow on other platforms) unless [icon]
  /// is explicitly supplied, and uses the localized back tooltip by default.
  ///
  /// Set [hideWhenCannotPop] to `true` to collapse into a [SizedBox.shrink]
  /// when the current route cannot be popped.
  const AppBarButton.back({
    super.key,
    IconData? icon,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.enabled = true,
    bool hideWhenCannotPop = false,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : _iconData = icon,
        _selectedIconData = null,
        icon = null,
        selectedIcon = null,
        label = null,
        selectedLabel = null,
        child = null,
        isSelected = false,
        iconAlignment = IconAlignment.start,
        _presetAction = _AppBarButtonPresetAction.back,
        _hideWhenCannotPop = hideWhenCannotPop,
        _isAvatar = false;

  /// Creates a modern close / dismiss button.
  ///
  /// When [onPressed] is `null` and [enabled] is `true`, tapping calls
  /// `Navigator.maybePop(context)`. Uses the localized close tooltip by
  /// default.
  const AppBarButton.close({
    super.key,
    IconData icon = Icons.close_rounded,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.enabled = true,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : _iconData = icon,
        _selectedIconData = null,
        icon = null,
        selectedIcon = null,
        label = null,
        selectedLabel = null,
        child = null,
        isSelected = false,
        iconAlignment = IconAlignment.start,
        _presetAction = _AppBarButtonPresetAction.close,
        _hideWhenCannotPop = false,
        _isAvatar = false;

  /// Creates a navigation drawer menu button.
  ///
  /// When [onPressed] is `null` and [enabled] is `true`, tapping opens the
  /// nearest [Scaffold]'s drawer (or end drawer when [isEndDrawer] is `true`).
  const AppBarButton.menu({
    super.key,
    IconData icon = Icons.menu_rounded,
    bool isEndDrawer = false,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.enabled = true,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : _iconData = icon,
        _selectedIconData = null,
        icon = null,
        selectedIcon = null,
        label = null,
        selectedLabel = null,
        child = null,
        isSelected = false,
        iconAlignment = IconAlignment.start,
        _presetAction = isEndDrawer
            ? _AppBarButtonPresetAction.endDrawer
            : _AppBarButtonPresetAction.drawer,
        _hideWhenCannotPop = false,
        _isAvatar = false;

  /// Creates a capsule pill button displaying a [label] with an optional
  /// leading or trailing [icon] / [iconWidget].
  const AppBarButton.pill({
    super.key,
    required String this.label,
    this.selectedLabel,
    IconData? icon,
    IconData? selectedIcon,
    Widget? iconWidget,
    Widget? selectedIconWidget,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape = AppBarButtonShape.stadium,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.isSelected = false,
    this.enabled = true,
    this.iconAlignment = IconAlignment.start,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : _iconData = icon,
        _selectedIconData = selectedIcon,
        icon = iconWidget,
        selectedIcon = selectedIconWidget,
        child = null,
        _presetAction = _AppBarButtonPresetAction.none,
        _hideWhenCannotPop = false,
        _isAvatar = false;

  /// Creates a toggleable button that smoothly transitions between unselected
  /// and selected icons, labels, and surfaces.
  const AppBarButton.toggle({
    super.key,
    required IconData icon,
    IconData? selectedIcon,
    required this.isSelected,
    this.label,
    this.selectedLabel,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant,
    this.shape,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.enabled = true,
    this.iconAlignment = IconAlignment.start,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : _iconData = icon,
        _selectedIconData = selectedIcon,
        icon = null,
        selectedIcon = null,
        child = null,
        _presetAction = _AppBarButtonPresetAction.none,
        _hideWhenCannotPop = false,
        _isAvatar = false;

  /// Creates a profile or brand avatar button with clean shape clipping,
  /// subtle framing border, and optional status [badge].
  const AppBarButton.avatar({
    super.key,
    required Widget avatar,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.variant = AppBarButtonVariant.outlined,
    this.shape = AppBarButtonShape.circle,
    this.size,
    this.style,
    this.badge,
    this.isLoading = false,
    this.loadingIndicator,
    this.enabled = true,
    this.tooltip,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.excludeFromSemantics = false,
  })  : child = avatar,
        icon = null,
        selectedIcon = null,
        label = null,
        selectedLabel = null,
        _iconData = null,
        _selectedIconData = null,
        isSelected = false,
        iconAlignment = IconAlignment.start,
        _presetAction = _AppBarButtonPresetAction.none,
        _hideWhenCannotPop = false,
        _isAvatar = true;

  /// Primary icon widget shown when unselected (or always if [selectedIcon] is
  /// omitted).
  final Widget? icon;

  /// Optional icon widget shown when [isSelected] is `true`.
  final Widget? selectedIcon;

  /// Optional text label shown next to the icon or on its own.
  final String? label;

  /// Optional text label shown when [isSelected] is `true`.
  final String? selectedLabel;

  /// Optional custom child widget replacing the default icon/label layout.
  final Widget? child;

  /// Callback invoked when the button is tapped.
  final VoidCallback? onPressed;

  /// Callback invoked when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback invoked when a pointer enters or exits the button.
  final ValueChanged<bool>? onHover;

  /// Callback invoked when the button's keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Visual surface variant overriding [AppBarButtonStyle.variant].
  final AppBarButtonVariant? variant;

  /// Geometric shape preset overriding [AppBarButtonStyle.shape].
  final AppBarButtonShape? shape;

  /// Size preset overriding [AppBarButtonStyle.size].
  final AppBarButtonSize? size;

  /// Fine-grained visual and animation style overrides.
  final AppBarButtonStyle? style;

  /// Optional notification dot, counter, or label badge.
  final AppBarButtonBadge? badge;

  /// Whether the button is currently performing an asynchronous action.
  ///
  /// While `true`, taps are ignored and an inline loading indicator is
  /// smoothly displayed without shifting the button's dimensions.
  final bool isLoading;

  /// Optional custom loading indicator widget shown when [isLoading] is `true`.
  final Widget? loadingIndicator;

  /// Whether the button is in its active/selected toggle state.
  final bool isSelected;

  /// Whether the button responds to user interaction.
  final bool enabled;

  /// Controls whether the icon appears before or after [label].
  final IconAlignment iconAlignment;

  /// Optional tooltip message shown on long-press or mouse hover.
  final String? tooltip;

  /// Optional screen-reader label overriding [tooltip] and [label].
  final String? semanticLabel;

  /// Optional focus node for keyboard navigation control.
  final FocusNode? focusNode;

  /// Whether this button should request focus automatically when mounted.
  final bool autofocus;

  /// Whether to exclude this button from the semantics tree.
  final bool excludeFromSemantics;

  final IconData? _iconData;
  final IconData? _selectedIconData;
  final _AppBarButtonPresetAction _presetAction;
  final bool _hideWhenCannotPop;
  final bool _isAvatar;

  @override
  State<AppBarButton> createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  void didUpdateWidget(covariant AppBarButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isInteractive && (_isPressed || _isHovered)) {
      _isPressed = false;
      _isHovered = false;
    }
  }

  bool get _hasPresetAction =>
      widget._presetAction != _AppBarButtonPresetAction.none;

  bool get _hasInteractiveCallback =>
      widget.onPressed != null ||
      widget.onLongPress != null ||
      _hasPresetAction;

  bool get _isInteractive =>
      widget.enabled && !widget.isLoading && _hasInteractiveCallback;

  VoidCallback? _resolveOnPressed(BuildContext context) {
    if (!widget.enabled || widget.isLoading) {
      return null;
    }
    if (widget.onPressed != null) {
      return () {
        _triggerHaptic(context);
        widget.onPressed?.call();
      };
    }
    if (!_hasPresetAction) {
      return null;
    }
    return () {
      _triggerHaptic(context);
      switch (widget._presetAction) {
        case _AppBarButtonPresetAction.back:
        case _AppBarButtonPresetAction.close:
          Navigator.maybePop(context);
        case _AppBarButtonPresetAction.drawer:
          Scaffold.maybeOf(context)?.openDrawer();
        case _AppBarButtonPresetAction.endDrawer:
          Scaffold.maybeOf(context)?.openEndDrawer();
        case _AppBarButtonPresetAction.none:
          break;
      }
    };
  }

  VoidCallback? _resolveOnLongPress(BuildContext context) {
    if (!widget.enabled || widget.isLoading || widget.onLongPress == null) {
      return null;
    }
    return () {
      _triggerHaptic(context);
      widget.onLongPress?.call();
    };
  }

  AppBarButtonStyle _resolveStyle(BuildContext context) {
    final AppBarButtonStyle themeStyle = AppBarButtonTheme.of(context).style;
    final AppBarButtonStyle merged = themeStyle.merge(widget.style);
    return merged.copyWith(
      variant: widget.variant ?? merged.variant,
      shape: widget.shape ?? merged.shape,
      size: widget.size ?? merged.size,
    );
  }

  void _triggerHaptic(BuildContext context) {
    final AppBarButtonHaptic haptic =
        _resolveStyle(context).hapticFeedback ?? AppBarButtonHaptic.none;
    switch (haptic) {
      case AppBarButtonHaptic.none:
        break;
      case AppBarButtonHaptic.selection:
        HapticFeedback.selectionClick();
      case AppBarButtonHaptic.light:
        HapticFeedback.lightImpact();
      case AppBarButtonHaptic.medium:
        HapticFeedback.mediumImpact();
      case AppBarButtonHaptic.heavy:
        HapticFeedback.heavyImpact();
    }
  }

  String? _resolveTooltip(BuildContext context) {
    if (widget.tooltip != null) {
      return widget.tooltip!.isEmpty ? null : widget.tooltip;
    }
    final MaterialLocalizations? localizations =
        Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
    return switch (widget._presetAction) {
      _AppBarButtonPresetAction.back =>
        localizations?.backButtonTooltip ?? 'Back',
      _AppBarButtonPresetAction.close =>
        localizations?.closeButtonTooltip ?? 'Close',
      _AppBarButtonPresetAction.drawer ||
      _AppBarButtonPresetAction.endDrawer =>
        localizations?.openAppDrawerTooltip ?? 'Open navigation menu',
      _AppBarButtonPresetAction.none => null,
    };
  }

  ShapeBorder _resolveShape({
    required AppBarButtonStyle style,
    required AppBarButtonShape shapePreset,
    required AppBarButtonSize sizePreset,
    required bool hasLabel,
    required BorderSide side,
  }) {
    if (style.customShape != null) {
      final ShapeBorder custom = style.customShape!;
      if (custom is OutlinedBorder && side != BorderSide.none) {
        return custom.copyWith(side: side);
      }
      return custom;
    }

    final BorderRadiusGeometry effectiveRadius =
        style.borderRadius ?? BorderRadius.circular(sizePreset.radius);

    return switch (shapePreset) {
      AppBarButtonShape.rounded => RoundedRectangleBorder(
          borderRadius: effectiveRadius,
          side: side,
        ),
      AppBarButtonShape.squircle => ContinuousRectangleBorder(
          borderRadius: _scaleBorderRadius(effectiveRadius, 2.15),
          side: side,
        ),
      AppBarButtonShape.circle =>
        hasLabel ? StadiumBorder(side: side) : CircleBorder(side: side),
      AppBarButtonShape.stadium => StadiumBorder(side: side),
    };
  }

  BorderRadiusGeometry _scaleBorderRadius(
    BorderRadiusGeometry radius,
    double factor,
  ) {
    if (radius is BorderRadius) {
      return BorderRadius.only(
        topLeft: Radius.elliptical(
          radius.topLeft.x * factor,
          radius.topLeft.y * factor,
        ),
        topRight: Radius.elliptical(
          radius.topRight.x * factor,
          radius.topRight.y * factor,
        ),
        bottomLeft: Radius.elliptical(
          radius.bottomLeft.x * factor,
          radius.bottomLeft.y * factor,
        ),
        bottomRight: Radius.elliptical(
          radius.bottomRight.x * factor,
          radius.bottomRight.y * factor,
        ),
      );
    }
    return radius;
  }

  _ResolvedSurfaceColors _resolveColors({
    required BuildContext context,
    required AppBarButtonStyle style,
    required AppBarButtonVariant variant,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;
    final Color ambientFg = IconTheme.of(context).color ?? cs.onSurface;
    final bool lightFg = ambientFg.computeLuminance() > 0.5;
    final bool selected = widget.isSelected;
    final double disabledAlpha =
        (style.disabledOpacity ?? 0.38).clamp(0.05, 1.0);

    Color baseBg;
    Color baseFg;
    Color baseBorder = Colors.transparent;
    double baseBorderWidth = 0.0;
    Color defaultHoverOverlay;
    Color defaultPressedOverlay;

    switch (variant) {
      case AppBarButtonVariant.tonal:
        baseFg = style.foregroundColor ?? ambientFg;
        baseBg = style.backgroundColor ??
            ambientFg.withValues(alpha: lightFg ? 0.14 : 0.075);
        defaultHoverOverlay = baseFg.withValues(alpha: lightFg ? 0.08 : 0.055);
        defaultPressedOverlay = baseFg.withValues(alpha: lightFg ? 0.14 : 0.10);
        if (selected) {
          baseBg = style.selectedBackgroundColor ?? cs.primaryContainer;
          baseFg = style.selectedForegroundColor ?? cs.onPrimaryContainer;
          baseBorder = style.selectedBorderColor ?? Colors.transparent;
        }

      case AppBarButtonVariant.filled:
        baseBg = style.backgroundColor ?? cs.primary;
        baseFg = style.foregroundColor ?? cs.onPrimary;
        defaultHoverOverlay = baseFg.withValues(alpha: 0.10);
        defaultPressedOverlay = baseFg.withValues(alpha: 0.18);
        if (selected) {
          baseBg = style.selectedBackgroundColor ?? cs.primaryContainer;
          baseFg = style.selectedForegroundColor ?? cs.onPrimaryContainer;
          baseBorder = style.selectedBorderColor ?? Colors.transparent;
        }

      case AppBarButtonVariant.outlined:
        baseBg = style.backgroundColor ?? Colors.transparent;
        baseFg = style.foregroundColor ?? ambientFg;
        baseBorder = style.borderColor ??
            ambientFg.withValues(alpha: lightFg ? 0.30 : 0.18);
        baseBorderWidth = style.borderWidth ?? 1.0;
        defaultHoverOverlay = baseFg.withValues(alpha: lightFg ? 0.10 : 0.06);
        defaultPressedOverlay = baseFg.withValues(alpha: lightFg ? 0.16 : 0.11);
        if (selected) {
          baseBg = style.selectedBackgroundColor ??
              cs.primary.withValues(alpha: isDark ? 0.22 : 0.12);
          baseFg = style.selectedForegroundColor ?? cs.primary;
          baseBorder =
              style.selectedBorderColor ?? cs.primary.withValues(alpha: 0.65);
          baseBorderWidth = style.borderWidth ?? 1.25;
        }

      case AppBarButtonVariant.ghost:
        baseBg = style.backgroundColor ?? Colors.transparent;
        baseFg = style.foregroundColor ?? ambientFg;
        defaultHoverOverlay = baseFg.withValues(alpha: lightFg ? 0.12 : 0.08);
        defaultPressedOverlay = baseFg.withValues(alpha: lightFg ? 0.20 : 0.14);
        if (selected) {
          baseBg = style.selectedBackgroundColor ??
              cs.primary.withValues(alpha: isDark ? 0.22 : 0.12);
          baseFg = style.selectedForegroundColor ?? cs.primary;
          baseBorder = style.selectedBorderColor ?? Colors.transparent;
        }

      case AppBarButtonVariant.elevated:
        baseBg = style.backgroundColor ??
            (isDark ? cs.surfaceContainerHigh : cs.surface);
        baseFg = style.foregroundColor ?? cs.onSurface;
        baseBorder = style.borderColor ??
            cs.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.45);
        baseBorderWidth = style.borderWidth ?? 0.75;
        defaultHoverOverlay = baseFg.withValues(alpha: isDark ? 0.08 : 0.045);
        defaultPressedOverlay = baseFg.withValues(alpha: isDark ? 0.14 : 0.09);
        if (selected) {
          baseBg = style.selectedBackgroundColor ?? cs.primary;
          baseFg = style.selectedForegroundColor ?? cs.onPrimary;
          baseBorder = style.selectedBorderColor ?? Colors.transparent;
        }

      case AppBarButtonVariant.glass:
        baseFg = style.foregroundColor ?? ambientFg;
        baseBg = style.backgroundColor ??
            (lightFg
                ? Colors.white.withValues(alpha: 0.18)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.68)));
        baseBorder = style.borderColor ??
            (lightFg
                ? Colors.white.withValues(alpha: 0.34)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.22)
                    : Colors.black.withValues(alpha: 0.10)));
        baseBorderWidth = style.borderWidth ?? 1.0;
        defaultHoverOverlay =
            Colors.white.withValues(alpha: lightFg ? 0.10 : 0.18);
        defaultPressedOverlay =
            Colors.white.withValues(alpha: lightFg ? 0.18 : 0.28);
        if (selected) {
          baseBg = style.selectedBackgroundColor ??
              cs.primary.withValues(alpha: 0.82);
          baseFg = style.selectedForegroundColor ?? cs.onPrimary;
          baseBorder =
              style.selectedBorderColor ?? Colors.white.withValues(alpha: 0.40);
        }
    }

    if (!selected && style.borderColor != null) {
      baseBorder = style.borderColor!;
      baseBorderWidth = style.borderWidth ?? 1.0;
    } else if (selected && style.selectedBorderColor != null) {
      baseBorder = style.selectedBorderColor!;
      baseBorderWidth = style.borderWidth ?? 1.25;
    }

    final bool visuallyDisabled = !widget.enabled || !_hasInteractiveCallback;
    Color effectiveBg = baseBg;
    Color effectiveFg = baseFg;
    Color effectiveBorder = baseBorder;
    double effectiveBorderWidth = baseBorderWidth;

    if (visuallyDisabled) {
      effectiveFg = baseFg.withValues(alpha: baseFg.a * disabledAlpha);
      effectiveBg = baseBg.withValues(alpha: baseBg.a * 0.55);
      effectiveBorder =
          baseBorder.withValues(alpha: baseBorder.a * disabledAlpha);
    } else if (_isPressed && _isInteractive) {
      effectiveBg =
          style.pressedColor ?? Color.alphaBlend(defaultPressedOverlay, baseBg);
    } else if (_isHovered && _isInteractive) {
      effectiveBg =
          style.hoverColor ?? Color.alphaBlend(defaultHoverOverlay, baseBg);
    }

    if (_isFocused && _isInteractive) {
      effectiveBorder = style.focusRingColor ?? cs.primary;
      effectiveBorderWidth = style.focusRingWidth ?? 2.0;
    }

    final Color splashColor =
        style.splashColor ?? effectiveFg.withValues(alpha: 0.12);

    return _ResolvedSurfaceColors(
      background: effectiveBg,
      foreground: effectiveFg,
      border: effectiveBorder,
      borderWidth: effectiveBorderWidth,
      splash: splashColor,
    );
  }

  List<BoxShadow>? _resolveShadows({
    required BuildContext context,
    required AppBarButtonStyle style,
    required AppBarButtonVariant variant,
  }) {
    if (style.boxShadow != null) {
      return style.boxShadow;
    }
    if (variant != AppBarButtonVariant.elevated && style.elevation == null) {
      return null;
    }
    final double elevation = style.elevation ?? 3.0;
    if (elevation <= 0 || !widget.enabled) {
      return null;
    }
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseShadow = style.shadowColor ?? Colors.black;
    final double pressFactor = _isPressed ? 0.45 : 1.0;
    return [
      BoxShadow(
        color: baseShadow.withValues(
          alpha: (isDark ? 0.36 : 0.10) * pressFactor,
        ),
        blurRadius: elevation * 3.0 * pressFactor,
        offset: Offset(0, elevation * 0.85 * pressFactor),
      ),
      BoxShadow(
        color: baseShadow.withValues(
          alpha: (isDark ? 0.22 : 0.05) * pressFactor,
        ),
        blurRadius: elevation * pressFactor,
        offset: Offset(0, elevation * 0.25 * pressFactor),
      ),
    ];
  }

  Widget _buildIconWidget(BuildContext context, double iconSize) {
    final bool selected = widget.isSelected;
    if (selected && widget.selectedIcon != null) {
      return KeyedSubtree(
        key: const ValueKey<String>('selected_icon_widget'),
        child: widget.selectedIcon!,
      );
    }
    if (selected && widget._selectedIconData != null) {
      return Icon(
        widget._selectedIconData,
        key: const ValueKey<String>('selected_icon_data'),
        size: iconSize,
      );
    }
    if (widget.icon != null) {
      return KeyedSubtree(
        key: const ValueKey<String>('default_icon_widget'),
        child: widget.icon!,
      );
    }
    if (widget._iconData != null) {
      return Icon(
        widget._iconData,
        key: const ValueKey<String>('default_icon_data'),
        size: iconSize,
      );
    }
    if (widget._presetAction == _AppBarButtonPresetAction.back) {
      final TargetPlatform platform = Theme.of(context).platform;
      final bool isApple =
          platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
      return Icon(
        isApple ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_rounded,
        key: const ValueKey<String>('adaptive_back_icon'),
        size: isApple ? iconSize - 1.5 : iconSize,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingIndicator(Color foregroundColor, double iconSize) {
    if (widget.loadingIndicator != null) {
      return KeyedSubtree(
        key: const ValueKey<String>('custom_loader'),
        child: widget.loadingIndicator!,
      );
    }
    final double indicatorSize = (iconSize - 2.0).clamp(12.0, 22.0);
    return SizedBox(
      key: const ValueKey<String>('default_loader'),
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required AppBarButtonStyle style,
    required AppBarButtonSize sizePreset,
    required Color foregroundColor,
    required bool disableAnimations,
    required ShapeBorder clipShape,
  }) {
    final double effectiveIconSize = style.iconSize ?? sizePreset.iconSize;
    final Duration switchDuration =
        disableAnimations ? Duration.zero : const Duration(milliseconds: 170);

    if (widget.child != null) {
      Widget content = widget.isLoading
          ? _buildLoadingIndicator(foregroundColor, effectiveIconSize)
          : KeyedSubtree(
              key: const ValueKey<String>('custom_child'),
              child: widget.child!,
            );

      if (widget._isAvatar && !widget.isLoading) {
        content = ClipPath(
          clipper: ShapeBorderClipper(shape: clipShape),
          child: SizedBox.expand(child: content),
        );
      }

      return AnimatedSwitcher(
        duration: switchDuration,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: content,
      );
    }

    final String? effectiveLabel =
        widget.isSelected && widget.selectedLabel != null
            ? widget.selectedLabel
            : widget.label;
    final bool hasLabel = effectiveLabel != null && effectiveLabel.isNotEmpty;
    final bool hasIcon = widget.icon != null ||
        widget._iconData != null ||
        widget._presetAction == _AppBarButtonPresetAction.back;

    final TextStyle resolvedTextStyle = (style.textStyle ??
            TextStyle(
              fontSize: sizePreset.fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.1,
              height: 1.1,
            ))
        .copyWith(color: foregroundColor);

    if (hasIcon && hasLabel) {
      final Widget leadingOrTrailingSlot = AnimatedSwitcher(
        duration: switchDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.78, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: widget.isLoading
            ? _buildLoadingIndicator(foregroundColor, effectiveIconSize)
            : _buildIconWidget(context, effectiveIconSize),
      );

      final Widget labelWidget = Flexible(
        child: Text(
          effectiveLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: resolvedTextStyle,
        ),
      );

      final double gap = style.gap ?? sizePreset.gap;
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.iconAlignment == IconAlignment.start
            ? [
                leadingOrTrailingSlot,
                SizedBox(width: gap),
                labelWidget,
              ]
            : [
                labelWidget,
                SizedBox(width: gap),
                leadingOrTrailingSlot,
              ],
      );
    }

    if (hasLabel) {
      return AnimatedSwitcher(
        duration: switchDuration,
        child: widget.isLoading
            ? _buildLoadingIndicator(foregroundColor, effectiveIconSize)
            : Text(
                effectiveLabel,
                key: ValueKey<String>('label_$effectiveLabel'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: resolvedTextStyle,
              ),
      );
    }

    return AnimatedSwitcher(
      duration: switchDuration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: widget.isLoading
          ? _buildLoadingIndicator(foregroundColor, effectiveIconSize)
          : _buildIconWidget(context, effectiveIconSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._hideWhenCannotPop) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      final bool canPop =
          (route?.impliesAppBarDismissal ?? false) || Navigator.canPop(context);
      if (!canPop) {
        return const SizedBox.shrink();
      }
    }

    final bool disableAnimations = MediaQuery.disableAnimationsOf(context);
    final AppBarButtonStyle style = _resolveStyle(context);
    final AppBarButtonVariant variant =
        style.variant ?? AppBarButtonVariant.tonal;
    final AppBarButtonShape shapePreset =
        style.shape ?? AppBarButtonShape.rounded;
    final AppBarButtonSize sizePreset = style.size ?? AppBarButtonSize.medium;

    final String? effectiveLabel =
        widget.isSelected && widget.selectedLabel != null
            ? widget.selectedLabel
            : widget.label;
    final bool hasLabel = effectiveLabel != null && effectiveLabel.isNotEmpty;

    final _ResolvedSurfaceColors colors = _resolveColors(
      context: context,
      style: style,
      variant: variant,
    );

    final BorderSide borderSide = colors.borderWidth > 0 && colors.border.a > 0
        ? BorderSide(color: colors.border, width: colors.borderWidth)
        : BorderSide.none;

    final ShapeBorder effectiveShape = _resolveShape(
      style: style,
      shapePreset: shapePreset,
      sizePreset: sizePreset,
      hasLabel: hasLabel,
      side: borderSide,
    );

    final ShapeBorder clipShape = _resolveShape(
      style: style,
      shapePreset: shapePreset,
      sizePreset: sizePreset,
      hasLabel: hasLabel,
      side: BorderSide.none,
    );

    final double height = style.height ?? sizePreset.dimension;
    final double? width =
        style.width ?? (hasLabel ? null : sizePreset.dimension);
    final double minWidth = style.minWidth ?? sizePreset.dimension;

    final EdgeInsetsGeometry effectivePadding = style.padding ??
        (widget._isAvatar
            ? const EdgeInsets.all(2.0)
            : hasLabel
                ? EdgeInsets.symmetric(
                    horizontal: sizePreset.horizontalPadding,
                  )
                : EdgeInsets.zero);

    final Duration transitionDuration = disableAnimations
        ? Duration.zero
        : (style.animationDuration ?? const Duration(milliseconds: 160));
    final Duration scaleDuration = disableAnimations
        ? Duration.zero
        : (style.scaleDuration ?? const Duration(milliseconds: 110));
    final Curve curve = style.animationCurve ?? Curves.easeOutCubic;

    final double effectiveIconSize = style.iconSize ?? sizePreset.iconSize;
    final List<BoxShadow>? shadows = _resolveShadows(
      context: context,
      style: style,
      variant: variant,
    );

    final VoidCallback? onPressed = _resolveOnPressed(context);
    final VoidCallback? onLongPress = _resolveOnLongPress(context);

    Widget content = IconTheme.merge(
      data: IconThemeData(
        color: colors.foreground,
        size: effectiveIconSize,
      ),
      child: _buildContent(
        context: context,
        style: style,
        sizePreset: sizePreset,
        foregroundColor: colors.foreground,
        disableAnimations: disableAnimations,
        clipShape: clipShape,
      ),
    );

    if (effectivePadding != EdgeInsets.zero) {
      content = Padding(
        padding: effectivePadding,
        child: content,
      );
    }

    final MouseCursor cursor = _isInteractive
        ? (style.mouseCursor ?? SystemMouseCursors.click)
        : SystemMouseCursors.basic;

    final Widget interactiveSurface = Material(
      type: MaterialType.transparency,
      shape: clipShape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        onLongPress: onLongPress,
        onHighlightChanged: (bool highlighted) {
          if (_isPressed != highlighted && mounted) {
            setState(() => _isPressed = highlighted);
          }
        },
        onHover: (bool hovered) {
          if (_isHovered != hovered && mounted) {
            setState(() => _isHovered = hovered);
          }
          widget.onHover?.call(hovered);
        },
        onFocusChange: (bool focused) {
          if (_isFocused != focused && mounted) {
            setState(() => _isFocused = focused);
          }
          widget.onFocusChange?.call(focused);
        },
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: _isInteractive,
        mouseCursor: cursor,
        customBorder: clipShape,
        splashColor: colors.splash,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Center(
          widthFactor: width == null ? 1.0 : null,
          child: content,
        ),
      ),
    );

    final double blurSigma =
        variant == AppBarButtonVariant.glass ? (style.blurSigma ?? 12.0) : 0.0;

    Widget buttonBody;
    if (blurSigma > 0) {
      buttonBody = AnimatedContainer(
        duration: transitionDuration,
        curve: curve,
        width: width,
        height: height,
        constraints: width == null
            ? BoxConstraints(minWidth: minWidth, minHeight: height)
            : null,
        decoration: shadows != null
            ? ShapeDecoration(shape: clipShape, shadows: shadows)
            : null,
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: clipShape),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: AnimatedContainer(
              duration: transitionDuration,
              curve: curve,
              decoration: ShapeDecoration(
                color: colors.background,
                shape: effectiveShape,
              ),
              child: interactiveSurface,
            ),
          ),
        ),
      );
    } else {
      buttonBody = AnimatedContainer(
        duration: transitionDuration,
        curve: curve,
        width: width,
        height: height,
        constraints: width == null
            ? BoxConstraints(minWidth: minWidth, minHeight: height)
            : null,
        decoration: ShapeDecoration(
          color: colors.background,
          shape: effectiveShape,
          shadows: shadows,
        ),
        child: interactiveSurface,
      );
    }

    if (widget.badge != null) {
      final AppBarButtonBadge badge = widget.badge!;
      final TextDirection textDirection =
          Directionality.maybeOf(context) ?? TextDirection.ltr;
      final bool isRtl = textDirection == TextDirection.rtl;
      final Offset translatedOffset = Offset(
        isRtl ? -badge.offset.dx : badge.offset.dx,
        badge.offset.dy,
      );

      buttonBody = Stack(
        clipBehavior: Clip.none,
        alignment: badge.alignment,
        children: [
          buttonBody,
          Positioned.fill(
            child: OverflowBox(
              minWidth: 0,
              minHeight: 0,
              maxWidth: 160,
              maxHeight: 60,
              alignment: badge.alignment.resolve(textDirection),
              child: Transform.translate(
                offset: translatedOffset,
                child: AppBarButtonBadgeView(badge: badge),
              ),
            ),
          ),
        ],
      );
    }

    final bool shouldScale =
        (style.enableScaleAnimation ?? true) && !disableAnimations;
    final double targetScale = shouldScale && _isPressed && _isInteractive
        ? (style.pressedScale ?? 0.93)
        : 1.0;

    buttonBody = AnimatedScale(
      scale: targetScale,
      duration: scaleDuration,
      curve: Curves.easeOutCubic,
      child: buttonBody,
    );

    final String? effectiveTooltip = _resolveTooltip(context);
    if (effectiveTooltip != null) {
      buttonBody = Tooltip(
        message: effectiveTooltip,
        child: buttonBody,
      );
    }

    if (!widget.excludeFromSemantics) {
      final String? resolvedSemanticLabel =
          widget.semanticLabel ?? effectiveTooltip ?? effectiveLabel;
      final String? badgeSemantic = widget.badge?.resolvedSemanticLabel;
      final String? combinedLabel =
          switch ((resolvedSemanticLabel, badgeSemantic)) {
        (final String base, final String b) when b.isNotEmpty => '$base, $b',
        (final String base, _) => base,
        (null, final String b) when b.isNotEmpty => b,
        _ => null,
      };

      buttonBody = Semantics(
        button: true,
        enabled: _isInteractive,
        selected: widget.isSelected,
        label: combinedLabel,
        child: buttonBody,
      );
    }

    if (style.margin != null) {
      buttonBody = Padding(
        padding: style.margin!,
        child: buttonBody,
      );
    }

    return Center(
      widthFactor: 1.0,
      heightFactor: 1.0,
      child: buttonBody,
    );
  }
}

@immutable
class _ResolvedSurfaceColors {
  const _ResolvedSurfaceColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.borderWidth,
    required this.splash,
  });

  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;
  final Color splash;
}
