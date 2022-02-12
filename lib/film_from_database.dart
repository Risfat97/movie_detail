import 'package:movie_detail/database_app.dart';
import 'package:movie_detail/detail_app.dart';
import 'package:movie_detail/favorites_app.dart';
import 'package:movie_detail/film_app.dart';
import 'package:flutter/material.dart';

class FilmFromDatabase extends StatefulWidget {
  FilmFromDatabase({required this.id, Key? key}) : super(key: key);

  final int id;
  final DatabaseService dbService = DatabaseService();

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
          title: const Text('Movie Detail'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListFavorite()));
                    },
                    icon: const Icon(Icons.list)))
          ],
        ),
        body: BodyWidget(future: _future));
  }
}
