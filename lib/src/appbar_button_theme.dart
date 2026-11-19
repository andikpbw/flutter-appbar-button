import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'appbar_button_style.dart';

/// Theme configuration for descendant [AppBarButton] widgets.
///
/// Can be registered globally in [ThemeData.extensions] or provided to a
/// subtree via [AppBarButtonTheme].
@immutable
class AppBarButtonThemeData extends ThemeExtension<AppBarButtonThemeData>
    with Diagnosticable {
  /// Creates an [AppBarButtonThemeData] holding the default [style].
  const AppBarButtonThemeData({this.style = const AppBarButtonStyle()});

  /// Default style applied to descendant [AppBarButton] widgets unless
  /// overridden directly on the widget.
  final AppBarButtonStyle style;

  @override
  AppBarButtonThemeData copyWith({AppBarButtonStyle? style}) {
    return AppBarButtonThemeData(style: style ?? this.style);
  }

  @override
  AppBarButtonThemeData lerp(
    covariant ThemeExtension<AppBarButtonThemeData>? other,
    double t,
  ) {
    if (other is! AppBarButtonThemeData) {
      return this;
    }
    return AppBarButtonThemeData(
      style:
          AppBarButtonStyle.lerp(style, other.style, t) ??
          const AppBarButtonStyle(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AppBarButtonThemeData && other.style == style;
  }

  @override
  int get hashCode => style.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppBarButtonStyle>('style', style));
  }
}

/// Applies an [AppBarButtonThemeData] to descendant [AppBarButton] widgets.
///
/// Descendant widgets obtain the current theme via [AppBarButtonTheme.of],
/// which first checks for an enclosing [AppBarButtonTheme] and then falls back
/// to `Theme.of(context).extension<AppBarButtonThemeData>()`.
class AppBarButtonTheme extends InheritedTheme {
  /// Creates a theme widget that provides [data] to [child] and its
  /// descendants.
  const AppBarButtonTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Theme data supplied to descendants.
  final AppBarButtonThemeData data;

  /// Returns the closest [AppBarButtonThemeData] from the widget tree, or
  /// `null` if none is configured.
  static AppBarButtonThemeData? maybeOf(BuildContext context) {
    final AppBarButtonTheme? inherited = context
        .dependOnInheritedWidgetOfExactType<AppBarButtonTheme>();
    if (inherited != null) {
      return inherited.data;
    }
    return Theme.of(context).extension<AppBarButtonThemeData>();
  }

  /// Returns the closest [AppBarButtonThemeData], or a default empty instance
  /// if none is configured.
  static AppBarButtonThemeData of(BuildContext context) {
    return maybeOf(context) ?? const AppBarButtonThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return AppBarButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(AppBarButtonTheme oldWidget) =>
      data != oldWidget.data;
}
