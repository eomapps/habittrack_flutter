# HabitTrack

A lightweight habit tracking app built with Flutter.

## Architecture
MVVM using Provider. `HabitViewModel` extends `ChangeNotifier` and is the 
single source of truth for habit state. Screens consume it via `Consumer<HabitViewModel>` 
— no business logic in widgets. Persistence handled by sqflite.