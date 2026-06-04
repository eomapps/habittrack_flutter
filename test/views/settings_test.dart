import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habittrack/core/constants/app_strings.dart';
import 'package:habittrack/core/constants/app_theme.dart';
import 'package:habittrack/viewmodels/settings_viewmodel.dart';
import 'package:habittrack/views/settings.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'settings_test.mocks.dart';

@GenerateMocks([SettingsViewmodel])
void main() {
  late MockSettingsViewmodel mockSettingsViewmodel;

  setUp(() {
    mockSettingsViewmodel = MockSettingsViewmodel();
    when(mockSettingsViewmodel.notificationsEnabled).thenReturn(true);
    when(mockSettingsViewmodel.notificationsBlockedByOS).thenReturn(false);
    when(mockSettingsViewmodel.themeDark).thenReturn(false);
    when(
      mockSettingsViewmodel.notificationTime,
    ).thenReturn(const TimeOfDay(hour: 9, minute: 0));
    when(
      mockSettingsViewmodel.canEnableNotifications(),
    ).thenAnswer((_) async => true);
    when(mockSettingsViewmodel.setNotifications(any)).thenAnswer((_) async {});
    when(mockSettingsViewmodel.setThemeDark(any)).thenAnswer((_) async {});
    when(
      mockSettingsViewmodel.setNotificationTime(any, any),
    ).thenAnswer((_) async {});
  });

  Widget buildSettingsScreen() {
    return ChangeNotifierProvider<SettingsViewmodel>.value(
      value: mockSettingsViewmodel,
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
      when(mockSettingsViewmodel.notificationsEnabled).thenReturn(false);
      await tester.pumpWidget(buildSettingsScreen());
      final switchFinder = find.descendant(
        of: find.byKey(const Key('settings-notifications-switch')),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });

    testWidgets('calls setNotifications(false) when tapped OFF', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSettingsScreen());
      await tester.tap(find.byKey(const Key('settings-notifications-switch')));
      await tester.pumpAndSettle();
      verify(mockSettingsViewmodel.setNotifications(false)).called(1);
    });

    testWidgets(
      'calls setNotifications(true) when tapped ON with permission granted',
      (WidgetTester tester) async {
        when(mockSettingsViewmodel.notificationsEnabled).thenReturn(false);
        await tester.pumpWidget(buildSettingsScreen());
        await tester.tap(
          find.byKey(const Key('settings-notifications-switch')),
        );
        await tester.pumpAndSettle();
        verify(mockSettingsViewmodel.setNotifications(true)).called(1);
      },
    );

    testWidgets(
      'shows blocked dialog when tapped ON with permission denied',
      (WidgetTester tester) async {
        when(mockSettingsViewmodel.notificationsEnabled).thenReturn(false);
        when(mockSettingsViewmodel.notificationsBlockedByOS).thenReturn(true);
        when(
          mockSettingsViewmodel.canEnableNotifications(),
        ).thenAnswer((_) async => false);
        await tester.pumpWidget(buildSettingsScreen());
        await tester.tap(
          find.byKey(const Key('settings-notifications-switch')),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text(AppStrings.notificationsBlocked), findsOneWidget);
      },
    );
  });

  group('notification time tile', () {
    testWidgets('is visible when notifications are enabled', (
      WidgetTester tester,
    ) async {
      when(
        mockSettingsViewmodel.canEnableNotifications(),
      ).thenAnswer((_) async => true);
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('is hidden when notifications are disabled', (
      WidgetTester tester,
    ) async {
      when(mockSettingsViewmodel.notificationsEnabled).thenReturn(false);
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.byIcon(Icons.timer), findsNothing);
    });

    testWidgets('label shows the current notificationTime', (
      WidgetTester tester,
    ) async {
      when(
        mockSettingsViewmodel.notificationTime,
      ).thenReturn(const TimeOfDay(hour: 8, minute: 30));
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.textContaining('8:30'), findsOneWidget);
    });
  });

  group('check permission tile', () {
    testWidgets('is visible when notificationsBlockedByOS == true', (
      WidgetTester tester,
    ) async {
      when(mockSettingsViewmodel.notificationsBlockedByOS).thenReturn(true);
      await tester.pumpWidget(buildSettingsScreen());
      expect(
        find.text(AppStrings.checkNotificationsPermission),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('is hidden when notificationsBlockedByOS == false', (
      WidgetTester tester,
    ) async {
      when(mockSettingsViewmodel.notificationsEnabled).thenReturn(true);
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.checkNotificationsPermission), findsNothing);
    });
  });

  group('theme switch', () {
    testWidgets('shows Dark Mode label and is ON when themeDark == true', (
      WidgetTester tester,
    ) async {
      when(mockSettingsViewmodel.themeDark).thenReturn(true);
      await tester.pumpWidget(buildSettingsScreen());
      expect(find.text(AppStrings.darkMode), findsOneWidget);
      final switchFinder = find.descendant(
        of: find.byKey(const Key('settings-themes-switch')),
        matching: find.byType(Switch),
      );
      expect(tester.widget<Switch>(switchFinder).value, isTrue);
    });

    testWidgets(
      'shows Light Mode label and is OFF when themeDark == false',
      (WidgetTester tester) async {
        when(mockSettingsViewmodel.themeDark).thenReturn(false);
        await tester.pumpWidget(buildSettingsScreen());
        expect(find.text(AppStrings.lightMode), findsOneWidget);
        final switchFinder = find.descendant(
          of: find.byKey(const Key('settings-themes-switch')),
          matching: find.byType(Switch),
        );
        expect(tester.widget<Switch>(switchFinder).value, isFalse);
      },
    );

    testWidgets('calls setThemeDark with toggled value when tapped', (
      WidgetTester tester,
    ) async {
      when(mockSettingsViewmodel.themeDark).thenReturn(false);
      await tester.pumpWidget(buildSettingsScreen());
      await tester.tap(find.byKey(const Key('settings-themes-switch')));
      await tester.pumpAndSettle();
      verify(mockSettingsViewmodel.setThemeDark(true)).called(1);
    });
  });
}
