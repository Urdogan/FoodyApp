import 'package:flutter/material.dart';
import 'package:foody/models/food.dart';
import 'package:foody/models/place.dart';
import 'package:foody/services/PlacesService.dart';

final categoryNotify = AppNotify();
final service = PlacesService();

class AppNotify extends ValueNotifier<String> {
  AppNotify({String value}) : super(value);
  List<Place> placeList = [];
  List<Food> foodList = [];
  void changeCategory(String newCategory) {
    value = newCategory;
    fillNameIdList();
    notifyListeners();
  }

  Future<void> fillNameIdList() async {
    placeList = await service.getPlaces();
    foodList = await service.getFoods();
    notifyListeners();
  }
}
