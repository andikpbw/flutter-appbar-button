import 'package:appbar_button/appbar_button.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AppBarButtonExampleApp());
}

/// Root widget for the `appbar_button` interactive showcase.
class AppBarButtonExampleApp extends StatefulWidget {
  /// Creates an [AppBarButtonExampleApp].
  const AppBarButtonExampleApp({super.key});

  @override
  State<AppBarButtonExampleApp> createState() => _AppBarButtonExampleAppState();
}

class _AppBarButtonExampleAppState extends State<AppBarButtonExampleApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'appbar_button Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4F46E5),
        brightness: Brightness.light,
        extensions: const [
          AppBarButtonThemeData(
            style: AppBarButtonStyle(
              shape: AppBarButtonShape.squircle,
              hapticFeedback: AppBarButtonHaptic.light,
            ),
          ),
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6366F1),
        brightness: Brightness.dark,
        extensions: const [
          AppBarButtonThemeData(
            style: AppBarButtonStyle(
              shape: AppBarButtonShape.squircle,
              hapticFeedback: AppBarButtonHaptic.light,
            ),
          ),
        ],
      ),
      home: ShowcaseHomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Main interactive showcase screen demonstrating all [AppBarButton] features.
class ShowcaseHomePage extends StatefulWidget {
  /// Creates a [ShowcaseHomePage].
  const ShowcaseHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  /// Whether dark mode is currently enabled.
  final bool isDarkMode;

  /// Callback to switch between light and dark themes.
  final VoidCallback onToggleTheme;

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage> {
  bool _isBookmarked = false;
  bool _isFavorite = true;
  bool _isSaving = false;
  int _unreadCount = 5;
  AppBarButtonShape _activeShape = AppBarButtonShape.squircle;
  AppBarButtonSize _activeSize = AppBarButtonSize.medium;

  Future<void> _simulateSave() async {
    if (_isSaving) {
      return;
    }
    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
  }

  void _cycleUnread() {
    setState(() {
      if (_unreadCount == 0) {
        _unreadCount = 5;
      } else if (_unreadCount == 5) {
        _unreadCount = 128;
      } else {
        _unreadCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const Drawer(
        child: SafeArea(child: Center(child: Text('Navigation Drawer'))),
      ),
      appBar: AppBar(
        leading: const AppBarButton.menu(variant: AppBarButtonVariant.tonal),
        title: const Text(
          'appbar_button',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          AppBarButtonGroup(
            children: [
              AppBarButton.toggle(
                icon: Icons.dark_mode_outlined,
                selectedIcon: Icons.light_mode_rounded,
                isSelected: widget.isDarkMode,
                tooltip: 'Toggle theme',
                onPressed: widget.onToggleTheme,
              ),
              AppBarButton.icon(
                Icons.notifications_none_rounded,
                badge: AppBarButtonBadge.count(
                  count: _unreadCount,
                  pulse: _unreadCount > 0,
                ),
                tooltip: 'Notifications',
                onPressed: _cycleUnread,
              ),
              AppBarButton.pill(
                icon: Icons.check_rounded,
                label: 'Save',
                variant: AppBarButtonVariant.filled,
                isLoading: _isSaving,
                onPressed: _simulateSave,
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Glassmorphic Hero Header',
            subtitle: 'Frosted glass buttons over rich gradients and imagery',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF7C3AED),
                      Color(0xFFEC4899),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: Row(
                    children: [
                      AppBarButton.back(
                        variant: AppBarButtonVariant.glass,
                        shape: AppBarButtonShape.circle,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      AppBarButtonGroup.unified(
                        padding: EdgeInsets.zero,
                        variant: AppBarButtonVariant.glass,
                        children: [
                          AppBarButton.icon(
                            Icons.search_rounded,
                            onPressed: () {},
                          ),
                          AppBarButton.toggle(
                            icon: Icons.favorite_border_rounded,
                            selectedIcon: Icons.favorite_rounded,
                            isSelected: _isFavorite,
                            style: const AppBarButtonStyle(
                              selectedForegroundColor: Color(0xFFFFD1DC),
                              selectedBackgroundColor: Colors.transparent,
                            ),
                            onPressed: () =>
                                setState(() => _isFavorite = !_isFavorite),
                          ),
                          AppBarButton.icon(
                            Icons.ios_share_rounded,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Six Surface Variants',
            subtitle: 'Tap to experience press scale and surface feedback',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final AppBarButtonVariant variant
                    in AppBarButtonVariant.values)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBarButton.icon(
                        Icons.auto_awesome_rounded,
                        variant: variant,
                        shape: _activeShape,
                        size: _activeSize,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 6),
                      Text(
                        variant.name,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Shapes & Sizes',
            subtitle: 'Pick a shape and size to preview live across variants',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final AppBarButtonShape shape
                        in AppBarButtonShape.values)
                      AppBarButton.pill(
                        label: shape.name,
                        variant: _activeShape == shape
                            ? AppBarButtonVariant.filled
                            : AppBarButtonVariant.outlined,
                        size: AppBarButtonSize.small,
                        onPressed: () => setState(() => _activeShape = shape),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final AppBarButtonSize size in AppBarButtonSize.values)
                      AppBarButton.pill(
                        label: size.name,
                        variant: _activeSize == size
                            ? AppBarButtonVariant.filled
                            : AppBarButtonVariant.tonal,
                        size: AppBarButtonSize.small,
                        onPressed: () => setState(() => _activeSize = size),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Badges, Toggles, Avatars & Unified Capsules',
            subtitle: 'Modern real-world AppBar compositions',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppBarButton.icon(
                  Icons.mail_outline_rounded,
                  badge: const AppBarButtonBadge.dot(
                    color: Color(0xFFEF4444),
                    pulse: true,
                  ),
                  onPressed: () {},
                ),
                AppBarButton.icon(
                  Icons.shopping_bag_outlined,
                  badge: const AppBarButtonBadge.count(count: 142),
                  onPressed: () {},
                ),
                AppBarButton.icon(
                  Icons.bolt_rounded,
                  badge: const AppBarButtonBadge.label(
                    label: 'PRO',
                    color: Color(0xFF6366F1),
                  ),
                  onPressed: () {},
                ),
                AppBarButton.toggle(
                  icon: Icons.bookmark_border_rounded,
                  selectedIcon: Icons.bookmark_rounded,
                  isSelected: _isBookmarked,
                  variant: AppBarButtonVariant.outlined,
                  onPressed: () =>
                      setState(() => _isBookmarked = !_isBookmarked),
                ),
                AppBarButton.avatar(
                  avatar: CircleAvatar(
                    backgroundColor: cs.primaryContainer,
                    child: Text(
                      'HA',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                  badge: const AppBarButtonBadge.dot(
                    color: Color(0xFF22C55E),
                    alignment: AlignmentDirectional.bottomEnd,
                    offset: Offset(0, 0),
                  ),
                  onPressed: () {},
                ),
                AppBarButtonGroup.unified(
                  padding: EdgeInsets.zero,
                  variant: AppBarButtonVariant.outlined,
                  children: [
                    AppBarButton.icon(Icons.undo_rounded, onPressed: () {}),
                    AppBarButton.icon(Icons.redo_rounded, onPressed: () {}),
                    AppBarButton.icon(
                      Icons.more_horiz_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
