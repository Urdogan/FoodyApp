import 'package:flutter/material.dart';
import 'package:foody/services/PlacesService.dart';

class AddComment extends StatefulWidget {
  final String foodId;
  final String placeId;
  AddComment({this.foodId, this.placeId});
  @override
  _AddCommentState createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  double rating = 7.0;
  PlacesService service = PlacesService();
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text("Puan"),
            Slider(
              onChanged: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
              value: rating,
              label: rating.toStringAsFixed(1),
              divisions: 100,
              max: 10,
              min: 0,
              activeColor: rating > 7
                  ? Colors.green[400]
                  : (rating > 5 ? Colors.orange[200] : Colors.red[400]),
            ),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                  labelText: "Yorum(isteğe bağlı)",
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder()),
            ),
            RaisedButton(
                onPressed: () {
                  service.addComment(widget.foodId, widget.placeId,
                      commentController.text, rating.toStringAsFixed(1));
                  Navigator.of(context).pop();
                },
                child: Text("Yorumu Gönder"),
                color: rating > 7
                    ? Colors.green[400]
                    : (rating > 5 ? Colors.orange[200] : Colors.red[400]))
          ],
        ),
      ),
    );
  }
}
