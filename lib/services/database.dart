import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:foody/models/comment.dart';
import 'package:foody/models/user.dart';

class DatabaseService {
  final dbRef = FirebaseDatabase.instance.reference();

  //Kayıt ekranından sonra isim soyisim al bu metoda gönder.
  void createUserProfile(String uid) {
    dbRef.child("users").child(uid).set({
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/flt-deneme.appspot.com/o/placesProfilePics%2FIMG-20191221-WA0000.jpg?alt=media&token=57f0238a-36e7-47cc-86a6-570fb8722baf",
      "following": ["weXlKAuAOefkgGYR2FgMQqyKzCd2", "-LxIsyx5Q_ChoSuVQYvx"],
      "followers": ["weXlKAuAOefkgGYR2FgMQqyKzCd2", "-LxIsyx5Q_ChoSuVQYvx"],
      "lastname": " ",
      "name": " ",
      "comments": ["commentId", "commentId"]
    });
  }

  List<Comment> userComments = List<Comment>();
  Future getUserComments(String uid) async {
    var result = await dbRef.child("comments").once();
    for (var i in result.value) {
      if (i.value["userId"] == uid) {
        Comment comment = Comment();
        comment.id = i.key;
        comment.rate = i.value["rating"];
        comment.comment = i.value["comment"];
        userComments.add(comment);
      }
    }
    return userComments;
  }

  //denenmedi
  Future addComment(Comment comment) async {
    var commentId = dbRef.child("comments").push();
    await dbRef.child("comments").child(commentId.key).set({
      "comment": comment.comment,
      "date": DateTime.now().toString(),
      "rate": comment.rate,
      "userId": comment.userId,
      "imageUrl": comment.imageUrl,
      "foodId": comment.foodId,
      "placeId": comment.placeId
    });
  }

  //Gelen id ile kullanıcı bilgisi dönüyor.
  fillUserInfoInComment(String uid) async {
    var userMap = {"name": "", "lastname": "", "imageUrl": ""};
    try {
      await dbRef.child("users/$uid").once().then((DataSnapshot snapshot) {
        userMap["name"] = snapshot.value["name"];
        userMap["lastname"] = snapshot.value["lastname"];
        userMap["imageUrl"] = snapshot.value["imageUrl"];
      });
      return userMap;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //id ile yemek adı çekiyor
  fillFoodInfoInComment(String foodId) async {
    var foodName;
    try {
      await dbRef.child("foods/$foodId").once().then((DataSnapshot snapshot) {
        foodName = snapshot.value["title"];
      });
      return foodName;
    } catch (e) {
      e.toString();
    }
  }

  fillPlaceInfoInComment(String placeId) async {
    var placeMap = {"title": "", "imageUrl": ""};
    try {
      await dbRef.child("places/$placeId").once().then((DataSnapshot snapshot) {
        placeMap["title"] = snapshot.value["title"];
        placeMap["imageUrl"] = snapshot.value["imageUrl"];
      });
      return placeMap;
    } catch (e) {}
  }

  //Firebaseden veri çekme
  User getUser(String uid) {
    User user = User();
    dbRef.child("users/$uid").once().then((DataSnapshot snapshot) {
      user.name=snapshot.value["name"];
    });
    return user;
  }

  //Kullanıcının adını soyadını girdiği ekranın metodu
  //Genişleticelek..
  Future updateUserInfo(User user) async {
    if (user != null) {
      await dbRef.child("users").child(user.uId).set({
        "name": user.name,
        "lastname": user.lastname,
      });
    }
  }

  List<Comment> _userFromFirebaseUser() {
    dbRef.once().then((DataSnapshot dataSnapshot) {
      var comments = dataSnapshot as Map<String, dynamic>;
      comments.forEach((k, v) {
        Comment comment = Comment();
        comment.id = k;
        comment.comment = v["comment"];
        comment.foodId = v["foodId"];
        comment.imageUrl = v["foodId"];
        comment.placeId = v["placeId"];
        comment.rate = v["rate"];
        comment.userId = v["userId"];
        comment.date = v["date"];
      });
    });

    // return comments != [] ? comments : null;
  }
}
