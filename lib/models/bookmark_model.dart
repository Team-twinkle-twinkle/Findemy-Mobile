class BookMarkModel {
  final List<int> academyId;

  BookMarkModel({required this.academyId});

  Map<String, dynamic> toJson() {

    return {'academy_id': academyId};
  }
}