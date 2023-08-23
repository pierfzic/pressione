// import 'dart:async';

// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:test02/model/Misura.dart';
// import 'package:test02/repository/repository.dart';

// class SqliteRepository extends Repository {
//   Database? _database;

//   static final SqliteRepository _instance =
//       SqliteRepository._privateConstructor();

//   factory SqliteRepository() {
//     return _instance;
//   }

//   SqliteRepository._privateConstructor() {
//     init();

//     // String dbPath = "";
//     // Future<String> futureDbPath = getDatabasesPath();
//     // futureDbPath.then((String data) => {dbPath = data});
//     // final _database = openDatabase(
//     //   join(dbPath, 'measures.db'),
//     //   onCreate: (db, version) {
//     //     return db.execute(
//     //       'CREATE TABLE pressure(id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, giorno TEXT, orario TEXT,  max INTEGER, min INTEGER, puls INTEGER);',
//     //     );
//     //   },
//     //   version: 1,
//     // );
//   }

//   Future<void> init() async {
//     _database =
//         await openDatabase(join(await getDatabasesPath(), 'measures.db'),
//             onCreate: (database, version) {
//       return database.execute(
//           'CREATE TABLE pressure(id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, giorno TEXT, orario TEXT,  max INTEGER, min INTEGER, puls INTEGER);');
//     }, version: 1);
//   }

//   @override
//   Future<void> add(Misura m) async {
//     // String sqlStr =
//     //     'INSERT INTO pressure(user, giorno, orario, max, min, puls) VALUES (Francesca, ${m.giorno},${m.orario}, ${m.max},${m.min},${m.puls})';
//     // _database?.execute(sqlStr);
//     // return Future.value(100);
//     final db = await _database;
//     await db?.insert(
//       'measures',
//       m.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return;
//   }

//   @override
//   Future<void> closeDB() async {
//     _database?.close();
//   }

//   @override
//   Future<bool> delete(int id) {
//     // TODO: implement delete
//     throw UnimplementedError();
//   }

//   @override
//   Future<Misura> get(int id) async {
//     String sqlStr = 'SELECT * FROM pressure WHERE id=${id}';
//     final db = await _database;
//     final List<Map<String, dynamic>> maps = await db!.rawQuery(sqlStr);
//     return List.generate(maps.length, (i) {
//       return Misura(
//         id: maps[0]['id'],
//         utente: maps[i]['tente'],
//         giorno: maps[i]['giorno'],
//         orario: maps[i]['orario'],
//         max: maps[i]['max'],
//         min: maps[i]['min'],
//         puls: maps[i]['puls'],
//       );
//     })[0];
//   }

//   @override
//   Future<List<Misura>> getAll() async {
//     final db = await _database;
//     final List<Map<String, dynamic>> maps =
//         await db!.query('measures', orderBy: 'giorno DESC, orario DESC');
//     // Convert the List<Map<String, dynamic> into a List<Dog>.
//     return List.generate(maps.length, (i) {
//       return Misura(
//         id: maps[i]['id'],
//         utente: maps[i]['tente'],
//         giorno: maps[i]['giorno'],
//         orario: maps[i]['orario'],
//         max: maps[i]['max'],
//         min: maps[i]['min'],
//         puls: maps[i]['puls'],
//       );
//     });
//   }

//   @override
//   Future<bool> put(int id, Misura m) {
//     // TODO: implement put
//     throw UnimplementedError();
//   }
// }
