import 'package:flutter/material.dart';
import 'package:foody/models/place.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:foody/widgets/location_filter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as locationManager;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  var location = new locationManager.Location();
  Map<String, double> currentLocation;
  geo.Geolocator geolocator = geo.Geolocator();
  static geo.Position userLocation;
  double zoomVal = 5.0;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;
  static const googleApiKey = "AIzaSyAiAT5afkZBrwKOd7qf9k39DIBak-6vG_o";
  PlacesService service = PlacesService();

  @override
  void initState() {
    super.initState();
    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });
  }

  Future<geo.Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }


   void _addFilter (ctx) {
    showModalBottomSheet<List<String>>(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: FilterLocation(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 600,
        width: double.infinity,
        child: userLocation == null
            ? Center(
                child: Column(
                children: <Widget>[
                  Text("Harita Yükleniyor"),
                  CircularProgressIndicator()
                ],
              ))
            : Stack(
                children: <Widget>[
                  _buildGoogleMap(context),
                  Align(alignment: Alignment.topRight, child: IconButton(onPressed: (){
                    _addFilter(context);
                  }, icon: Icon(FontAwesomeIcons.filter,color: Colors.amber,))),
                  FutureBuilder(
                    future: service.getPlaces(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.black)));
                      } else {
                        return _buildContainer(snapshot.data);
                      }
                    },
                  ),
                ],
              ));
  }

  Future<void> _minus(double zoomVal) async {//mekana gitmek için kullanılcak
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(37.7452282, 29.0936833), zoom: zoomVal)));
  }


  Widget _buildContainer(List<Place> places) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 110.0,
          child: ListView.builder(
            itemCount: places.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: _boxes(places[index].imageUrl, places[index].lat,
                          places[index].lng, places[index].title))
                ],
              );
            },
          )
          ),
    );
  }

  Widget _boxes(String _image, String lat, String long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat as double, long as double);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    // geolocator.distanceBetween(userLocation.latitude,userLocation.longitude, lat, long).then((onValue){
    // var distance=onValue;
    // });
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Color.fromARGB(255, 182, 55, 12),
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 3.0),
        Container(
            child: Text(
          "Yemek adı",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        )),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(
                "4.1",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.0,
                ),
              )),
              Container(
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12.0,
                ),
              ),
              Container(
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12.0,
                ),
              ),
              Container(
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12.0,
                ),
              ),
              Container(
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12.0,
                ),
              ),
              Container(
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 12.0,
                ),
              ),
              Container(
                child: Text(
                  "(946)",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    Marker yourLocation = Marker(
      markerId: MarkerId('yourLocation'),
      position: LatLng(userLocation.latitude, userLocation.longitude),
      infoWindow: InfoWindow(title: 'Nazım U.'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        compassEnabled: false,
        trafficEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(37.7452282, 29.0936833), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          benjaminMarker,
          yourLocation,
        },
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;

    _getLocation().then((value) {
      setState(() {
        userLocation = value;
      });
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 18,
      tilt: 50.0,
      bearing: 220.0,
    )));
  }

  Marker benjaminMarker = Marker(
    markerId: MarkerId('Benjamin Kafe'),
    position: LatLng(37.7452282, 29.0936833),
    infoWindow: InfoWindow(title: 'Benjamin Kafe'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueOrange,
    ),
  );
}
