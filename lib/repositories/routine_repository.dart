import '../database/database_helper.dart';
import '../models/routine.dart';

class RoutineRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<Routine>> findAll() async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'routines',
      orderBy: 'date DESC, created_at DESC',
    );
    return result.map((map) => Routine.fromMap(map)).toList();
  }

  Future<Routine> insert(Routine routine) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('routines', routine.toMap());
    return routine.copyWith(id: id);
  }

  Future<Routine?> findById(int id) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'routines',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return Routine.fromMap(result.first);
  }

  Future<void> delete(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('routines', where: 'id = ?', whereArgs: [id]);
  }
}
