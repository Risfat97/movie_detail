import 'package:movie_detail/bottom_navigation.dart';
import 'package:movie_detail/tab_navigator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: 'Movie Detail', home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TabItem _currentTab = TabItem.home;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.favorite: GlobalKey<NavigatorState>()
  };

  void _onSelectTab(TabItem item) {
    setState(() {
      _currentTab = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(TabItem.home, TabNavigatorRoutes.root),
              _buildOffstageNavigator(
                  TabItem.search, TabNavigatorRoutes.search),
              _buildOffstageNavigator(
                  TabItem.favorite, TabNavigatorRoutes.favorite)
            ],
          ),
          bottomNavigationBar: BottomNavigation(
              currentTab: _currentTab, onSelectTab: _onSelectTab),
        ),
        onWillPop: () async =>
            !await navigatorKeys[_currentTab]!.currentState!.maybePop());
  }

  Offstage _buildOffstageNavigator(TabItem item, String initialRoute) {
    return Offstage(
      offstage: _currentTab != item,
      child: TabNavigator(
          navigatorKey: navigatorKeys[item], initialRoute: initialRoute),
    );
  }
}
