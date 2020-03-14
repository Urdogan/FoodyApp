import 'package:flutter/material.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/categoryNotify.dart';

class Categories extends StatelessWidget {
  final List<Category> list;
  Categories(this.list);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      children: List.generate(
        list.length,
        (index) {
          return GestureDetector(
            onTap: () {
              categoryNotify.changeCategory(list[index].catId);
            },
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(3),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.fastfood,
                      size: 20,
                      color: Color.fromARGB(255, 182, 55, 12),
                    ),
                    onPressed: null
                  ),
                  Text(
                    list[index].catName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
