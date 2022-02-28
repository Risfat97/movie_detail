import 'dart:async';

import 'package:movie_detail/services/database_app.dart';
import 'package:movie_detail/film_app.dart';

class FavoriteService {
  static FavoriteService? _instance;
  static FavoriteService getInstance() {
    _instance ??= FavoriteService._create();
    return _instance!;
  }

  final DatabaseService _database = DatabaseService();

  final StreamController<List<Film>> _favoriteController =
      StreamController<List<Film>>.broadcast();
  StreamSink<List<Film>> get _inFavorites => _favoriteController.sink;
  Stream<List<Film>> get favorites => _favoriteController.stream;

  final StreamController<Film> _addFavoriteController =
      StreamController<Film>.broadcast();
  StreamSink<Film> get inAddFavorite => _addFavoriteController.sink;

  final StreamController<Film> _removeFavoriteController =
      StreamController<Film>.broadcast();
  StreamSink<Film> get inRemoveFavorite => _removeFavoriteController.sink;

  FavoriteService._create() {
    getFavorites();
    _addFavoriteController.stream.listen(handleAddFavorite);
    _removeFavoriteController.stream.listen(handleDeleteFavorite);
  }

  void dispose() {
    _favoriteController.close();
    _addFavoriteController.close();
    _removeFavoriteController.close();
  }

  void getFavorites() async {
    List<Film> listFilm = await _database.getFavorites();
    _inFavorites.add(listFilm);
  }

  void handleAddFavorite(Film film) async {
    await _database.insert(film);
    getFavorites();
  }

  void handleDeleteFavorite(Film film) async {
    await _database.delete(film.id);
    getFavorites();
  }
}
