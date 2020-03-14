class Food {
  String id;
  String title;
  List<String> category;

  Food({this.title, this.category});

  Food.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    category = json['category'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['category'] = this.category;
    return data;
  }
}
