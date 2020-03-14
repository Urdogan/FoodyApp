import 'package:flutter/material.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:foody/services/auth.dart';
import '../services/database.dart';

import 'HomeScreen.dart';
import 'LocationScreen.dart';
import 'PlacesScreen.dart';
import 'UserProfileScreen.dart';

class NavigationScreen extends StatefulWidget {
  static const routeName = "/navigationMain";
  DatabaseService dbService= DatabaseService();
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  AuthService _auth = AuthService();
  DatabaseService dbService = DatabaseService();
  PlacesService services = PlacesService();
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = ModalRoute.of(context).settings.arguments as SuccesLogin;
    final List<Widget> _children = [
      HomeScreen(),
      PlacesScreen(),
      LocationScreen(),
      UserProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 250, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: null,
          ),
          elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await _auth.signOut();
                }),
          ],
          iconTheme: IconThemeData(color: Color.fromARGB(255, 182, 55, 12)),
          title: Text(
            "FOODY",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                letterSpacing: 4,
                color: Color.fromARGB(255, 182, 55, 12)),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 182, 55, 12),
            ),
            title: Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.w400,letterSpacing: 2, color: Color.fromARGB(255, 182, 55, 12)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_numbered,
                color: Color.fromARGB(255, 182, 55, 12)),
            title: Text('En İyisi',
                style: TextStyle(fontWeight: FontWeight.w400,letterSpacing: 2, color: Color.fromARGB(255, 182, 55, 12)),),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
              color: Color.fromARGB(255, 182, 55, 12),
            ),
            title: Text('Konum',
                style: TextStyle(fontWeight: FontWeight.w400,letterSpacing: 2, color: Color.fromARGB(255, 182, 55, 12)),),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color.fromARGB(255, 182, 55, 12),
            ),
            title: Text("Profil",
                style: TextStyle(fontWeight: FontWeight.w400,letterSpacing: 2, color: Color.fromARGB(255, 182, 55, 12)),),
          )
        ],
      ),
    );
  }
}
