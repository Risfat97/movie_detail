import 'package:flutter/material.dart';
import 'package:movie_detail/database_app.dart';
import 'package:movie_detail/film_app.dart';
import 'package:movie_detail/film_from_database.dart';

typedef DeleteCallback = Function(int id);

class ListFavorite extends StatefulWidget {
  const ListFavorite({Key? key}) : super(key: key);

  @override
  State<ListFavorite> createState() => _ListFavoriteState();
}

class _ListFavoriteState extends State<ListFavorite> {
  late DatabaseService _database;
  late Future<List<Film>> _favorisFuture;

  @override
  void initState() {
    super.initState();
    _database = DatabaseService();
    _database.init();
    _favorisFuture = _database.getFavorites();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleDelete(int id) {
    _database.delete(id);
    setState(() {
      _favorisFuture = _database.getFavorites();
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _favorisFuture = _database.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Favoris'),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
            body: FutureBuilder<List<Film>>(
                future: _favorisFuture,
                builder: (context, snapshot) {
                  return _buildListView(
                      snapshot.hasData ? snapshot.data : <Film>[]);
                })));
  }

  Widget _buildListView(List<Film>? listfilm) {
    late ListView listView;
    if (listfilm == null || listfilm.isEmpty) {
      listView = ListView(
        children: [
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 92,
            child: const Center(
                child: Text(
              "Aucun film trouvé dans vos favoris",
              style: TextStyle(color: Colors.black87, fontSize: 18),
              textAlign: TextAlign.center,
            )),
          )
        ],
      );
    } else {
      int i = 0;
      final colors = [Colors.white, Colors.grey.shade200];
      final List<Widget> widgets = listfilm.map((e) {
        return FavoriteWidget(
            film: e,
            color: colors[(i++) % 2],
            handleDelete: _handleDelete,
            key: Key('${e.id}'));
      }).toList();
      listView = ListView(children: widgets);
    }

    return RefreshIndicator(child: listView, onRefresh: _handleRefresh);
  }
}

class FavoriteWidget extends StatelessWidget {
  const FavoriteWidget(
      {required this.film,
      required this.color,
      required this.handleDelete,
      Key? key})
      : super(key: key);

  final Film film;
  final Color color;
  final DeleteCallback handleDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      child: ListTile(
        leading: Image.network(
          film.thumbnail,
        ),
        title: Text(
          film.title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        ]),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            handleDelete(film.id);
          },
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FilmFromDatabase(id: film.id)));
        },
        tileColor: color,
      ),
      onDismissed: (DismissDirection direction) {
        handleDelete(film.id);
      },
    );
  }
}
