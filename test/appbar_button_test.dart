import 'dart:ui' show PointerDeviceKind;

import 'package:appbar_button/appbar_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapApp(
  Widget child, {
  ThemeData? theme,
  TextDirection textDirection = TextDirection.ltr,
  bool disableAnimations = false,
}) {
  return MaterialApp(
    theme: theme ?? ThemeData(useMaterial3: true),
    home: Directionality(
      textDirection: textDirection,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(
          body: Center(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('AppBarButton constructors and interactions', () {
    testWidgets('default constructor renders icon, label, and handles taps', (
      WidgetTester tester,
    ) async {
      int taps = 0;
      int longPresses = 0;

      await tester.pumpWidget(
        _wrapApp(
          AppBarButton(
            icon: const Icon(Icons.search_rounded),
            label: 'Search',
            onPressed: () => taps++,
            onLongPress: () => longPresses++,
          ),
        ),
      );

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);

      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();
      expect(taps, 1);

      await tester.longPress(find.byType(AppBarButton));
      await tester.pumpAndSettle();
      expect(longPresses, 1);
    });

    testWidgets('AppBarButton.icon renders IconData and invokes onPressed', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrapApp(
          AppBarButton.icon(
            Icons.notifications_none_rounded,
            tooltip: 'Alerts',
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byTooltip('Alerts'), findsOneWidget);

      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets(
        'AppBarButton.pill supports leading and trailing icon alignment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapApp(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBarButton.pill(
                icon: Icons.add_rounded,
                label: 'Create',
                onPressed: () {},
              ),
              AppBarButton.pill(
                icon: Icons.arrow_forward_rounded,
                label: 'Next',
                iconAlignment: IconAlignment.end,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('Create'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);

      final Offset addPos = tester.getCenter(find.byIcon(Icons.add_rounded));
      final Offset createPos = tester.getCenter(find.text('Create'));
      expect(addPos.dx, lessThan(createPos.dx));

      final Offset nextPos = tester.getCenter(find.text('Next'));
      final Offset arrowPos =
          tester.getCenter(find.byIcon(Icons.arrow_forward_rounded));
      expect(nextPos.dx, lessThan(arrowPos.dx));
    });

    testWidgets('AppBarButton.toggle transitions icon, label, and semantics', (
      WidgetTester tester,
    ) async {
      bool selected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                body: Center(
                  child: AppBarButton.toggle(
                    icon: Icons.bookmark_border_rounded,
                    selectedIcon: Icons.bookmark_rounded,
                    label: 'Save',
                    selectedLabel: 'Saved',
                    isSelected: selected,
                    onPressed: () => setState(() => selected = !selected),
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(find.byIcon(Icons.bookmark_border_rounded), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('AppBarButton.avatar renders avatar widget and badge', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        _wrapApp(
          AppBarButton.avatar(
            avatar: const CircleAvatar(child: Text('HA')),
            badge: const AppBarButtonBadge.dot(color: Colors.green),
            onPressed: () => tapped = true,
          ),
        ),
      );

      expect(find.text('HA'), findsOneWidget);
      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('Preset navigation and scaffold buttons', () {
    testWidgets('AppBarButton.back pops route and adapts icon per platform', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  leading: const AppBarButton.back(hideWhenCannotPop: true),
                ),
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => Scaffold(
                          appBar: AppBar(
                            leading: const AppBarButton.back(
                              hideWhenCannotPop: true,
                            ),
                            title: const Text('Second Page'),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go'),
                ),
              );
            },
          ),
        ),
      );

      // Hidden on root route when hideWhenCannotPop is true.
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);

      await tester.tap(find.text('Go'));
      await tester.pumpAndSettle();

      expect(find.text('Second Page'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();

      expect(find.text('Second Page'), findsNothing);
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('AppBarButton.back uses Material arrow on Android', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapApp(
          const AppBarButton.back(),
          theme: ThemeData(platform: TargetPlatform.android),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('AppBarButton.close pops route automatically', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        fullscreenDialog: true,
                        builder: (_) => Scaffold(
                          appBar: AppBar(
                            leading: const AppBarButton.close(),
                            title: const Text('Modal'),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Modal'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Modal'), findsNothing);
    });

    testWidgets('AppBarButton.menu opens drawer and endDrawer', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: const Drawer(child: Text('Start Drawer')),
            endDrawer: const Drawer(child: Text('End Drawer')),
            appBar: AppBar(
              leading: const AppBarButton.menu(),
              actions: const [
                AppBarButton.menu(
                  icon: Icons.tune_rounded,
                  isEndDrawer: true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.menu_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Start Drawer'), findsOneWidget);

      Navigator.of(tester.element(find.text('Start Drawer'))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();
      expect(find.text('End Drawer'), findsOneWidget);
    });

    testWidgets('preset action respects enabled: false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: const Drawer(child: Text('Drawer Content')),
            appBar: AppBar(
              leading: const AppBarButton.menu(enabled: false),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();
      expect(find.text('Drawer Content'), findsNothing);
    });
  });

  group('Variants, shapes, sizes, and AppBar slot layout', () {
    testWidgets('all six variants render cleanly and glass uses BackdropFilter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapApp(
          Wrap(
            spacing: 8,
            children: [
              for (final AppBarButtonVariant variant
                  in AppBarButtonVariant.values)
                AppBarButton.icon(
                  Icons.star_rounded,
                  variant: variant,
                  onPressed: () {},
                ),
            ],
          ),
        ),
      );

      expect(find.byType(AppBarButton), findsNWidgets(6));
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets(
        'all shapes render cleanly including circle with label fallback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapApp(
          Wrap(
            spacing: 8,
            children: [
              for (final AppBarButtonShape shape in AppBarButtonShape.values)
                AppBarButton.icon(
                  Icons.bolt_rounded,
                  shape: shape,
                  onPressed: () {},
                ),
              AppBarButton.pill(
                label: 'Circle Fallback',
                shape: AppBarButtonShape.circle,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.byType(AppBarButton), findsNWidgets(5));
      expect(find.text('Circle Fallback'), findsOneWidget);
    });

    testWidgets(
        'size presets apply exact visual heights and AppBar.leading '
        'does not stretch the button', (WidgetTester tester) async {
      final Key smallKey = UniqueKey();
      final Key mediumKey = UniqueKey();
      final Key largeKey = UniqueKey();
      final Key leadingKey = UniqueKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              leading: AppBarButton.back(key: leadingKey),
            ),
            body: Row(
              children: [
                AppBarButton.icon(
                  Icons.add,
                  key: smallKey,
                  size: AppBarButtonSize.small,
                  onPressed: () {},
                ),
                AppBarButton.icon(
                  Icons.add,
                  key: mediumKey,
                  size: AppBarButtonSize.medium,
                  onPressed: () {},
                ),
                AppBarButton.icon(
                  Icons.add,
                  key: largeKey,
                  size: AppBarButtonSize.large,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        tester.getSize(
          find.descendant(
            of: find.byKey(smallKey),
            matching: find.byType(AnimatedContainer),
          ),
        ),
        const Size(34, 34),
      );
      expect(
        tester.getSize(
          find.descendant(
            of: find.byKey(mediumKey),
            matching: find.byType(AnimatedContainer),
          ),
        ),
        const Size(40, 40),
      );
      expect(
        tester.getSize(
          find.descendant(
            of: find.byKey(largeKey),
            matching: find.byType(AnimatedContainer),
          ),
        ),
        const Size(44, 44),
      );

      // Inside AppBar.leading (56x56 tight slot), visual box remains 40x40.
      expect(
        tester.getSize(
          find.descendant(
            of: find.byKey(leadingKey),
            matching: find.byType(AnimatedContainer),
          ),
        ),
        const Size(40, 40),
      );
    });
  });

  group('Loading, disabled, hover, focus, and haptics', () {
    testWidgets('isLoading shows indicator and suppresses taps', (
      WidgetTester tester,
    ) async {
      int taps = 0;

      await tester.pumpWidget(
        _wrapApp(
          AppBarButton.pill(
            icon: Icons.save_rounded,
            label: 'Save',
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);

      await tester.tap(find.byType(AppBarButton));
      await tester.pump(const Duration(milliseconds: 200));
      expect(taps, 0);
    });

    testWidgets('custom loadingIndicator replaces default spinner', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapApp(
          AppBarButton.icon(
            Icons.refresh_rounded,
            isLoading: true,
            loadingIndicator: const Text('...'),
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('hover and focus callbacks fire properly', (
      WidgetTester tester,
    ) async {
      bool hovered = false;
      bool focused = false;
      final FocusNode focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _wrapApp(
          AppBarButton.icon(
            Icons.settings_rounded,
            focusNode: focusNode,
            onHover: (bool value) => hovered = value,
            onFocusChange: (bool value) => focused = value,
            onPressed: () {},
          ),
        ),
      );

      final TestGesture gesture =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(AppBarButton)));
      await tester.pumpAndSettle();
      expect(hovered, isTrue);

      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(hovered, isFalse);

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(focused, isTrue);
    });

    testWidgets('all haptic options invoke cleanly on tap', (
      WidgetTester tester,
    ) async {
      for (final AppBarButtonHaptic haptic in AppBarButtonHaptic.values) {
        int taps = 0;
        await tester.pumpWidget(
          _wrapApp(
            AppBarButton.icon(
              Icons.touch_app_rounded,
              style: AppBarButtonStyle(hapticFeedback: haptic),
              onPressed: () => taps++,
            ),
          ),
        );
        await tester.tap(find.byType(AppBarButton));
        await tester.pumpAndSettle();
        expect(taps, 1);
      }
    });
  });

  group('AppBarButtonBadge', () {
    testWidgets('count badge formats overflow and hides on zero by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapApp(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBarButton.icon(
                Icons.notifications,
                badge: const AppBarButtonBadge.count(count: 7),
                onPressed: () {},
              ),
              AppBarButton.icon(
                Icons.mail,
                badge: const AppBarButtonBadge.count(count: 150),
                onPressed: () {},
              ),
              AppBarButton.icon(
                Icons.chat,
                badge: const AppBarButtonBadge.count(count: 12, maxCount: 9),
                onPressed: () {},
              ),
              AppBarButton.icon(
                Icons.inbox,
                badge: const AppBarButtonBadge.count(count: 0, showZero: true),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('7'), findsOneWidget);
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('9+'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);

      // Verify badges stay compact and never stretch to overflow bounds.
      final Size singleDigitSize = tester.getSize(
        find
            .ancestor(
              of: find.text('7'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(singleDigitSize.width, lessThanOrEqualTo(30));
      expect(singleDigitSize.height, lessThanOrEqualTo(24));

      final Size overflowBadgeSize = tester.getSize(
        find
            .ancestor(
              of: find.text('99+'),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(overflowBadgeSize.width, lessThanOrEqualTo(48));
      expect(overflowBadgeSize.height, lessThanOrEqualTo(24));

      const AppBarButtonBadge hiddenZero = AppBarButtonBadge.count(count: 0);
      expect(hiddenZero.isEffectivelyVisible, isFalse);
    });

    testWidgets('dot pulse and label badges animate and dispose cleanly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapApp(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBarButton.icon(
                Icons.circle_notifications,
                badge: const AppBarButtonBadge.dot(pulse: true),
                onPressed: () {},
              ),
              AppBarButton.icon(
                Icons.auto_awesome,
                badge: const AppBarButtonBadge.label(
                  label: 'NEW',
                  pulse: true,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(find.text('NEW'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      // Unmount while pulsing to verify AnimationController disposes cleanly.
      await tester.pumpWidget(_wrapApp(const SizedBox.shrink()));
      await tester.pumpAndSettle();
    });

    test('AppBarButtonBadge value equality and semantics', () {
      const AppBarButtonBadge a = AppBarButtonBadge.count(count: 5);
      const AppBarButtonBadge b = AppBarButtonBadge.count(count: 5);
      const AppBarButtonBadge c = AppBarButtonBadge.count(count: 8);
      const AppBarButtonBadge dot = AppBarButtonBadge.dot();
      const AppBarButtonBadge label = AppBarButtonBadge.label(label: 'PRO');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      expect(a.resolvedSemanticLabel, '5 notifications');
      expect(dot.resolvedSemanticLabel, 'Notification indicator');
      expect(label.resolvedSemanticLabel, 'PRO');

      final DiagnosticPropertiesBuilder props = DiagnosticPropertiesBuilder();
      a.debugFillProperties(props);
      expect(props.properties, isNotEmpty);
    });
  });

  group('AppBarButtonGroup', () {
    testWidgets('empty group renders SizedBox.shrink', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapApp(const AppBarButtonGroup(children: [])),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('unified capsule renders dividers and handles each segment tap',
        (WidgetTester tester) async {
      int first = 0;
      int second = 0;
      int third = 0;

      await tester.pumpWidget(
        _wrapApp(
          AppBarButtonGroup.unified(
            variant: AppBarButtonVariant.glass,
            children: [
              AppBarButton.icon(Icons.search, onPressed: () => first++),
              AppBarButton.icon(Icons.favorite, onPressed: () => second++),
              AppBarButton.icon(Icons.share, onPressed: () => third++),
            ],
          ),
        ),
      );

      expect(find.byType(BackdropFilter), findsOneWidget);

      await tester.tap(find.byIcon(Icons.search));
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      expect(first, 1);
      expect(second, 1);
      expect(third, 1);
    });
  });

  group('Theming and value objects', () {
    testWidgets('AppBarButtonTheme and ThemeExtension propagate defaults', (
      WidgetTester tester,
    ) async {
      final Key themedKey = UniqueKey();

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            extensions: const [
              AppBarButtonThemeData(
                style: AppBarButtonStyle(
                  size: AppBarButtonSize.large,
                  variant: AppBarButtonVariant.outlined,
                ),
              ),
            ],
          ),
          home: Scaffold(
            body: Center(
              child: AppBarButton.icon(
                Icons.explore,
                key: themedKey,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(
          find.descendant(
            of: find.byKey(themedKey),
            matching: find.byType(AnimatedContainer),
          ),
        ),
        const Size(44, 44),
      );
    });

    test('AppBarButtonStyle copyWith, merge, lerp, and equality', () {
      const AppBarButtonStyle a = AppBarButtonStyle(
        variant: AppBarButtonVariant.tonal,
        backgroundColor: Colors.white,
        borderWidth: 1.0,
        iconSize: 18.0,
      );
      const AppBarButtonStyle b = AppBarButtonStyle(
        variant: AppBarButtonVariant.filled,
        backgroundColor: Colors.black,
        borderWidth: 3.0,
        iconSize: 22.0,
      );

      expect(a, equals(a.copyWith()));
      expect(a.hashCode, equals(a.copyWith().hashCode));
      expect(a.merge(null), equals(a));

      final AppBarButtonStyle merged = a.merge(
        const AppBarButtonStyle(iconSize: 24.0),
      );
      expect(merged.iconSize, 24.0);
      expect(merged.variant, AppBarButtonVariant.tonal);

      final AppBarButtonStyle? lerped = AppBarButtonStyle.lerp(a, b, 0.5);
      expect(lerped, isNotNull);
      expect(lerped!.borderWidth, 2.0);
      expect(lerped.iconSize, 20.0);

      final DiagnosticPropertiesBuilder props = DiagnosticPropertiesBuilder();
      a.debugFillProperties(props);
      expect(props.properties, isNotEmpty);
    });

    test('AppBarButtonThemeData copyWith, lerp, and equality', () {
      const AppBarButtonThemeData a = AppBarButtonThemeData(
        style: AppBarButtonStyle(iconSize: 18.0),
      );
      const AppBarButtonThemeData b = AppBarButtonThemeData(
        style: AppBarButtonStyle(iconSize: 22.0),
      );

      expect(a, equals(a.copyWith()));
      expect(a.hashCode, equals(a.copyWith().hashCode));
      expect(a.lerp(b, 0.5).style.iconSize, 20.0);
      expect(a.lerp(null, 0.5), equals(a));
    });
  });

  group('Resilience and edge cases', () {
    testWidgets('renders cleanly inside colored AppBar, dark mode, and RTL', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(useMaterial3: true),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                leading: const AppBarButton.back(),
                actions: [
                  AppBarButtonGroup(
                    children: [
                      AppBarButton.icon(
                        Icons.notifications,
                        badge: const AppBarButtonBadge.count(count: 3),
                        onPressed: () {},
                      ),
                      AppBarButton.pill(
                        icon: Icons.filter_list_rounded,
                        label: 'Filter',
                        variant: AppBarButtonVariant.outlined,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets(
        'truncates long pill label inside narrow container without '
        'overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapApp(
          SizedBox(
            width: 80,
            child: AppBarButton.pill(
              icon: Icons.edit_rounded,
              label: 'A Very Long Action Label That Would Otherwise Overflow',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('works safely without an enclosing Material or Scaffold', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: ThemeData(useMaterial3: true),
            child: Center(
              child: AppBarButton.icon(
                Icons.check_rounded,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(AppBarButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('respects disableAnimations accessibility setting', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrapApp(
          AppBarButton.icon(
            Icons.notifications,
            badge: const AppBarButtonBadge.dot(pulse: true),
            onPressed: () {},
          ),
          disableAnimations: true,
        ),
      );

      // With disableAnimations: true, pulse does not repeat so pumpAndSettle finishes immediately.
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'works seamlessly inside CupertinoApp and CupertinoNavigationBar',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        CupertinoApp(
          home: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: AppBarButton.back(
                onPressed: () => tapped = true,
              ),
              middle: const Text('Cupertino'),
              trailing: AppBarButton.icon(
                CupertinoIcons.bell,
                badge: const AppBarButtonBadge.dot(),
                onPressed: () {},
              ),
            ),
            child: const Center(child: Text('Body')),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      await tester.tap(find.byType(AppBarButton).first);
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets(
        'resets pressed state cleanly when transitioning into isLoading',
        (WidgetTester tester) async {
      bool loading = false;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Scaffold(
                body: Center(
                  child: AppBarButton.pill(
                    icon: Icons.cloud_upload_rounded,
                    label: 'Upload',
                    isLoading: loading,
                    onPressed: () => setState(() => loading = true),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(AppBarButton));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final AnimatedScale scaleWidget = tester.widget<AnimatedScale>(
        find.descendant(
          of: find.byType(AppBarButton),
          matching: find.byType(AnimatedScale),
        ),
      );
      expect(scaleWidget.scale, 1.0);
    });
  });
}
