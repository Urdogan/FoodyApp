import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:foody/models/user.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:foody/services/auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  PlacesService service = PlacesService();
  AuthService _auth = AuthService();


  Duration get loginTime => Duration(milliseconds: 2250);
  Future<String> _authUser(LoginData data) {
    return _auth.signInEmail(data).then((response) {
      if (response != null) {
        return null;
      } else {
        return "Giriş Yapılamadı";
      }
    });
  }

  Future<String> _signup(LoginData data) {
    return _auth.signUpEmail(data).then((response) {
      if (response != null) {
        return null;
      } else {
        return "Kullanıcı oluşturulamadı";
      }
    });
  }

  //Auth kısmına eklenecek
  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!users.containsKey(name)) {
      //   return 'Username not exists';
      // }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'FOODY',
      theme: LoginTheme(
       
        buttonStyle: TextStyle(color: Colors.white),
        textFieldStyle: TextStyle(color: Color.fromARGB(255, 182, 55, 12)),
          primaryColor: Color.fromARGB(255, 255, 250, 250),
          cardTheme: CardTheme(
              color: Color.fromARGB(255, 255, 250, 250), elevation: 55),
          bodyStyle: TextStyle(color: Color.fromARGB(255, 182, 55, 12)),
          accentColor: Color.fromARGB(255, 182, 55, 12),
          buttonTheme: LoginButtonTheme(
              backgroundColor: Color.fromARGB(255, 182, 55, 12)),

          titleStyle: TextStyle(
              color: Color.fromARGB(255, 182, 55, 12),
              fontWeight: FontWeight.w400)),
      messages: LoginMessages(loginButton: 'GİRİŞ', signupButton: 'KAYIT'),
      onLogin: _authUser,
      onSignup: _signup,
      onSubmitAnimationCompleted: () {
         
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
