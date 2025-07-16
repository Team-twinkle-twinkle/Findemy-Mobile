enum SubjectEnum {
  KOREAN,
  MATH,
  SOCIAL,
  SCIENCE,
  ENGLISH,
}

extension SubjectEnumExtension on SubjectEnum {
  String get displayName {
    switch (this) {
      case SubjectEnum.KOREAN:
        return "과목, 국어";
      case SubjectEnum.MATH:
        return "과목, 수학";
      case SubjectEnum.SOCIAL:
        return "과목, 사회";
      case SubjectEnum.SCIENCE:
        return "과목, 과학";
      case SubjectEnum.ENGLISH:
        return "과목, 영어";
      default:
        return "";
    }
  }

  static SubjectEnum fromString(String subject) {
    switch (subject) {
      case "과목, 국어":
        return SubjectEnum.KOREAN;
      case "과목, 수학":
        return SubjectEnum.MATH;
      case "과목, 사회":
        return SubjectEnum.SOCIAL;
      case "과목, 과학":
        return SubjectEnum.SCIENCE;
      case "과목, 영어":
        return SubjectEnum.ENGLISH;
      default:
        throw Exception('Unknown subject: $subject');
    }
  }
}
