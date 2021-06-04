class User {
  int id;
  String name;
  String email;
  String password;
  String mobno;
  String profilepic;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.mobno,
    this.profilepic,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        password: data['password'],
        mobno: data['mobno'],
        profilepic:
            "http://ecom777.000webhostapp.com/Ecommerce/users/user_images/" +
                data['profilepic']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'mobno': mobno,
      'profilePic': profilepic,
    };
  }
}
