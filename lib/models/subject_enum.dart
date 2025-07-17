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
    }
  }

  static SubjectEnum fromString(String subject) {
    switch (subject.toUpperCase()) {
      case "KOREAN":
        return SubjectEnum.KOREAN;
      case "MATH":
        return SubjectEnum.MATH;
      case "SOCIAL":
        return SubjectEnum.SOCIAL;
      case "SCIENCE":
        return SubjectEnum.SCIENCE;
      case "ENGLISH":
        return SubjectEnum.ENGLISH;
      default:
        print('Unknown subject from server: $subject');
        return SubjectEnum.KOREAN;
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