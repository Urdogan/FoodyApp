import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/services/auth.dart';
import 'package:provider/provider.dart';

import 'screens/Wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Foody',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 182, 55, 12),
          accentColor: Color.fromARGB(255, 182, 55, 12),
        ),
        home: Wrapper(),
      ),
    );
  }
}
