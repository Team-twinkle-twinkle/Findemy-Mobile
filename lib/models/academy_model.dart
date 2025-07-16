class Academy {
  int academyId;
  String academyName;
  String? academyImgUrl; // nullable
  String? address; // nullable
  List<String> subjects;

  Academy({
    required this.academyId,
    required this.academyName,
    this.academyImgUrl,
    this.address,
    required this.subjects,
  });

  factory Academy.fromJson(Map<String, dynamic> json) {
    return Academy(
      academyId: json['academy_id'] as int,
      academyName: json['academy_name'] as String,
      academyImgUrl: json['academy_img_url'] as String?,
      // null 허용
      address: json['address'] as String?,
      // null 허용
      subjects:
          json['subjects'] != null
              ? (json['subjects'] as List).map((e) => e.toString()).toList()
              : [], // null인 경우 빈 리스트
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'academy_id': academyId,
      'academy_name': academyName,
      'academy_img_url': academyImgUrl,
      'address': address,
      'subjects': subjects,
    };
  }
}
