import 'package:flutter/material.dart';
import 'package:movie_detail/tab_navigator.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation(
      {required this.currentTab, required this.onSelectTab, Key? key})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentTab.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 92,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedIconTheme: const IconThemeData(color: Colors.amberAccent),
          selectedItemColor: Colors.amberAccent,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: <BottomNavigationBarItem>[
            _buildNavigationItem(Icons.home, Colors.white, "Accueil"),
            _buildNavigationItem(Icons.search, Colors.white, "Recherche"),
            _buildNavigationItem(Icons.favorite_border, Colors.white, "Favoris")
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            widget.onSelectTab(TabItem.values[_currentIndex]);
          },
        ));
  }

  BottomNavigationBarItem _buildNavigationItem(
      IconData iconData, Color color, String label) {
    return BottomNavigationBarItem(
        icon: Icon(iconData, color: color), label: label);
  }
}
