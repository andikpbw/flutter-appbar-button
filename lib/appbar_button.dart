/// Modern, lightweight, and customizable AppBar buttons for Flutter.
///
/// Provides [AppBarButton] with six surface variants ([AppBarButtonVariant]),
/// four shapes ([AppBarButtonShape]), three sizes ([AppBarButtonSize]),
/// notification badges ([AppBarButtonBadge]), grouped action capsules
/// ([AppBarButtonGroup]), and app-wide theming ([AppBarButtonTheme] /
/// [AppBarButtonThemeData]).
library;

export 'src/appbar_button_badge.dart'
    show AppBarButtonBadge, AppBarButtonBadgeType;
export 'src/appbar_button_group.dart' show AppBarButtonGroup;
export 'src/appbar_button_style.dart'
    show
        AppBarButtonHaptic,
        AppBarButtonShape,
        AppBarButtonSize,
        AppBarButtonStyle,
        AppBarButtonVariant;
export 'src/appbar_button_theme.dart'
    show AppBarButtonTheme, AppBarButtonThemeData;
export 'src/appbar_button_widget.dart' show AppBarButton;
