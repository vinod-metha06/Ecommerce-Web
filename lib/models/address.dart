class Address {
  final int id;
  final String email;
  final String city;
  final String country;
  final String address;
  final int pincode;

  Address({this.id, this.email, this.city, this.country, this.address,this.pincode});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      email: json['email'],
      city: json['city'],
      country: json['country'],
      address: json['address'],
      pincode:json['pincode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'city': city,
        'country': country,
        'address': address,
        'pincode':pincode
      };
}
