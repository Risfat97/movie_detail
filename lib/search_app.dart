import 'package:flutter/material.dart';
import 'package:movie_detail/results_search.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Route _createPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ResultSearch(query: _controller.text),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void _handleSubmit(String value) {
    List<String> listval = value.split(" ");
    listval = listval
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .toList();
    value = listval.join("+");
    Navigator.of(context).push(_createPageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.black87,
            appBar: AppBar(
              title: const Text('Recherche'),
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
            ),
            body: Container(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              color: Colors.white,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    onSubmitted: (String value) {
                      _handleSubmit(value);
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Titre du film",
                        labelStyle:
                            TextStyle(color: Colors.black38, fontSize: 14),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12))),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _handleSubmit(_controller.text);
                        },
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
                            primary: Colors.black87),
                        child: const Text(
                          "Rechercher",
                        )),
                  )
                ],
              )),
            )));
  }
}
