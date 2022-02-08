import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:movie_detail/home_app.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailArguments;
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Movie Detail'),
          backgroundColor: Colors.black,
        ),
        body: BodyWidget(query: args.query));
  }
}

class FavoriteIcon extends StatefulWidget {
  const FavoriteIcon({Key? key}) : super(key: key);

  @override
  State<FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool _isFavorite = false;

  void _handleClick() {
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

class Film {
  final int id;
  final String title;
  final String description;
  final String thumbnail;
  final int voteCount;

  const Film(
      {this.id = -1,
      this.title = '',
      this.description = '',
      this.thumbnail = '',
      this.voteCount = 0});

  factory Film.fromJson(Map<String, dynamic> json) {
    if (json['total_results'] > 0) {
      if (json['results'][0]['known_for'] != null &&
          (json['results'][0]['known_for']).length > 0) {
        return Film(
            id: json['results'][0]['known_for'][0]['id'],
            voteCount: json['results'][0]['known_for'][0]['vote_count'],
            title: json['results'][0]['known_for'][0]['title'],
            description: json['results'][0]['known_for'][0]['overview'],
            thumbnail: 'https://image.tmdb.org/t/p/w500/' +
                json['results'][0]['known_for'][0]['poster_path']);
      }
      return Film(
          id: json['results'][0]['id'],
          voteCount: json['results'][0]['vote_count'],
          title: json['results'][0]['title'] ?? json['results'][0]['name'],
          description: json['results'][0]['overview'],
          thumbnail: 'https://image.tmdb.org/t/p/w500/' +
              json['results'][0]['poster_path']);
    }
    return const Film();
  }
}

class BodyWidget extends StatefulWidget {
  const BodyWidget({required this.query, Key? key}) : super(key: key);

  final String query;
  final String _keyApi = '*';

  List<Widget> _buildRowButton(Film? film) {
    return <Widget>[
      const FavoriteIcon(),
      RateIcon(nbVote: film!.voteCount),
      ShareIcon(film: film)
    ];
  }

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  late Future<Film> _film;

  Future<Film> _get(String url) async {
    var response = await http.get(Uri.parse(url +
        '/multi?api_key=${widget._keyApi}&language=fr&query=${widget.query}'));
    if (response.statusCode == 200) {
      return Film.fromJson(
          convert.jsonDecode(response.body) as Map<String, dynamic>);
    }
    return const Film();
  }

  @override
  void initState() {
    super.initState();
    _film = _get('https://api.themoviedb.org/3/search');
  }

  FutureBuilder<Film> _buildFutureBuilder() {
    return FutureBuilder<Film>(
        future: _film,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.id != -1) {
            return ListView(
              children: <Widget>[
                Image.network(
                  snapshot.data!.thumbnail,
                  height: 500,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Center(
                      child: Text(snapshot.data!.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20))),
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.black87),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget._buildRowButton(snapshot.data),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.only(
                      top: 8, left: 16, right: 16, bottom: 8),
                  child: Text(
                    snapshot.data!.description,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              ],
            );
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
