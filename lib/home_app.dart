import 'package:flutter/material.dart';
import 'package:movie_detail/film_app.dart';
import 'package:movie_detail/film_from_tmdb.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  final String _keyApi = '*';

  Future<List<Film>> _get(String url) async {
    var response = await http.get(Uri.parse(url +
        '/movie?api_key=$_keyApi&language=fr&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=free'));
    if (response.statusCode == 200) {
      return Film.fromJson(
          convert.jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception("Impossible to load data from TMDB.");
  }

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Future<List<Film>> _futureFilm;

  @override
  void initState() {
    super.initState();
    _futureFilm = widget._get('https://api.themoviedb.org/3/discover');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _futureFilm = widget._get('https://api.themoviedb.org/3/discover');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Découvertes'),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder<List<Film>>(
            future: _futureFilm,
            builder:
                (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {
              if (snapshot.hasData) {
                return _buildListView(snapshot.data);
              }
              if (snapshot.hasError) {
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
                        style: TextStyle(color: Colors.black87, fontSize: 20),
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
            }));
  }

  Widget _buildListView(List<Film>? listfilm) {
    int i = 0;
    final colors = [Colors.white, Colors.grey.shade200];
    final List<Widget> widgets = listfilm!.map((e) {
      return FilmWidget(film: e, color: colors[(i++) % 2], key: Key('${e.id}'));
    }).toList();
    return RefreshIndicator(
        child: ListView(children: widgets), onRefresh: _handleRefresh);
  }
}

class FilmWidget extends StatelessWidget {
  const FilmWidget({required this.film, required this.color, Key? key})
      : super(key: key);

  final Film film;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        film.thumbnail,
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          film.title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(film.description,
                style: const TextStyle(overflow: TextOverflow.ellipsis)),
          ),
          Text(
            film.date,
            style: const TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
          )
        ],
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => FilmFromTMDB(film: film)));
      },
      tileColor: color,
    );
  }
}
