import 'dart:convert'; // jsonEncode, jsonDecode 사용을 위해 필요

class WishlistItem {
  final String academyId;
  final String academyName;
  final String academyAddress;
  final List<String> subjects;
  final int totalPrice;
  final String academyImageUrl;

  WishlistItem({
    required this.academyId,
    required this.academyName,
    required this.academyAddress,
    required this.subjects,
    required this.totalPrice,
    required this.academyImageUrl,
  });

  // ✨ WishlistItem 객체를 Map<String, dynamic>으로 변환하는 메서드 (직렬화의 첫 단계)
  Map<String, dynamic> toJson() {
    return {
      'academyId': academyId,
      'academyName': academyName,
      'academyAddress': academyAddress,
      'subjects': subjects,
      'totalPrice': totalPrice,
      'academyImageUrl': academyImageUrl,
    };
  }

  // ✨ Map<String, dynamic>에서 WishlistItem 객체를 생성하는 팩토리 생성자 (역직렬화의 첫 단계)
  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      academyId: json['academyId'] as String,
      academyName: json['academyName'] as String,
      academyAddress: json['academyAddress'] as String,
      subjects: List<String>.from(json['subjects']), // List<dynamic>을 List<String>으로 변환
      totalPrice: json['totalPrice'] as int,
      academyImageUrl: json['academyImageUrl'] as String,
    );
  }

  // ✨ WishlistItem 객체를 JSON 문자열로 변환하는 메서드 (SharedPreferences 저장을 위함)
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // ✨ JSON 문자열에서 WishlistItem 객체를 생성하는 팩토리 생성자 (SharedPreferences 로드를 위함)
  factory WishlistItem.fromJsonString(String jsonString) {
    return WishlistItem.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}