import 'package:flutter/material.dart';
import 'package:foody/models/user.dart';
import 'package:foody/services/PlacesService.dart';
import 'package:foody/services/auth.dart';
import 'package:foody/services/database.dart';
import 'package:foody/widgets/Loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatelessWidget {
  PlacesService service = PlacesService();
  DatabaseService dbService = DatabaseService();

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage("https://picsum.photos/200"),
            fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://pbs.twimg.com/profile_images/1152704512509042691/IHtdjMgr_400x400.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 8.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName(String name) {
    return name!=null? Text(name):Text(
      "Nazım Urdoğan",
      style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 25),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = GoogleFonts.roboto(
        fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, fontSize: 12);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        "bio",
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle =
        GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w300);

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _userComments(String uid) {
    return FutureBuilder(
      future: dbService.getUserComments(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        } else {
          return ListTile(
            leading: Text("data"),
          );
        }
      },
    );
  }

  Widget _buildStatContainer() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Takipçiler", "45"),
          _buildStatItem("Oylamalar", "35"),
          //_buildStatItem("Ünvanlar", _achievement),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    User authedUser = User();
    authedUser=dbService.getUser(user.uId);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                _buildCoverImage(screenSize),
                Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                      ),
                      _buildProfileImage(),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildFullName(authedUser.name),
                    _buildBio(context),
                    _buildStatContainer(),
                    // _userComments(user.uId),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
