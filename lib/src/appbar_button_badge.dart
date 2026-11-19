import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Display mode of an [AppBarButtonBadge].
enum AppBarButtonBadgeType {
  /// Compact circular indicator dot.
  dot,

  /// Numeric counter badge with overflow formatting (for example `99+`).
  count,

  /// Short custom text pill badge (for example `NEW` or `PRO`).
  label,
}

/// Configuration for a notification dot, numeric counter, or label badge
/// displayed on an [AppBarButton].
@immutable
class AppBarButtonBadge with Diagnosticable {
  /// Creates a compact circular notification or status dot badge.
  const AppBarButtonBadge.dot({
    this.color,
    this.borderColor,
    this.borderWidth = 1.5,
    this.size = 9.0,
    this.alignment = AlignmentDirectional.topEnd,
    this.offset = const Offset(1, -1),
    this.pulse = false,
    this.visible = true,
    this.semanticLabel,
  })  : type = AppBarButtonBadgeType.dot,
        count = null,
        maxCount = 99,
        showZero = false,
        label = null,
        textColor = null,
        textStyle = null;

  /// Creates a numeric counter badge.
  ///
  /// When [count] exceeds [maxCount], the badge formats the value as
  /// `'$maxCount+'` (for example `99+`). When [count] is `0` or negative and
  /// [showZero] is `false`, the badge automatically hides.
  const AppBarButtonBadge.count({
    required int this.count,
    this.maxCount = 99,
    this.showZero = false,
    this.color,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.borderWidth = 1.5,
    this.alignment = AlignmentDirectional.topEnd,
    this.offset = const Offset(4, -4),
    this.pulse = false,
    this.visible = true,
    this.semanticLabel,
  })  : assert(maxCount > 0, 'maxCount must be greater than zero.'),
        type = AppBarButtonBadgeType.count,
        label = null,
        size = 18.0;

  /// Creates a short text label badge (such as `'NEW'` or `'PRO'`).
  const AppBarButtonBadge.label({
    required String this.label,
    this.color,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.borderWidth = 1.5,
    this.alignment = AlignmentDirectional.topEnd,
    this.offset = const Offset(5, -5),
    this.pulse = false,
    this.visible = true,
    this.semanticLabel,
  })  : type = AppBarButtonBadgeType.label,
        count = null,
        maxCount = 99,
        showZero = false,
        size = 18.0;

  /// Badge rendering mode.
  final AppBarButtonBadgeType type;

  /// Numeric count for [AppBarButtonBadgeType.count].
  final int? count;

  /// Maximum count shown before displaying a `'+'` suffix.
  final int maxCount;

  /// Whether to keep showing the badge when [count] is `0`.
  final bool showZero;

  /// Text displayed for [AppBarButtonBadgeType.label].
  final String? label;

  /// Background fill color of the badge.
  ///
  /// Defaults to [ColorScheme.error].
  final Color? color;

  /// Foreground text color for count and label badges.
  ///
  /// Defaults to [ColorScheme.onError].
  final Color? textColor;

  /// Optional custom [TextStyle] for count and label text.
  final TextStyle? textStyle;

  /// Optional cutout ring color drawn around the badge to separate it cleanly
  /// from the button surface.
  final Color? borderColor;

  /// Width of the cutout border ring in logical pixels.
  final double borderWidth;

  /// Diameter of a dot badge or minimum height of a count/label badge.
  final double size;

  /// Directional corner alignment of the badge relative to the button.
  final AlignmentDirectional alignment;

  /// Positional offset applied relative to [alignment].
  ///
  /// The horizontal component automatically mirrors in right-to-left layouts.
  final Offset offset;

  /// Whether to animate a soft pulsing halo behind the badge.
  final bool pulse;

  /// Controls whether the badge is shown.
  final bool visible;

  /// Optional semantic description read by screen readers.
  final String? semanticLabel;

  /// Whether this badge should currently be visible based on [visible],
  /// [type], [count], [showZero], and [label].
  bool get isEffectivelyVisible {
    if (!visible) {
      return false;
    }
    return switch (type) {
      AppBarButtonBadgeType.dot => true,
      AppBarButtonBadgeType.count =>
        (count ?? 0) > 0 || (showZero && (count ?? 0) == 0),
      AppBarButtonBadgeType.label => label != null && label!.isNotEmpty,
    };
  }

  /// Formatted text string shown inside the badge, or `null` for dot badges.
  String? get formattedText {
    return switch (type) {
      AppBarButtonBadgeType.dot => null,
      AppBarButtonBadgeType.count =>
        (count ?? 0) > maxCount ? '$maxCount+' : '${count ?? 0}',
      AppBarButtonBadgeType.label => label,
    };
  }

  /// Resolved semantic announcement for screen readers.
  String? get resolvedSemanticLabel {
    if (semanticLabel != null) {
      return semanticLabel;
    }
    if (!isEffectivelyVisible) {
      return null;
    }
    return switch (type) {
      AppBarButtonBadgeType.dot => 'Notification indicator',
      AppBarButtonBadgeType.count => '${formattedText ?? ''} notifications',
      AppBarButtonBadgeType.label => label,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppBarButtonBadge &&
        other.type == type &&
        other.count == count &&
        other.maxCount == maxCount &&
        other.showZero == showZero &&
        other.label == label &&
        other.color == color &&
        other.textColor == textColor &&
        other.textStyle == textStyle &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.size == size &&
        other.alignment == alignment &&
        other.offset == offset &&
        other.pulse == pulse &&
        other.visible == visible &&
        other.semanticLabel == semanticLabel;
  }

  @override
  int get hashCode => Object.hash(
        type,
        count,
        maxCount,
        showZero,
        label,
        color,
        textColor,
        textStyle,
        borderColor,
        borderWidth,
        size,
        alignment,
        offset,
        pulse,
        visible,
        semanticLabel,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<AppBarButtonBadgeType>('type', type))
      ..add(IntProperty('count', count, defaultValue: null))
      ..add(IntProperty('maxCount', maxCount, defaultValue: 99))
      ..add(StringProperty('label', label, defaultValue: null))
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(FlagProperty('pulse', value: pulse, ifTrue: 'pulsing'))
      ..add(FlagProperty('visible', value: visible, ifFalse: 'hidden'));
  }
}

/// Internal overlay renderer for [AppBarButtonBadge].
class AppBarButtonBadgeView extends StatefulWidget {
  /// Creates an [AppBarButtonBadgeView].
  const AppBarButtonBadgeView({
    super.key,
    required this.badge,
    this.fallbackBorderColor,
  });

  /// Badge configuration to render.
  final AppBarButtonBadge badge;

  /// Fallback cutout ring color used when [AppBarButtonBadge.borderColor] is
  /// not specified.
  final Color? fallbackBorderColor;

  @override
  State<AppBarButtonBadgeView> createState() => _AppBarButtonBadgeViewState();
}

class _AppBarButtonBadgeViewState extends State<AppBarButtonBadgeView>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  bool _disableAnimations = false;

  bool get _shouldPulse =>
      widget.badge.pulse &&
      widget.badge.isEffectivelyVisible &&
      !_disableAnimations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disableAnimations = MediaQuery.disableAnimationsOf(context);
    _syncPulseController();
  }

  @override
  void didUpdateWidget(covariant AppBarButtonBadgeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulseController();
  }

  void _syncPulseController() {
    if (_shouldPulse) {
      _pulseController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1400),
      );
      if (!_pulseController!.isAnimating) {
        _pulseController!.repeat();
      }
    } else {
      _pulseController?.stop();
      _pulseController?.reset();
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final AppBarButtonBadge badge = widget.badge;
    final bool visible = badge.isEffectivelyVisible;
    final Color fillColor = badge.color ?? colorScheme.error;
    final Color onFillColor = badge.textColor ?? colorScheme.onError;
    final Color ringColor = badge.borderColor ??
        widget.fallbackBorderColor ??
        theme.appBarTheme.backgroundColor ??
        colorScheme.surface;

    final Border? border = badge.borderWidth > 0
        ? Border.all(color: ringColor, width: badge.borderWidth)
        : null;

    Widget badgeBody;
    if (badge.type == AppBarButtonBadgeType.dot) {
      final double totalSize = badge.size + (badge.borderWidth * 2);
      badgeBody = Container(
        width: totalSize,
        height: totalSize,
        decoration: BoxDecoration(
          color: fillColor,
          shape: BoxShape.circle,
          border: border,
        ),
      );
    } else {
      final String text = badge.formattedText ?? '';
      final double minHeight = badge.size;
      final TextStyle resolvedTextStyle = (badge.textStyle ??
              TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                height: 1.0,
                letterSpacing: -0.2,
                color: onFillColor,
              ))
          .copyWith(color: badge.textStyle?.color ?? onFillColor);

      badgeBody = DecoratedBox(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(minHeight),
          border: border,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minHeight,
            minHeight: minHeight,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: text.length <= 1 ? 5.0 : 6.0,
              vertical: 2.5,
            ),
            child: Center(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: Text(
                text,
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: resolvedTextStyle,
              ),
            ),
          ),
        ),
      );
    }

    if (_shouldPulse && _pulseController != null) {
      final AnimationController controller = _pulseController!;
      badgeBody = Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) {
                final double progress =
                    Curves.easeOut.transform(controller.value);
                final double scale = 1.0 + (progress * 0.85);
                final double opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.55;
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: child,
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fillColor,
                  shape: badge.type == AppBarButtonBadgeType.dot
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  borderRadius: badge.type == AppBarButtonBadgeType.dot
                      ? null
                      : BorderRadius.circular(badge.size),
                ),
              ),
            ),
          ),
          badgeBody,
        ],
      );
    }

    final Duration animDuration =
        _disableAnimations ? Duration.zero : const Duration(milliseconds: 180);

    return IgnorePointer(
      child: AnimatedScale(
        scale: visible ? 1.0 : 0.0,
        duration: animDuration,
        curve: visible ? Curves.easeOutBack : Curves.easeIn,
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: animDuration,
          child: badgeBody,
        ),
      ),
    );
  }
}
