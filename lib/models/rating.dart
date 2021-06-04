class Rating {
  final int id;
  final int p_id;
  final String email;
  final double rating;

  Rating({this.id, this.p_id, this.email, this.rating});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      p_id: json['p_id'],
      email: json['email'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'p_id': p_id,
        'email': email,
        'rating': rating,
        
      };
}
