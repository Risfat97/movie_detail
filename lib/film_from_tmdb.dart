import 'package:movie_detail/detail_app.dart';
import 'package:movie_detail/film_app.dart';
import 'package:flutter/material.dart';
import 'package:movie_detail/typedef_app.dart';

class FilmFromTMDB extends StatelessWidget {
  const FilmFromTMDB({required this.film, this.onPush, Key? key})
      : super(key: key);

  final Film film;
  final PushCallback? onPush;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Détail'),
          backgroundColor: Colors.black,
        ),
        body: BodyWidget.fromFilm(film, false));
  }
}
