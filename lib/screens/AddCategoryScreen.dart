import 'package:flutter/material.dart';
import 'package:foody/services/PlacesService.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController catController = TextEditingController();
  PlacesService service = PlacesService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text("Kategori Ekleme Sayfası"),
            Form(
              child: _userInput("kategori Ekle", catController),
            ),
            FlatButton(
              onPressed: () {
                service.addCategory(catController.text);
              },
              child: Text("Ekle"),
            )
          ],
        ),
      ),
    );
  }

  Widget _userInput(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return 'Bu alan Boş Bırakılamaz';
        }
        return null;
      },
    );
  }
}
