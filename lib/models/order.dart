class Order {
  final int order_id;
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
  final int qty;
  final int total;
  final int subtotal;
  final int invoice_no;
  final String order_status;
  final String name;
  final String mobno;
  final String city;
  final String country;
  final int pincode;
  final String address;
  var rating;

  Order(
      {this.order_id,
      this.product_id,
      this.cat_id,
      this.brand_id,
      this.date,
      this.product_title,
      this.img_name,
      this.product_price,
      this.product_desc,
      this.status,
      this.product_keywords,
      this.qty,
      this.total,
      this.subtotal,
      this.invoice_no,
      this.order_status,
      this.name,
      this.mobno,
      this.city,
      this.country,
      this.pincode,
      this.address,
      this.rating});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        order_id: json['order_id'],
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
        qty: json['qty'],
        total: json['total'],
        subtotal: json['subtotal'],
        invoice_no: json['invoice_no'],
        order_status: json['order_status'],
        name: json['name'],
        mobno: json['mobno'],
        city: json['city'],
        country: json['country'],
        pincode: json['pincode'],
        address: json['address'],
        rating: json['rating']);
  }

  Map<String, dynamic> toJson() => {
        'order_id': order_id,
        'product_id': product_id,
        'cat_id': cat_id,
        'brand_id': brand_id,
        'product_title': product_title,
        'img_name': img_name,
        'product_price': product_price,
        'product_desc': product_desc,
        'status': status,
        'product_keywords': product_keywords,
        'qty': qty,
        'total': total,
        'subtotal': subtotal,
        '	invoice_no': invoice_no,
        'order_status': order_status,
        'name': name,
        'mobno': mobno,
        'city': city,
        'country': country,
        'pincode': pincode,
        'address': address,
        'rating': rating
      };
}
