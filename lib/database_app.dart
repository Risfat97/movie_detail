import 'package:movie_detail/film_app.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

class DatabaseService {
  Future<Database>? _database;
  static final DatabaseService _instance = DatabaseService._create();

  DatabaseService._create();

  factory DatabaseService() {
    return _instance;
  }

  Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = openDatabase(
        join(await getDatabasesPath(), 'favorite_films_database.db'),
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE favoris(
            id BIGINT PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            description TEXT,
            thumbnail VARCHAR(255),
            vote_count BIGINT,
            is_movie TINYINT(1),
            date VARCHAR(64)
          )
        ''');
    }, version: 1);
  }

  Future insert(Film? film) async {
    if (film == null) return;
    if (_database == null) {
      await init();
    }
    final db = await _database;
    await db!.insert('favoris', film.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Film>> getFavorites() async {
    if (_database == null) {
      await init();
    }
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db!.query('favoris');

    return List.generate(maps.length, (i) {
      return Film(
          id: maps[i]['id'],
          title: maps[i]['title'],
          description: maps[i]['description'],
          voteCount: maps[i]['vote_count'],
          thumbnail: maps[i]['thumbnail'],
          isMovie: (maps[i]['is_movie'] == 1),
          date: maps[i]['date']);
    });
  }

  Future<List<Film>> find(int id) async {
    if (_database == null) {
      await init();
    }
    final db = await _database;
    final List<Map<String, dynamic>> result =
        await db!.query('favoris', where: 'id = ?', whereArgs: [id]);

    return List.generate(
        result.length,
        (i) => Film(
            id: result[i]['id'],
            title: result[i]['title'],
            description: result[i]['description'],
            voteCount: result[i]['vote_count'],
            thumbnail: result[i]['thumbnail'],
            isMovie: (result[i]['is_movie'] == 1),
            date: result[i]['date']));
  }

  Future delete(int id) async {
    if (_database == null) {
      await init();
    }
    final db = await _database;
    await db!.delete('favoris', where: 'id = ?', whereArgs: [id]);
  }
}
