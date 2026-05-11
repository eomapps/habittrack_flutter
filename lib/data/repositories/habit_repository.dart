import 'package:eomappshabit_track/data/database/database_helper.dart';
import 'package:eomappshabit_track/data/models/habit.dart';

class HabitRepository {
  final DatabaseHelper _databaseHelper;

  HabitRepository(this._databaseHelper);

  Future<List<Habit>> getAll() async {
    final maps = await _databaseHelper.getAll();
    return maps.map((m) => Habit.fromMap(m)).toList();
  }

  Future<Habit> insert(Habit habit) async {
    final id = await _databaseHelper.insert(habit.toMap());
    return habit.copyWith(id: id);
  }

  Future<void> update(Habit habit) async {
    await _databaseHelper.update(habit.toMap());
  }

  Future<void> delete(int id) async {
    await _databaseHelper.delete(id);
  }
}
