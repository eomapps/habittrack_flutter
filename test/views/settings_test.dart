import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/main.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:habittrack/views/settings.dart';

class FakeSettingsViewModel extends SettingsViewmodel {
  final SettingsState initialState;
  bool setNotificationsCalled = false;
  bool? setNotificationsArg;
  bool setThemeCalled = false;
  bool? setThemeArg;
  bool canEnablePermissions = true;

  FakeSettingsViewModel(this.initialState);

  @override
  build() => initialState;

  @override
  Future<void> setNotifications(bool value) async {
    setNotificationsCalled = true;
    setNotificationsArg = value;
  }

  @override
  Future<void> setThemeDark(bool useThemeDark) async {
    setThemeCalled = true;
    setThemeArg = useThemeDark;
  }

  @override
  Future<bool> canEnableNotifications() async {
    return canEnablePermissions;
  }
}

final defaultState = SettingsState(
  notificationsEnabled: true,
  notificationTime: const TimeOfDay(hour: 9, minute: 0),
  themeDark: false,
  notificationsBlockedByOS: false,
);

void main() {
  Widget buildSettingsScreen({FakeSettingsViewModel? fake}) {
    return ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          () => fake ?? FakeSettingsViewModel(defaultState),
        ),
      ],
      child: MaterialApp(theme: AppTheme.light, home: SettingsScreen()),
    );
  }

  group('rendering', () {
    testWidgets('shows Settings app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.settings), findsOneWidget);
    });

    testWidgets('shows NOTIFICATIONS section header', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.notifications.toUpperCase()), findsOneWidget);
    });

    testWidgets('shows APPEARANCE section header', (WidgetTester tester) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.appearance.toUpperCase()), findsOneWidget);
    });

    testWidgets('shows attribution text', (WidgetTester tester) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.attribution), findsOneWidget);
    });
  });

  group('notifications switch', () {
    testWidgets('is ON when notificationsEnabled == true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSettingsScreen());
      final switchFinder = find.descendant(
        of: find.byKey(const Key('settings-notifications-switch')),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
    });

    testWidgets('is OFF when notificationsEnabled == false', (
      WidgetTester tester,
    ) async {
      final settingsState = defaultState.copyWith(notificationsEnabled: false);
      final settings = FakeSettingsViewModel(settingsState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      final switchFinder = find.descendant(
        of: find.byKey(const Key('settings-notifications-switch')),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });

    testWidgets('calls setNotifications(false) when tapped OFF', (
      WidgetTester tester,
    ) async {
      final settings = FakeSettingsViewModel(defaultState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      await tester.tap(find.byKey(const Key('settings-notifications-switch')));
      await tester.pumpAndSettle();
      expect(settings.setNotificationsCalled, isTrue);
      expect(settings.setNotificationsArg, false);
    });
    testWidgets(
      'calls setNotifications(true) when tapped ON with permission granted',
      (WidgetTester tester) async {
        final settingsState = defaultState.copyWith(
          notificationsEnabled: false,
        );
        final settings = FakeSettingsViewModel(settingsState);
        settings.canEnablePermissions = true;
        await tester.pumpWidget(buildSettingsScreen(fake: settings));
        await tester.tap(
          find.byKey(const Key('settings-notifications-switch')),
        );
        await tester.pumpAndSettle();
        expect(settings.setNotificationsArg, isTrue);
      },
    );

    testWidgets('shows blocked dialog when tapped ON with permission denied', (
      WidgetTester tester,
    ) async {
      final settingsState = defaultState.copyWith(
        notificationsEnabled: false,
        notificationsBlockedByOS: true,
      );
      final settings = FakeSettingsViewModel(settingsState);
      settings.canEnablePermissions = false;
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      await tester.tap(find.byKey(const Key('settings-notifications-switch')));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(AppStrings.notificationsBlocked), findsOneWidget);
    });
  });

  group('notification time tile', () {
    testWidgets('is visible when notifications are enabled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('is hidden when notifications are disabled', (
      WidgetTester tester,
    ) async {
      final settingsState = defaultState.copyWith(notificationsEnabled: false);
      final settings = FakeSettingsViewModel(settingsState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      expect(find.byIcon(Icons.timer), findsNothing);
    });

    testWidgets('label shows the current notificationTime', (
      WidgetTester tester,
    ) async {
      final settingsState = defaultState.copyWith(
        notificationTime: TimeOfDay(hour: 8, minute: 30),
      );
      final settings = FakeSettingsViewModel(settingsState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      expect(find.textContaining('8:30'), findsOneWidget);
    });
  });

  group('check permission tile', () {
    testWidgets('is visible when notificationsBlockedByOS == true', (
      WidgetTester tester,
    ) async {
      final settingsState = defaultState.copyWith(
        notificationsBlockedByOS: true,
      );
      final settings = FakeSettingsViewModel(settingsState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      expect(
        find.text(AppStrings.checkNotificationsPermission),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('is hidden when notificationsBlockedByOS == false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.checkNotificationsPermission), findsNothing);
    });
  });

  group('theme switch', () {
    testWidgets('shows Dark Mode label and is ON when themeDark == true', (
      WidgetTester tester,
    ) async {
      final settingsState = defaultState.copyWith(themeDark: true);
      final settings = FakeSettingsViewModel(settingsState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      expect(find.text(AppStrings.darkMode), findsOneWidget);
      final switchFinder = find.descendant(
        of: find.byKey(const Key('settings-themes-switch')),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
    });

    testWidgets('shows Light Mode label and is OFF when themeDark == false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.lightMode), findsOneWidget);
      final switchFinder = find.descendant(
        of: find.byKey(const Key('settings-themes-switch')),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });

    testWidgets('calls setThemeDark with toggled value when tapped', (
      WidgetTester tester,
    ) async {
      final settings = FakeSettingsViewModel(defaultState);
      await tester.pumpWidget(buildSettingsScreen(fake: settings));
      await tester.tap(find.byKey(const Key('settings-themes-switch')));
      await tester.pumpAndSettle();
      expect(settings.setThemeArg, isTrue);
    });
  });
}
