import 'package:habittrack/core/constants/app_strings.dart';

const _nothingPassed = Object();

class Habit {
  final int? id;
  final String title;
  final String colorHex;
  final int streakCount;
  final String? lastCheckedDate;
  final bool toggledOn;

  Habit({
    this.id,
    required this.title,
    required this.colorHex,
    this.streakCount = 0,
    this.lastCheckedDate,
    this.toggledOn = false,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      title: map['title'] as String,
      colorHex: map['color_hex'] as String,
      streakCount: map['streak_count'] as int,
      lastCheckedDate: map['last_checked_date'] as String?,
      toggledOn: map['toggled_on'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'color_hex': colorHex,
      'streak_count': streakCount,
      'last_checked_date': lastCheckedDate,
      'toggled_on': toggledOn ? 1 : 0,
    };
  }

  Habit copyWith({
    int? id,
    String? title,
    String? colorHex,
    int? streakCount,
    Object? lastCheckedDate = _nothingPassed,
    bool? toggledOn,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      colorHex: colorHex ?? this.colorHex,
      streakCount: streakCount ?? this.streakCount,
      lastCheckedDate: lastCheckedDate == _nothingPassed
          ? this.lastCheckedDate
          : lastCheckedDate as String?,
      toggledOn: toggledOn ?? this.toggledOn,
    );
  }

  int get computedStreak {
    if (lastCheckedDate == null) return 0;

    final lastDate = DateTime.parse(lastCheckedDate!);
    final today = DateTime.now();
    final lastOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);

    final difference = todayOnly.difference(lastOnly).inDays;

    // checked today or yesterday
    if (difference == 0 || difference == 1) return streakCount;
    // broken streak, restart 0
    return 0;
  }

  String get getStreakMessage {
    if (streakCount > 0) {
      if (computedStreak == 0) {
        return '${AppStrings.longestStreak}${streakCount}d';
      } else {
        return '🔥 $computedStreak ${AppStrings.dayStreak}';
      }
    } else {
      return AppStrings.noStreakYet;
    }
  }
}
