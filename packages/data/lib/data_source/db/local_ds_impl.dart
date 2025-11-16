import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../../entities/entities.dart';
import '../base_data_source.dart';

class LocalDataSource implements BaseDataSource {
  static const String _databaseName = 'todo_monorepo.db';
  static const int _databaseVersion = 2;
  static const String _tasksTable = 'tasks';
  static const String _usersTable = 'users';
  static const Map<String, String> _tasksColumns = {
    'id': 'id',
    'userId': 'userId',
    'title': 'title',
    'description': 'description',
    'isDone': 'isDone',
    'createdAt': 'createdAt',
    'updatedAt': 'updatedAt',
  };
  static const Map<String, String> _usersColumns = {
    'id': 'id',
    'name': 'name',
    'password': 'password',
  };
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  LocalDataSource() {
    _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      path.join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute('DROP TABLE IF EXISTS $_tasksTable');
        await db.execute('DROP TABLE IF EXISTS $_usersTable');
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_tasksTable (
        ${_tasksColumns['id']} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${_tasksColumns['userId']} INTEGER NOT NULL,
        ${_tasksColumns['title']} TEXT NOT NULL,
        ${_tasksColumns['description']} TEXT,
        ${_tasksColumns['isDone']} INTEGER NOT NULL DEFAULT 0,
        ${_tasksColumns['createdAt']} TEXT NOT NULL,
        ${_tasksColumns['updatedAt']} TEXT NOT NULL,
        FOREIGN KEY (${_tasksColumns['userId']}) REFERENCES $_usersTable(${_usersColumns['id']})
      )
    ''');
    await db.execute('''
      CREATE TABLE $_usersTable (
        ${_usersColumns['id']} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${_usersColumns['name']} TEXT NOT NULL UNIQUE,
        ${_usersColumns['password']} TEXT NOT NULL
      )
    ''');
  }

  @override
  Future<List<TaskEntity>> getTasks(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tasksTable,
      where: '${_tasksColumns['userId']} = ?',
      whereArgs: [userId],
    );
    print(maps);

    return maps.map((map) => TaskEntity.fromJson(map)).toList();
  }

  @override
  Future<bool> addTask(TaskEntity task) async {
    final db = await database;
    final now = DateTime.now();

    final taskWithDates = task.copyWith(createdAt: now, updatedAt: now);

    final taskJson = taskWithDates.toJson();
    taskJson.remove('id');

    int id = await db.insert(_tasksTable, taskJson);
    return id > 0;
  }

  @override
  Future<bool> deleteTask(int id) async {
    final db = await database;
    int success = await db.delete(
      _tasksTable,
      where: '${_tasksColumns['id']} = ?',
      whereArgs: [id],
    );
    return success == 1;
  }

  @override
  Future<bool> updateTask(TaskEntity task) async {
    final db = await database;

    final taskWithUpdatedDate = TaskEntity(
      id: task.id,
      userId: task.userId,
      title: task.title,
      description: task.description,
      isDone: task.isDone,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
    );

    int success = await db.update(
      _tasksTable,
      taskWithUpdatedDate.toJson(),
      where: '${_tasksColumns['id']} = ?',
      whereArgs: [task.id],
    );
    return success == 1;
  }

  @override
  Future<UserEntity?> signIn(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: '${_usersColumns['name']} = ?',
      whereArgs: [username],
    );
    if (maps.isEmpty) return null;
    return UserEntity.fromJson(maps.first);
  }

  @override
  Future<UserEntity?> signUp(String username, String password) async {
    final db = await database;
    int id = await db.insert(_usersTable, {
      _usersColumns['name']!: username,
      _usersColumns['password']!: password,
    });
    if (id <= 0) return null;

    final maps = await db.query(_usersTable, where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return UserEntity.fromJson(maps.first);
  }
}
