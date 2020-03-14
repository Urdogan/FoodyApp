import 'package:flutter/material.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:foody/widgets/chip_list.dart';

class FilterLocation extends StatefulWidget {
  @override
  _FilterLocationState createState() => _FilterLocationState();
}

class _FilterLocationState extends State<FilterLocation> {
  double distance = 5.0;
  PlacesService service = PlacesService();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: 300,
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Wrap(
              children: <Widget>[
                ChipList(),
              ],
            ),
            Text("Mesafe"),
            Slider(
              onChanged: (newDistance) {
                setState(() {
                  distance = newDistance;
                });
              },
              value: distance,
              label: distance.toStringAsFixed(1),
              divisions: 150,
              max: 15,
              min: 0,
              activeColor: Colors.black,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Filtrele"),
            )
          ],
        ),
      ),
    );
  }
}
