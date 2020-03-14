class User{
  String uId;
  String imageUrl;
  List<String> following;
  List<String> followers;
  String lastname;
  String name;
  List<String> comments;
  User(
      {this.uId,
      this.imageUrl,
      this.following,
      this.followers,
      this.lastname,
      this.name,
      this.comments}
  );
  
}
