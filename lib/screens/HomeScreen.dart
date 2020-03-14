import 'package:flutter/material.dart';
import 'package:foody/services/database.dart';
import 'package:foody/widgets/Loading.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseService dbService = DatabaseService();
  List<bool> isLiked = List<bool>(50);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: dbService.dbRef.child("comments").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              var snapshot = snap.data.snapshot;
              var item = [];
              Map<dynamic, dynamic> _list = snapshot.value;
              _list.forEach((k, f) {
                if (f != null) {
                  item.add(f);
                }
              });
              return snap.data.snapshot.value == null
                  ? SizedBox()
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 110,
                          child: Card(
                            margin: EdgeInsets.all(1),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  trailing: isLiked[index] == false
                                      ? IconButton(
                                          icon: Icon(Icons.favorite_border),
                                          color: Colors.red,
                                          onPressed: () {
                                            setState(() {
                                              isLiked[index] = true;
                                            });
                                          })
                                      : IconButton(
                                          icon: Icon(Icons.favorite),
                                          color: Colors.red,
                                          onPressed: () {
                                            setState(() {
                                              isLiked[index] = false;
                                            });
                                          },
                                        ),
                                  title: Text(
                                    item[index]["user"]["name"] +
                                        " " +
                                        item[index]["user"]["lastname"],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: ListTile(
                                    title: Text(
                                      item[index]['food']['foodName'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      item[index]['place']['placeTitle'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Container(
                                        width: 50,
                                        child: Text(item[index]["rate"])),
                                  ),
                                  leading: Container(
                                      width: 50,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            item[index]['imageUrl']),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            } else {
              return Center(child: Loading());
            }
          }),
    );
  }
}
