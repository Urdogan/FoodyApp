import 'dart:convert';

import 'package:foody/models/category.dart';
import 'package:foody/models/food.dart' as f;
import 'package:foody/models/placeFood.dart';
import 'package:foody/services/database.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../models/place.dart';
import 'auth.dart';

class PlacesService extends ChangeNotifier {
  AuthService _auth = AuthService();
  DatabaseService service = DatabaseService();
  static const firebaseComments =
      "https://flt-deneme.firebaseio.com/comments.json";

  static const firebasePlaces = "https://flt-deneme.firebaseio.com/places.json";
  static const firebaseCategories =
      "https://flt-deneme.firebaseio.com/categories.json";
  static const firebaseFood = "https://flt-deneme.firebaseio.com/foods.json";
  static const firebaseUser = "https://flt-deneme.firebaseio.com/users.json";
  static const googleAPI = "AIzaSyAiAT5afkZBrwKOd7qf9k39DIBak-6vG_o";
  static const firebaseSignin =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBXOkZo0q591PQmGSNQzzbuXHvZjKtY3PY";
  static const firebaseSignup =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBXOkZo0q591PQmGSNQzzbuXHvZjKtY3PY";

  List<Place> _placeList = [];
  List<Category> _categoryList = [];
  List<dynamic> _foodIdList = [];

  List<Place> get places {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._placeList];
  }

  List<String> get foodIdList {
    return [..._foodIdList];
  }

  List<Category> get categories {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._categoryList];
  }

  Future addComment(
      String foodId, String placeId, String comment, String rate) async {
    var user = await _auth.user.first;
    final response = await http.post(
      firebaseComments,
      body: json.encode({
        'comment': comment,
        'imageUrl': "https://picsum.photos/200",
        'date': DateTime.now().toIso8601String(),
        'rate': rate,
      }),
    );
    final jsonModel = json.decode(response.body) as Map<String, dynamic>;
    //Kullanıcı bilgisi çekiliyor ve aynı yoruma yükleniyor.
    var userMap = await service.fillUserInfoInComment(user.uId);
    if (userMap != null) {
      try {
        service.dbRef
            .child("comments")
            .child(jsonModel.values.first)
            .child("user")
            .set({
          "userId": user.uId,
          "name": userMap["name"],
          "lastname": userMap["lastname"],
          "UserImageUrl": userMap["imageUrl"]
        });
      } catch (e) {
        print(e.toString());
      }
    }
    var foodName=await service.fillFoodInfoInComment(foodId);
    try {
      service.dbRef.child("comments").child(jsonModel.values.first).child("food").set({
        "foodId":foodId,
        "foodName":foodName
      });
    } catch (e) {
      print(e.toString());
    }

    var placeMap= await service.fillPlaceInfoInComment(placeId);
    try {
      service.dbRef.child("comments").child(jsonModel.values.first).child("place").set({
        "placeId":placeId,
        "placeTitle":placeMap["title"],
        "placeImageUrl":placeMap["imageUrl"]
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getFoodIds(String categoryId) async {
    List<Place> tempList = [];
    List<PlaceFood> gosterilecekYemekler = [];
    List<dynamic> kategori = [];
    final response = await http.get(firebaseFood);
    try {
      _foodIdList = [];
      final jsonModel = json.decode(response.body) as Map<String, dynamic>;
      jsonModel.forEach((k, v) {
        kategori = v['category'];
        if (kategori.contains(categoryId)) {
          _foodIdList.add(k);
        }
      });
    } catch (e) {
      Future.error(e);
    }

    tempList = await getPlaces();
    tempList.forEach((place) {
      place.menu.forEach((k,v){
        PlaceFood food= PlaceFood();
        if(foodIdList.contains(k)){
          food.foodId =k;
          food.foodRating = v['foodRat'];
          food.foodName=v["foodName"];
          food.placeId = place.id;
          food.placeTitle=place.title;
          gosterilecekYemekler.add(food);
        }
      }); 
    });
    return gosterilecekYemekler;
  }

  Future getPlaces() async {
    final response = await http.get(firebasePlaces);
    try {
      _placeList = [];
      final jsonModel = json.decode(response.body) as Map<String, dynamic>;
      jsonModel.forEach((k, v) {
        Place place = Place();
        place.id = k;
        place.title = v['title'];
        place.lat = v['lat'];
        place.lng = v['lng'];
        place.imageUrl = v['imageUrl'];
        place.menu = v['menu'];
        _placeList.add(place);
      });
      return places;
    } catch (e) {
      Future.error(response.statusCode);
    }
  }

  Future addPlace(Place place) async {
    try {
      await http.post(
        firebasePlaces,
        body: json.encode({
          'title': place.title,
          'imageUrl': place.imageUrl,
          'lat': place.lat,
          'lng': place.lng,
          'menu': place.menu
        }),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future getCategories() async {
    final response = await http.get(firebaseCategories);
    try {
      _categoryList = [];
      final jsonModel = json.decode(response.body) as Map<String, dynamic>;
      jsonModel.forEach((k, v) {
        final Category newCategory = Category();
        newCategory.catId = k;
        newCategory.catName = v['catName'];
        _categoryList.add(newCategory);
      });
      return categories;
    } catch (e) {
      Future.error(response.statusCode);
    }
  }

  List<f.Food> allFoods = [];
  Future getFoods() async {
    final response = await http.get(firebaseFood);
    List<dynamic> category = [];
    try {
      allFoods = [];
      final jsonModel = json.decode(response.body) as Map<String, dynamic>;
      jsonModel.forEach((k, v) {
        final f.Food newFood = f.Food();
        newFood.id = k;
        newFood.title = v['title'];
        category = v['category'];
        newFood.category = [];
        for (var i = 0; i < category.length; i++) {
          newFood.category.add(category[i].toString());
        }

        allFoods.add(newFood);
      });
      return allFoods;
    } catch (e) {
      Future.error(e);
    }
  }

  Future addCategory(String catName) async {
    await http.post(firebaseCategories,
        body: json.encode({'catName': catName}));
  }

  Future addFood(f.Food food) async {
    await http.post(firebaseFood,
        body: json.encode({'title': food.title, 'category': food.category}));
  }

  Future<Place> findById(String id) async {
    Place pl = Place();
    final response = await http.get(firebasePlaces);
    try {
      final jsonModel = json.decode(response.body) as Map<String, dynamic>;
      jsonModel.forEach((k, v) {
        Place place = Place();
        place.id = k;
        place.title = v['title'];
        place.lat = v['latitude'];
        place.lng = v['longitude'];
        place.imageUrl = v['imageUrl'];
        place.menu = v['menu'];
        _placeList.add(place);
        if (k == id) {
          pl = place;
        }
      });
    } catch (e) {
      Future.error(response.statusCode);
    }
    return pl;
  }
}
