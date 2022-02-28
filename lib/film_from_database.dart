import 'package:movie_detail/services/database_app.dart';
import 'package:movie_detail/detail_app.dart';
import 'package:movie_detail/film_app.dart';
import 'package:flutter/material.dart';
import 'package:movie_detail/typedef_app.dart';

class FilmFromDatabase extends StatefulWidget {
  FilmFromDatabase({required this.id, this.onPush, Key? key}) : super(key: key);

  final int id;
  final DatabaseService dbService = DatabaseService();
  final PushCallback? onPush;

  @override
  State<FilmFromDatabase> createState() => _FilmFromDatabaseState();
}

class _FilmFromDatabaseState extends State<FilmFromDatabase> {
  late Future<Film> _future;

  Future<Film> _get(int id) async {
    List<Film> results = await widget.dbService.find(id);
    return (results.isNotEmpty) ? results[0] : const Film();
  }

  @override
  void initState() {
    super.initState();
    _future = _get(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Détail'),
          backgroundColor: Colors.black,
        ),
        body: BodyWidget(future: _future, inFavorite: true));
  }
}
