import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/services/PlacesService.dart';

class ChipList extends StatefulWidget {
  @override
  _ChipListState createState() => _ChipListState();
}

class _ChipListState extends State<ChipList> {
  List<Category> categoryList = [];
  PlacesService service = PlacesService();
  var selected = [];

  List<FilterChip> _chips(List<Category> list) {
    return List.generate(list.length, (index) {
      return FilterChip(
        label: Text(categoryList[index].catName),
        onSelected: (bool value) {
          setState(() {
            if (selected.contains(categoryList[index].catId)) {
              selected.remove(categoryList[index].catId);
            } else {
              selected.add(categoryList[index].catId);
            }
          });
        },
        selected: selected.contains(categoryList[index].catId),
        selectedColor: Colors.green,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      );
    }).toList();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      service.getCategories().then((value) {
        setState(() {
          categoryList = value;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: <Widget>[..._chips(categoryList)],
        ));
  }
}
