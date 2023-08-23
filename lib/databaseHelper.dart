import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test02/model/Misura.dart';

class DatabaseHelper {
  static Database? _database;
  static int index = 100000;

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._privateConstructor() {
    print("sono nel costruttore privato di databaseHelper");
    copyDb();
  }
  // DatabaseHelper() {
  //   copyDb();
  // }

  Future<Database?> _currentDatabase() async {
    if (_database != null) {
      return _database;
    }
    return _database = await openDatabase(
      join(await getDatabasesPath(), 'pressione.db'),
      //         onCreate: (database, version) {
      //   return database.execute(
      //       'CREATE TABLE articles(id INTEGER PRIMARY KEY, giorno TEXT, title TEXT, description TEXT, imageUrl TEXT)');
      // }, version: 2
      readOnly: false,
    );
  }

  Future<bool> insertMeasure(Map<String, dynamic> article) async {
    if (article['id'] == 0) article['id'] = index++;
    return (await (await _currentDatabase())?.insert('measures', article))! > 0;
  }

  Future<List<Map<String, dynamic>>?> getMeasures() async {
    return await (await _currentDatabase())
        ?.query('measures', orderBy: 'giorno DESC, orario DESC');
  }

  Future<void> copyDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "pressione.db");
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(url.join("assets", "pressione.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    _database = await openDatabase(path, readOnly: false);
  }

  Future<int> add(Misura m) async {
    if (m.id == 0) m.id = index++;
    await (await _currentDatabase())?.insert('measures', m.toMap());
    return Future.value(index);
  }

  Future<void> closeDB() {
    _database?.close();
    return Future.value(Void);
  }

  Future<int?> delete(int id) async {
    return await (await _currentDatabase())
        ?.delete('measures', where: 'id= ?', whereArgs: [id]);
  }

  Future<int?> update(Misura m) async {
    return await (await _currentDatabase())
        ?.update('measures', m.toMap(), where: 'id= ?', whereArgs: [m.id]);
  }

  Future<Misura> getFromId(int id) async {
    List<Map<String, Object?>>? res = await (await _currentDatabase())
        ?.query('measures', where: 'id= ?', whereArgs: [id]);
    Map<String, Object?> objRes = res![0];
    return Misura.fromMap(objRes);
  }
}
