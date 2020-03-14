import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/screens/NavigationScreen.dart';
import 'package:foody/services/database.dart';
import 'package:provider/provider.dart';

class GetUserInfoScreen extends StatefulWidget {
  static const routeName = "/getUserInfo";

  @override
  _GetUserInfoScreenState createState() => _GetUserInfoScreenState();
}

class _GetUserInfoScreenState extends State<GetUserInfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  DatabaseService dbService= DatabaseService();

  @override
  void dispose() {
    nameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
              elevation: 55,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "İsim",
                    fillColor: Color.fromARGB(255, 182, 55, 12)),
              )),
          Card(
            elevation: 55,
            child: TextField(
              controller: lastnameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Soyisim"),
            ),
          ),
          FlatButton(
            color: Colors.amberAccent,
            child: Text("Devam"),
            onPressed: () {
              user.name = nameController.text;
              user.lastname = lastnameController.text;
              dbService.updateUserInfo(user);
              Navigator.of(context).pushNamed(NavigationScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
