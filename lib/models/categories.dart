class Categories {
  final int cat_id;
  final String cat_title;
  

  Categories({this.cat_id, this.cat_title});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      cat_id: json['cat_id'],
      cat_title: json['cat_title'],
     
    );
  }

  Map<String, dynamic> toJson() => {
    'cat_id': cat_id,
    'cat_title': cat_title,
  };
}
