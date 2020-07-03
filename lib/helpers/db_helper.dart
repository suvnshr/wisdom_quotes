import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

/// Database Definition and Operations are defined in this class.
class DatabaseHelper {
  static final _databaseName = 'MyDatabase.db';
  static final _databaseVersion = 1;

  static final table = 'my_quotes';

  static final columnId = '_id';
  static final columnQuoteKey = 'quotekey';
  static final columnName = 'author';
  static final columnQuote = 'quote';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  /// static variable to access db from anywhere.
  static Database _database;

  /// db getter function.
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  /// Database initialisation is done here.
  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String query = '''
    CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnQuoteKey TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnQuote TEXT NOT NULL
          )
    ''';
    await db.execute(query);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> rowsWithThisKey(String quoteKey) async {
    Database db = await instance.database;
    return await db.query(
      table,
      columns: [columnQuoteKey],
      where: '$columnQuoteKey = ?',
      whereArgs: [quoteKey],
    );
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(
      table,
      orderBy: '$columnId DESC',
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteByKey(String quoteKey) async {
    Database db = await instance.database;
    return await db.delete(
      table,
      where: '$columnQuoteKey = ?',
      whereArgs: [quoteKey],
    );
  }
}
