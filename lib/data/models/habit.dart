class Habit {
  final int? id;
  final String title;
  final String colorHex;
  final int streakCount;
  final String? lastCheckedDate;

  Habit({
    this.id,
    required this.title,
    required this.colorHex,
    this.streakCount = 0,
    this.lastCheckedDate,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      title: map['title'] as String,
      colorHex: map['color_hex'] as String,
      streakCount: map['streak_count'] as int,
      lastCheckedDate: map['last_checked_date'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'color_hex': colorHex,
      'streak_count': streakCount,
      'last_checked_date': lastCheckedDate,
    };
  }

  Habit copyWith({
    int? id,
    String? title,
    String? colorHex,
    int? streakCount,
    String? lastCheckedDate,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      colorHex: colorHex ?? this.colorHex,
      streakCount: streakCount ?? this.streakCount,
      lastCheckedDate: lastCheckedDate ?? this.lastCheckedDate,
    );
  }
}
