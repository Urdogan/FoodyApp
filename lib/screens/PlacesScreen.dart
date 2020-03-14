import 'package:flutter/material.dart';
import 'package:foody/widgets/Categories.dart';
import 'package:foody/widgets/PlaceCard.dart';
import '../services/PlacesService.dart';
import '../models/categoryNotify.dart';
import '../widgets/Loading.dart';

class PlacesScreen extends StatefulWidget {
  static const routeName = "/placesScreen";

  //static String selectedCategory = "-LxJNnSmrJ4ngPM0lbWx";

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  PlacesService service;
  @override
  void initState() {
    service = PlacesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          height: 80,
          child: FutureBuilder(
              future: service.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Loading());
                } else {
                  return Categories(snapshot.data);
                }
              }),
        ),
        ValueListenableBuilder(
          valueListenable: categoryNotify,
          builder: (context, model, child) {
            return Container(
              height: 380,
              child: categoryNotify.value == null
                  ? Text("Lütfen Kategori Seçiniz")
                  : FutureBuilder(
                      future: service.getFoodIds(model.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Loading();
                        } else {
                          return PlaceCard(snapshot.data);
                        }
                      },
                    ),
            );
          },
        ),
      ],
    ));
  }
}
