import '/model/authentication/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqflite.dart';

class Database {
  static const String _dbName = 'caps.db';
  static const String _userTable = 'user';

  static Future<sqflite.Database> database() async {
    return sqflite.openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: 1,
      readOnly: false,
      singleInstance: true,
      onCreate: (sqflite.Database database, int version) async {
        await _createTables(database);
      },
    );
  }

  static Future<void> _createTables(sqflite.Database database) async {
    await _createUserTable(database);
    debugPrint("Created User Table...");
  }

  static Future<void> _createUserTable(sqflite.Database? database) async {
    await database!.execute(
      """CREATE TABLE IF NOT EXISTS $_userTable (
      id INTEGER PRIMARY KEY,
      image TEXT,
      token TEXT,
      fname TEXT,
      lname TEXT,
      email TEXT,
      phone TEXT,
      state TEXT,
      pin TEXT,
      usertype TEXT,
      balance TEXT,
      bonus TEXT,
      regstatus TEXT,
      otp TEXT,
      regdate TEXT,
      lastactivity TEXT,
      referrer TEXT
    )""",
    );
  }

  static Future<void> saveUser({UserData? user}) async {
    final db = await Database.database();
    final List<Map<String, dynamic>> result = await db.query(_userTable);
    if (result.isEmpty) {
      // No user record, insert new one
      await db
          .insert(
        _userTable,
        user!.toJson(),
      )
          .then((value) {
        debugPrint("Saved ${user.toJson()}");
      });
    } else {
      // User record exists, update it
      await db
          .update(
        _userTable,
        user!.toJson(),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      )
          .then((value) {
        debugPrint("Updated ${user.toJson()}");
      });
    }
  }

  static Future<UserModel?> getUser() async {
    final db = await Database.database();
    final List<Map<String, dynamic>> maps = await db.query(
      _userTable,
    );
    if (maps.isNotEmpty) {
      UserModel userData = UserModel(
        msg: "",
        data: UserData.fromJson(maps.first),
      );
      debugPrint("Fetched User: ${userData.toJson()}");
      return userData;
    }
    return null;
  }
}
