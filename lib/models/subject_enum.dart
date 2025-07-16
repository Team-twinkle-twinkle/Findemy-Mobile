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
        return "국어";
      case SubjectEnum.MATH:
        return "수학";
      case SubjectEnum.SOCIAL:
        return "사회";
      case SubjectEnum.SCIENCE:
        return "과학";
      case SubjectEnum.ENGLISH:
        return "영어";
      default:
        return "";
    }
  }

  static SubjectEnum fromString(String subject) {
    switch (subject) {
      case "국어":
        return SubjectEnum.KOREAN;
      case "수학":
        return SubjectEnum.MATH;
      case "사회":
        return SubjectEnum.SOCIAL;
      case "과학":
        return SubjectEnum.SCIENCE;
      case "영어":
        return SubjectEnum.ENGLISH;
      default:
        throw Exception('Unknown subject: $subject');
    }
  }

  static String toKorean(String englishSubject) {
    switch (englishSubject.toUpperCase()) {
      case "KOREAN":
        return "국어";
      case "MATH":
        return "수학";
      case "SOCIAL":
        return "사회";
      case "SCIENCE":
        return "과학";
      case "ENGLISH":
        return "영어";
      default:
        return englishSubject;
    }
  }
}