class MyPageModel {
  final String accountId;
  final int totalPrice;
  final List<Favorite> favorites;

  MyPageModel({
    required this.accountId,
    required this.totalPrice,
    required this.favorites,
  });

  factory MyPageModel.fromJson(Map<String, dynamic> json) {
    return MyPageModel(
      accountId: json['account_id'],
      totalPrice: json['total_price'],
      favorites: (json['favorites'] as List)
          .map((i) => Favorite.fromJson(i))
          .toList(),
    );
  }
}

class Favorite {
  final int academyId;
  final String academyName;
  final String academyImgUrl;
  final String address;
  final List<String> subjects; // Assuming "SUBJECT" is a String enum value
  final int price;

  Favorite({
    required this.academyId,
    required this.academyName,
    required this.academyImgUrl,
    required this.address,
    required this.subjects,
    required this.price,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      academyId: json['academy_id'],
      academyName: json['academy_name'],
      academyImgUrl: json['academy_img_url'],
      address: json['address'],
      subjects: List<String>.from(json['subjects']),
      price: json['price'],
    );
  }
}