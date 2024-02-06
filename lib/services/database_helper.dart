import 'package:password_bank_flutter/models/data_models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabaseHelper {
  static const int _version = 1;
  static const String dbName = "data.db";
  static const String tableName = "User";

  static Future<Database> _getDB() async {
    const String dbCreateSql =
        "CREATE TABLE $tableName (id TEXT PRIMARY KEY, name VARCHAR NOT NULL, password VARCHAR NOT NULL, emailId VARCHAR NOT NULL);";
    return openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) async => await db.execute(dbCreateSql),
        version: _version);
  }

  static Future<int> addUser(UserInfo user) async {
    final db = await _getDB();
    return await db.insert(tableName, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(UserInfo user) async {
    final db = await _getDB();
    return await db.update(tableName, user.toJson(),
        where: 'id = ?',
        whereArgs: [user.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteUser(UserInfo user) async {
    final db = await _getDB();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [user.id]);
  }

  static Future<List<UserInfo>?> getAllUsers() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => UserInfo.fromJson(maps[index]));
  }
}

class PasswordDatabaseHelper {
  static const int _version = 1;
  static const String dbName = "data1.db";
  static const String tableName = "Test";

  static Future<Database> _getDB() async {
    const String dbCreateSql =
        "CREATE TABLE $tableName (id TEXT PRIMARY KEY, title VARCHAR NOT NULL, password VARCHAR NOT NULL, about VARCHAR,  userId  VARCHAR NOT NULL);";
    return openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) async => await db.execute(dbCreateSql),
        version: _version);
  }

  static Future<int> addPassword(PasswordInfo password) async {
    final db = await _getDB();
    return await db.insert(tableName, password.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updatePassword(PasswordInfo password) async {
    final db = await _getDB();
    return await db.update(tableName, password.toJson(),
        where: 'id = ?',
        whereArgs: [password.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deletePassword(PasswordInfo password) async {
    final db = await _getDB();
    return await db
        .delete(tableName, where: 'id = ?', whereArgs: [password.id]);
  }

  static Future<int> deletePasswordUsingUserId(UserInfo user) async {
    final db = await _getDB();
    return db.delete(tableName, where: "userId = ?", whereArgs: [user.id]);
  }

  static Future<List<PasswordInfo>?> getAllPasswords() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => PasswordInfo.fromJson(maps[index]));
  }
}
