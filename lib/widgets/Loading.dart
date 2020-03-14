import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 250, 250),
      child: Center(
        child: SpinKitCircle(
          color: Color.fromARGB(255, 182, 55, 12),
          size: 60,
        ),
      ),
    );
  }
}
