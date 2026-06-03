import '../database/database_helper.dart';
import '../models/test_item.dart';

class TestRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<List<TestItem>> findByRoutine(int routineId) async {
    final db = await _databaseHelper.database;
    final result = await db.query(
      'tests',
      where: 'routine_id = ?',
      whereArgs: [routineId],
      orderBy: 'id ASC',
    );
    return result.map((map) => TestItem.fromMap(map)).toList();
  }

  Future<TestItem> insert(TestItem item) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('tests', item.toMap());
    return item.copyWith(id: id);
  }

  Future<void> update(TestItem item) async {
    final db = await _databaseHelper.database;
    await db.update(
      'tests',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteAllByRoutine(int routineId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'tests',
      where: 'routine_id = ?',
      whereArgs: [routineId],
    );
  }

  Future<int> countByRoutine(int routineId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tests WHERE routine_id = ?',
      [routineId],
    );
    return result.first['count'] as int? ?? 0;
  }

  Future<int> countTestedByRoutine(int routineId) async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tests WHERE routine_id = ? AND tested = 1',
      [routineId],
    );
    return result.first['count'] as int? ?? 0;
  }
}
