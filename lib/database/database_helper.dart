import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    final dbPath = _buildDatabasePath();

    _database = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: _createDatabase,
        onUpgrade: _onUpgrade,
      ),
    );

    return _database!;
  }

  String _buildDatabasePath() {
    final String folder = Platform.environment['UserProfile'] ?? '';
    final String user = folder.split('\\')[2];

    // final pathDb = '$folder${Platform.pathSeparator}orion_tester.db';
    final basePath = const String.fromEnvironment('PATH');
    final pathDb = 'C:\\Users\\$user\\$basePath';

    return pathDb;
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE routines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        full_name TEXT NOT NULL,
        created_at TEXT NOT NULL,
        observations TEXT,
      );
    ''');

    await db.execute('''
      
      CREATE TABLE tests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        routine_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        comment TEXT,
        tested INTEGER DEFAULT 0,
        status INTEGER DEFAULT 0,
        dateTime TEXT,
        FOREIGN KEY(routine_id) REFERENCES routines(id)
      );
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE routines
      ADD COLUMN observations TEXT
    ''');
    }
  }
}
