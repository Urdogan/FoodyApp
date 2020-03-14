import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/food.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  List<Category> categories;
  PlacesService service = PlacesService();
  List<String> _checked = [];
  List<String> categoriesNameList = [];
  List<String> categoriesIdList = [];

  Food food = Food();

  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      service.getCategories().then((value) {
        categories = value;
        for (var i = 0; i < categories.length; i++) {
          setState(() {
            categoriesNameList.add(categories[i].catName);
            categoriesIdList.add(categories[i].catId);
          });
        }
      });
    });
  }

  TextEditingController yemekController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Column(children: <Widget>[
        Form(
          child: Column(children: <Widget>[
            Container(
                width: 300, child: _userInput("Yemek Adı", yemekController)),
          ]),
        ),
        CheckboxGroup(
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          margin: const EdgeInsets.only(left: 12.0),
          onSelected: (List selected) => setState(() {
            _checked = selected;
          }),
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 1,
          ),
          labels: categoriesIdList,
          checked: _checked,
          itemBuilder: (Checkbox cb, Text txt, int i) {
            return Column(
              children: <Widget>[cb, txt, Text(categoriesNameList[i])],
            );
          },
        ),
        FlatButton(
          child: Text("Yemek Ekle"),
          onPressed: () {
            food.title = yemekController.text;

            food.category = [..._checked];

            //  food.categories[0].catId

            service.addFood(food);
          },
        ),
      ]),
    ));
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
