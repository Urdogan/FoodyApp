import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/AddPlaceScreen.dart';
import 'package:foody/screens/GetUserInfoScreen.dart';
import 'package:foody/screens/LoginScreen.dart';
import 'package:foody/screens/NavigationAdminScreen.dart';
import 'package:foody/screens/NavigationScreen.dart';
import 'package:foody/screens/PlaceDetailScreen.dart';
import 'package:foody/screens/PlacesScreen.dart';
import 'package:foody/services/database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseService dbService = DatabaseService();
    final user = Provider.of<User>(context);
    return MaterialApp(
        title: 'Foody',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: user == null //kullanıcı auth değilse login'e
             ? LoginScreen():NavigationScreen(),
            // : (userMap["name"] == " " //burda servis çapırıp kullanıcı adı var mı yok mu kontrol etmek gerek
            //     ? GetUserInfoScreen()
            //     : NavigationScreen()), //InitialRoute tanımlanırsa Home tanımlanmaz.
        routes: {
          GetUserInfoScreen.routeName: (context) => GetUserInfoScreen(),
          PlacesScreen.routeName: (context) => PlacesScreen(),
          AddPlaceScreen.routeName: (context) => AddPlaceScreen(),
          PlaceDetailScreen.routeName: (context) => PlaceDetailScreen(),
          NavigationScreen.routeName: (context) => NavigationScreen(),
          NavigationAdminScreen.routeName: (context) => NavigationAdminScreen(),
        });
  }
}
