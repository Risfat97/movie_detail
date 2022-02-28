import 'package:flutter/material.dart';
import 'package:movie_detail/services/favorite_service.dart';
import 'package:movie_detail/film_app.dart';
import 'package:movie_detail/film_from_database.dart';

typedef DeleteCallback = Function(Film film);

class ListFavorite extends StatefulWidget {
  const ListFavorite({Key? key}) : super(key: key);

  @override
  State<ListFavorite> createState() => _ListFavoriteState();
}

class _ListFavoriteState extends State<ListFavorite> {
  late FavoriteService _favoriteService;

  @override
  void initState() {
    super.initState();
    _favoriteService = FavoriteService.getInstance();
  }

  @override
  void dispose() {
    _favoriteService.dispose();
    super.dispose();
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
            body: _buildStreamBuilder()));
  }

  StreamBuilder<List<Film>> _buildStreamBuilder() {
    return StreamBuilder(
        stream: _favoriteService.favorites,
        builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = [
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
            ];
          } else {
            int i = 0;
            final colors = [Colors.white, Colors.grey.shade200];
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                children = [
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
                ];
                break;
              case ConnectionState.waiting:
                children = <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.orange,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  )
                ];
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data!.isEmpty) {
                  children = [
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
                  ];
                } else {
                  children = snapshot.data!
                      .map((e) => FavoriteWidget(
                          film: e,
                          color: colors[(i++) % 2],
                          handleDelete: _favoriteService.handleDeleteFavorite,
                          key: Key('${e.id}')))
                      .toList();
                }
                break;
            }
          }
          return ListView(children: children);
        });
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
            handleDelete(film);
          },
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FilmFromDatabase(
                        id: film.id,
                      )));
        },
        tileColor: color,
      ),
      onDismissed: (DismissDirection direction) {
        handleDelete(film);
      },
    );
  }
}
