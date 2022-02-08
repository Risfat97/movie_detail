import 'package:flutter/material.dart';
import 'package:movie_detail/detail_app.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: const Text('Movie Detail'),
          backgroundColor: Colors.black,
        ),
        body: const Center(
          child: SearchWidget(),
        ));
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  String _value = '';

  void setValue(String newValue) {
    setState(() {
      _value = newValue;
    });
  }

  Route _createPageRoute() {
    return PageRouteBuilder(
      settings: RouteSettings(arguments: DetailArguments(_value)),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const DetailWidget(),
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

  void _handleSubmit() {
    List<String> listval = _value.split(" ");
    listval = listval
        .map((element) =>
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}")
        .toList();
    setState(() {
      _value = listval.join("+");
    });
    Navigator.of(context).push(_createPageRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      color: Colors.white,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            onChanged: (String value) {
              setValue(value);
            },
            onSubmitted: (String value) {
              _handleSubmit();
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Titre du film",
                labelStyle: TextStyle(color: Colors.black38, fontSize: 14),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12))),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
                onPressed: _handleSubmit,
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
    );
  }
}

class DetailArguments {
  final String query;

  DetailArguments(this.query);
}
