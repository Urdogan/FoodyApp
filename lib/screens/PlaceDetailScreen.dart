import 'package:flutter/material.dart';
import 'package:foody/models/MenuFood.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:foody/widgets/add_comment.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const routeName = "/placedetail";
  static const image = 'https://picsum.photos/id/769/200/200';
  final PlacesService service = PlacesService();

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  TabController controller;

  void _addComment(ctx, String foodId, String placeId) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddComment(foodId: foodId, placeId: placeId),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<MenuFood> list = [];
    final productId = ModalRoute.of(context).settings.arguments as String;
    //final place = widget.service.findById(productId);
    // final deneme=Provider.of<PlacesService>(context);
    // final sonra=deneme.findById(productId);
    return Scaffold(
      body: FutureBuilder(
        future: widget.service.findById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data.menu;
            // foreach((k, v,k2,v2) {
            //   list.add(MenuFood(k2, v["foodRat"], v["foodName"]));
            // });
            data.forEach((k, v) {
              list.add(MenuFood(k, v["foodRat"], v["foodName"]));
            });

            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                centerTitle: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    snapshot.data.imageUrl,
                    fit: BoxFit.fill,
                  ),
                  title: Text(snapshot.data.title),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                      child: ListTile(
                        title: Text(list[index].rat),
                        leading: Text(list[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.rate_review,
                              color: Theme.of(context).primaryColor),
                          onPressed: () {
                            _addComment(
                                context,
                                list[index].id,
                                snapshot.data.id);
                          },
                        ),
                      ),
                      elevation: 3,
                    ),
                  );
                }, childCount: snapshot.data.menu.length),
              ),
            ]);
          }
        },
      ),
    );
  }
}
