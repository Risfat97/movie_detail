import 'package:movie_detail/detail_app.dart';
import 'package:movie_detail/favorites_app.dart';
import 'package:movie_detail/film_app.dart';
import 'package:flutter/material.dart';

class FilmFromTMDB extends StatelessWidget {
  const FilmFromTMDB({required this.film, Key? key}) : super(key: key);

  final Film film;

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
        body: BodyWidget.fromFilm(film));
  }
}
