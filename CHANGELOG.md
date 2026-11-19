## 1.0.1

* Migrated Material imports from deprecated `package:flutter/material.dart` to the official standalone `package:material_ui/material_ui.dart` package for full Flutter 3.47+ / 3.50+ compatibility and zero static analysis warnings on pub.dev.
* Migrated Cupertino test imports to `package:cupertino_ui/cupertino_ui.dart`.
* Hardened edge cases for `BorderRadiusDirectional` squircle scaling, high-contrast `elevated` unified capsules on colored app bars, partial `textStyle` merging, custom `OutlinedBorder` clipping, and overlay-free safety.

## 1.0.0

* Initial release of `appbar_button`.
* Added `AppBarButton` with six modern visual variants: `tonal`, `filled`, `outlined`, `ghost`, `elevated`, and frosted `glass`.
* Added four button shapes (`rounded`, `squircle`, `circle`, and `stadium`) and three size presets (`small`, `medium`, and `large`).
* Added ergonomic named constructors: `AppBarButton.icon`, `AppBarButton.back`, `AppBarButton.close`, `AppBarButton.menu`, `AppBarButton.pill`, `AppBarButton.toggle`, and `AppBarButton.avatar`.
* Added `AppBarButtonBadge` supporting dot, animated pulse, numeric count (with configurable overflow cap), and custom text labels.
* Added built-in press scale micro-interaction, smooth loading indicator transitions, toggle selection animations, keyboard focus rings, RTL awareness, and screen-reader semantics.
* Added `AppBarButtonGroup` supporting both evenly spaced action clusters and unified segmented action capsules.
* Added `AppBarButtonTheme` and `AppBarButtonThemeData` (`ThemeExtension`) for seamless app-wide customization.
