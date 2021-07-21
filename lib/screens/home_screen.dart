import 'package:flutter/material.dart';
import 'package:nusnav/models/public_favorite_storage.dart';
import 'package:nusnav/screens/bus_stop_list_page.dart';
import 'package:nusnav/screens/explore_page.dart';
import 'package:nusnav/screens/favorites_page.dart';
import 'package:nusnav/models/nus_favorite_storage.dart';

import 'bus_stop_route_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _pages = [
    ExplorePage(),
    FavoritesPage(
      nusStorage: NUSFavoriteStorage(),
      publicStorage: PublicFavoriteStorage(),
    ),
    BusStopListPage(
      nusStorage: NUSFavoriteStorage(),
      publicStorage: PublicFavoriteStorage(),
    ),
    BusStopRoutePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bus_alert),
            label: 'Bus Stops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Routes',
          ),
        ],
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
