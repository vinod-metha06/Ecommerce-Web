class Brands {
  final int brand_id;
  final String brand_title;
  

  Brands({this.brand_id, this.brand_title});

  factory Brands.fromJson(Map<String, dynamic> json) {
    return Brands(
      brand_id: json['brand_id'],
      brand_title: json['brand_title'],
     
    );
  }

  Map<String, dynamic> toJson() => {
    'brand_id': brand_id,
    'brand_title': brand_title,
  };
}
