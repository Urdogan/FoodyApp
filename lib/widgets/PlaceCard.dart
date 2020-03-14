import 'package:flutter/material.dart';
import 'package:foody/models/categoryNotify.dart';
import 'package:foody/models/placeFood.dart';
import 'package:foody/screens/PlaceDetailScreen.dart';
import 'package:foody/services/PlacesService.dart';

class PlaceCard extends StatefulWidget {
  final List<PlaceFood> foods;

  PlaceCard(this.foods);

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  PlacesService service = PlacesService();
  AppNotify provider = AppNotify();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.foods.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(PlaceDetailScreen.routeName,
                arguments: widget.foods[index].placeId);
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(5),
            child: ListTile(
              leading: Container(
                  width: 50,
                  alignment: Alignment.center,
                  child: Image.network("https://picsum.photos/200")),
              title: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween
                  ,
                  children: <Widget>[
                    Text(widget.foods[index].foodName),
                    SizedBox(
                      width: 20,
                    ),

                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: double.parse(
                                            widget.foods[index].foodRating) <
                                        7
                                    ? Colors.red
                                    : Colors.green,
                                width: 3)),
                        padding: EdgeInsets.all(10),
                        child: Text(widget.foods[index].foodRating)),
                  ],
                ),
              ),
              subtitle: Text(widget.foods[index].placeTitle),
            ),
          ),
        );
      },
    );
  }
}
