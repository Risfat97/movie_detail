import 'dart:io';

import 'package:movie_detail/database_app.dart';
import 'package:movie_detail/film_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({this.film, Key? key}) : super(key: key);

  final Film? film;

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool _isFavorite = false;
  late DatabaseService _database;

  @override
  void initState() {
    super.initState();
    _database = DatabaseService();
  }

  void _handleClick() {
    _database.insert(widget.film);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: _handleClick,
            icon: Icon(
              (_isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.pink,
            )),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: const Text(
            "Favoris",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}

class RateIcon extends StatefulWidget {
  const RateIcon({required this.nbVote, Key? key}) : super(key: key);

  final int nbVote;
  @override
  State<RateIcon> createState() => _RateIconState();
}

class _RateIconState extends State<RateIcon> {
  late int _nbVote;

  @override
  void initState() {
    super.initState();
    _nbVote = widget.nbVote;
  }

  void _handleClick() {
    setState(() {
      if (_nbVote > widget.nbVote) {
        _nbVote--;
      } else {
        _nbVote++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: _handleClick,
            icon: Icon(
                (_nbVote > widget.nbVote) ? Icons.star : Icons.star_border,
                color: Colors.yellow.shade600)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            '$_nbVote',
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}

class ShareIcon extends StatelessWidget {
  const ShareIcon({required this.film, Key? key}) : super(key: key);

  final Film film;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final response = await http.get(Uri.parse(film.thumbnail));
              final bytes = response.bodyBytes;
              final temp = await getTemporaryDirectory();
              final path = '${temp.path}/image.jpg';
              File(path).writeAsBytesSync(bytes);
              await Share.shareFiles([path],
                  text: film.description, subject: film.title);
            },
            icon: Icon(Icons.share, color: Colors.blue.shade400)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: const Text(
            "Partager",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({required this.future, Key? key}) : super(key: key);

  final Future<Film> future;

  static Widget fromFilm(Film? film) {
    return ListView(
      children: <Widget>[
        Image.network(
          film!.thumbnail,
          height: 500,
          fit: BoxFit.fitWidth,
        ),
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 16),
          child: Center(
              child: Text(film.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20))),
        ),
        Container(
          decoration: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildRowButton(film),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding:
              const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
          child: Text(
            film.description,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }

  static List<Widget> _buildRowButton(Film? film) {
    return <Widget>[
      FavoriteIcon(
        film: film,
      ),
      RateIcon(nbVote: film!.voteCount),
      ShareIcon(film: film)
    ];
  }

  FutureBuilder<Film> _buildFutureBuilder() {
    return FutureBuilder<Film>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.id != -1) {
            return fromFilm(snapshot.data);
          } else if (snapshot.hasError ||
              (snapshot.hasData && snapshot.data!.id == -1)) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.yellow.shade700,
                  size: 48.0,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  child: const Text(
                    "Désolé nous n'avons rien trouvé concernant votre recherche!",
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ));
          }
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
              color: Colors.blue.shade600,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildFutureBuilder();
  }
}
