import 'package:flutter/material.dart';
import 'package:nusnav/models/public_favorite_storage.dart';
import 'package:nusnav/screens/bus_stop_list.dart';
import 'package:nusnav/screens/explore.dart';
import 'package:nusnav/screens/favorites.dart';
import 'package:nusnav/models/nus_favorite_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _pages = [
    Explore(),
    Favorites(
      nusStorage: NUSFavoriteStorage(),
      publicStorage: PublicFavoriteStorage(),
    ),
    BusStopList(
      nusStorage: NUSFavoriteStorage(),
      publicStorage: PublicFavoriteStorage(),
    )
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
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
