class Comment {
  String id;
  String userId;
  String imageUrl;
  String comment;
  String placeId;
  String foodId;
  String rate;
  DateTime date;

  Comment(
      {this.id,
      this.date,
      this.userId,
      this.imageUrl,
      this.comment,
      this.placeId,
      this.foodId,
      this.rate});
}
