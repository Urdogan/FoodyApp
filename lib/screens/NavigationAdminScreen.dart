import 'package:flutter/material.dart';
import 'package:foody/screens/AddPlaceScreen.dart';

import 'AddCategoryScreen.dart';
import 'AddFoodScreen.dart';

class NavigationAdminScreen extends StatefulWidget {
    static const routeName = "/navigationAdmin";
  @override
  _NavigationAdminScreenState createState() => _NavigationAdminScreenState();
}

class _NavigationAdminScreenState extends State<NavigationAdminScreen> {
  
  int _currentIndex = 0;
  final List<Widget> _screens = [
    AddPlaceScreen(),
    AddFoodScreen(),
    AddCategoryScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ekleme Sayfaları"),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.place), title: Text("Mekan ekle")),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood), title: Text("Yemek ekle")),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text("Kategori ekle"))
        ],
      ),
    );
  }
}
