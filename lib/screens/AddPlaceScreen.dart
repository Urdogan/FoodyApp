import 'dart:io';

import 'package:foody/models/PlaceLocation.dart';
import 'package:foody/models/category.dart';
import 'package:foody/models/place.dart';
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../services/PlacesService.dart';
import 'LocationInput.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/addPlaceScreen";

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  String fileType = "";
  File file;
  String fileName = "";
  String operationText = "";
  bool isUploaded = true;
  String result = "";
  String imageUrl = "";
  final dBRef = FirebaseDatabase.instance.reference();
  List<Category> categories;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      service.getCategories().then((value) {
        categories = value;
      });
    });
  }

  PlaceLocation _pickedLocation;
  TextEditingController titleController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey(debugLabel: "formKey");
  PlacesService service = PlacesService();
  Place place = Place();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Form(
            autovalidate: true,
            key: formKey, //textinput action eklencek
            child: Column(
              children: <Widget>[
                _userInput("Mekan Adı", titleController),
                // _userInput("latitude", latController),
                // _userInput("longitude", lngController),
                LocationInput(_selectPlace)
                //showPickerNumber(context),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Fotoğraf Seç',
              style: TextStyle(color: Colors.blue),
            ),
            leading: Icon(
              Icons.image,
              color: Colors.blue,
            ),
            onTap: () {
              setState(() {
                fileType = 'image';
              });
              filePicker(context);
            },
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            onPressed: () {
              writeData();
              place.lat = _pickedLocation.latitude.toString();
              place.lng = _pickedLocation.longitude.toString();
              place.title = titleController.text;
              place.imageUrl = imageUrl;
              service.addPlace(place);
            },
          ),
        ],
      ),
    );
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
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

  Future filePicker(BuildContext context) async {
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.IMAGE);
        setState(() {
          fileName = p.basename(file.path);
        });
        print(fileName);
        _uploadFile(file, fileName);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Bir şeyler ters gitti"),
              content: Text("bişiler"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  } //filePicker

  Future<void> _uploadFile(File file, String fileName) async {
    StorageReference storageReference;
    //FirebaseApp.initializeApp(context);
    if (fileType == 'image') {
      storageReference =
          FirebaseStorage.instance.ref().child("placesProfilePics/$fileName");
    }
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    imageUrl = (await downloadUrl.ref.getDownloadURL());
    print(" URL is $imageUrl");
  }

  void writeData() {
    // dBRef.child("places").set({
    //   'title': 'Benjamin Kafee  ',
    //   'adress': 'asdasd',
    //   'latitude': '123123',
    //   'longitude': '23132',
    //   'imgUrl': 'www.asdasd.com',
    //   'menu': {'foodId': '2132312', 'foodRating': '8.4'}
    // });

    print(categories[0].catName);
    // dBRef.once().then((DataSnapshot dataSnapshot) {
    //   print(dataSnapshot.value);
    // });

    // dBRef.child("path").update({
    //   "data":"updated"
    // });

    // dBRef.child("path").remove();
  }
}
