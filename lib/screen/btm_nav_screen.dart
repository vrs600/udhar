import 'package:flutter/material.dart';
import 'package:udhar/screen/home_screen.dart';
import 'package:udhar/screen/search_screen.dart';
import 'package:udhar/screen/settings_screen.dart';

class BtmNavScreen extends StatefulWidget {
  const BtmNavScreen({Key? key}) : super(key: key);

  @override
  State<BtmNavScreen> createState() => _BtmNavScreenState();
}

class _BtmNavScreenState extends State<BtmNavScreen> {
  int _selectedIndex = 0;

  final List _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            tooltip: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
            tooltip: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
            tooltip: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<bool?> showWarning(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("EXIT APP"),
          content: const Text("Are you sure that you want to close the app?"),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("EXIT"),
            ),
          ],
        );
      },
    );
  }
}
