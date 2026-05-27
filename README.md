# HabitTrack

A lightweight, offline-first habit tracking app built with Flutter — running on both iOS and Android.

## Screenshots

| | Splash | Today (Empty) | Today (Active) | Add Habit |
|---|:---:|:---:|:---:|:---:|
| **iOS** | <img src="docs/ios_splash.png" width="160"/> | <img src="docs/ios_home_empty.png" width="160"/> | <img src="docs/ios_home_habits.png" width="160"/> | <img src="docs/ios_add_habit.png" width="160"/> |
| **Android** | <img src="docs/android_splash.png" width="160"/> | <img src="docs/android_home.png" width="160"/> | <img src="docs/android_home_habits.png" width="160"/> | <img src="docs/android_add_habit.png" width="160"/> |

| | Edit Habit | Progress | 
|---|:---:|:---:|
| **iOS** | <img src="docs/ios_edit_habit.png" width="160"/> | <img src="docs/ios_progress.png" width="160"/> | 
| **Android** | <img src="docs/android_edit_habit.png" width="160"/> | <img src="docs/android_progress.png" width="160"/> | 

## Features

- ✅ Track daily habits and maintain streaks
- ✅ Color-coded habit cards for quick visual scanning
- ✅ Separate "Not Done" / "Done Today" sections, updated in real time
- ✅ Add, edit, and delete habits via a BottomSheet with name and color picker
- ✅ Progress charts and streak history visualization
- ✅ Dark mode with system default and manual toggle in Settings
- ✅ Polished splash screen on iOS and Android (including Android 12+ adaptive splash)
- ✅ Custom launcher icons across both platforms
- ✅ Fully offline — no account or login required
- ✅ Cross-platform: iOS and Android from a single codebase
- ✅ Unit and data layer tests with flutter_test and mockito

## Tech Stack

| Layer | Choice | Notes |
|---|---|---|
| Language | Dart / Flutter | SDK `^3.44.0` |
| State management | Provider | MVVM — `HabitViewModel` and `SettingsViewmodel` are the sources of truth |
| Persistence | sqflite + shared_preferences | SQLite for habits, shared_preferences for settings |
| Fonts | Nunito (Google Fonts) | 400 / 500 / 600 / 700 weights |
| Splash | flutter_native_splash | Android 12+ adaptive splash configured |
| Icons | flutter_launcher_icons | 1024px source icon |

## Architecture

MVVM using Provider. `HabitViewModel` extends `ChangeNotifier` and is the single source of truth for habit state. `SettingsViewmodel` manages user preferences including theme and notification settings, persisted via shared_preferences. Screens consume viewmodels via `context.watch` — no business logic in widgets. Persistence is handled by sqflite through a dedicated repository layer, keeping the data layer cleanly separated from the UI. Theming uses Flutter's `ThemeExtension` with a custom `AppColorTokens` class providing light and dark token sets.

```
habittrack/
├── assets/
│   ├── fonts/          # Nunito 400–700, FiraCode 500–700
│   ├── icon/           # 1024px launcher icon source
│   ├── images/
│   └── splash/         # Splash assets, Android 12+ adaptive
├── docs/               # README screenshots
├── lib/
│   ├── core/
│   │   ├── constants/  # Colors, tokens, text styles, dimensions, strings, theme
│   │   └── utils/      # Helper utilities, context extensions
│   ├── data/
│   │   ├── database/   # DatabaseHelper (sqflite)
│   │   ├── models/     # Habit
│   │   └── repositories/
│   ├── viewmodels/     # HabitViewModel, SettingsViewmodel (ChangeNotifier)
│   └── views/
│       ├── add_edit_habit/ # AddEditHabitBottomSheet
│       ├── settings/       # SettingsScreen
│       └── home/           # HomeScreen (IndexedStack): TodayScreen, ProgressScreen
│           └── widgets/    # HabitCard, ProgressCard, TodayPlaceholder, ProgressPlaceholder
├── test/
│   ├── data/
│   │   ├── models/         # Unit tests: Habit.computedStreak logic
│   │   └── viewmodels/     # Unit tests: HabitViewModel streak logic (mockito)
│   └── views/
│       └── home/
│           └── widgets/    # Widget tests: HabitCard, TodayScreen, AddEditDeleteHabitBottomSheet
├── README.md
└── pubspec.yaml
```

## Roadmap

- [ ] Widget tests — flutter_test, mockito (in progress)
- [ ] Daily reminders / local notifications
- [ ] Riverpod branch — alternate state management implementation for comparison

## Getting Started

### Prerequisites

- Flutter 3.x / Dart 3.x
- VS Code with the [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
- Android SDK via Android Studio (emulator / device builds)
- Xcode (macOS only — required for iOS simulator and device builds)

### Clone & run

```bash
git clone https://github.com/eomapps/habittrack_flutter.git
cd habittrack_flutter
flutter pub get
flutter run
```