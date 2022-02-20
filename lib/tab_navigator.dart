import 'package:flutter/material.dart';
import 'package:movie_detail/favorites_app.dart';
import 'package:movie_detail/home_app.dart';
import 'package:movie_detail/search_app.dart';

enum TabItem { home, search, favorite }

class TabNavigatorRoutes {
  static const String root = '/';
  static const String search = '/search';
  static const String favorite = '/favorite';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({required this.initialRoute, this.navigatorKey, Key? key})
      : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final String initialRoute;
  /*
  void _push(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                routeBuilders[TabNavigatorRoutes.detail]!(context)));
  }
  */
  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => const HomeWidget(),
      TabNavigatorRoutes.search: (context) => const SearchWidget(),
      TabNavigatorRoutes.favorite: (context) => const ListFavorite(),
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: initialRoute,
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name]!(context));
        });
  }
}
