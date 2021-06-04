class Product {
  final int product_id;
  final String cat_id;
  final String brand_id;
  final String date;
  final String product_title;
  final String img_name;
  final int product_price;
  final String product_desc;
  final String status;
  final String product_keywords;
  var rating;
  final String post;

  Product(
      {this.product_id,
      this.cat_id,
      this.brand_id,
      this.date,
      this.product_title,
      this.img_name,
      this.product_price,
      this.product_desc,
      this.status,
      this.product_keywords,
      this.rating,
      this.post});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        product_id: json['product_id'],
        cat_id: json['cat_id'],
        brand_id: json['brand_id'],
        date: json['date'],
        product_title: json['product_title'],
        img_name:
            "http://ecom777.000webhostapp.com/Ecommerce/admin/product_images/" +
                json['img_name'],
        product_price: json['product_price'],
        product_desc: json['product_desc'],
        status: json['status'],
        product_keywords: json['product_keywords'],
        rating: json['rating'],
        post: json['post']);
  }

  Map<String, dynamic> toJson() => {
        'product_id': product_id,
        'cat_id': cat_id,
        'brand_id': brand_id,
        'product_title': product_title,
        'img_name': img_name,
        'product_price': product_price,
        'product_desc': product_desc,
        'status': status,
        'product_keywords': product_keywords,
        'rating': rating,
        'post': post
      };
}
