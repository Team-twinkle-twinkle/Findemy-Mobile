enum GradeEnum {
  ELEMENTARY_1('초등생 1학년'),
  ELEMENTARY_2('초등생 2학년'),
  ELEMENTARY_3('초등생 3학년'),
  ELEMENTARY_4('초등생 4학년'),
  ELEMENTARY_5('초등생 5학년'),
  ELEMENTARY_6('초등생 6학년'),
  MIDDLE_1('중등생 1학년'),
  MIDDLE_2('중등생 2학년'),
  MIDDLE_3('중등생 3학년'),
  HIGH_1('고등생 1학년'),
  HIGH_2('고등생 2학년'),
  HIGH_3('고등생 3학년');

  final String displayName;

  const GradeEnum(this.displayName);

  factory GradeEnum.fromString(String value) {
    switch (value) {
      case 'ELEMENTARY_1':
        return GradeEnum.ELEMENTARY_1;
      case 'ELEMENTARY_2':
        return GradeEnum.ELEMENTARY_2;
      case 'ELEMENTARY_3':
        return GradeEnum.ELEMENTARY_3;
      case 'ELEMENTARY_4':
        return GradeEnum.ELEMENTARY_4;
      case 'ELEMENTARY_5':
        return GradeEnum.ELEMENTARY_5;
      case 'ELEMENTARY_6':
        return GradeEnum.ELEMENTARY_6;
      case 'MIDDLE_1':
        return GradeEnum.MIDDLE_1;
      case 'MIDDLE_2':
        return GradeEnum.MIDDLE_2;
      case 'MIDDLE_3':
        return GradeEnum.MIDDLE_3;
      case 'HIGH_1':
        return GradeEnum.HIGH_1;
      case 'HIGH_2':
        return GradeEnum.HIGH_2;
      case 'HIGH_3':
        return GradeEnum.HIGH_3;
      default:
        throw ArgumentError('Unknown GradeEnum value: $value');
    }
  }

  static GradeEnum fromDisplayName(String displayName) {
    return GradeEnum.values.firstWhere(
          (e) => e.displayName == displayName,
      orElse: () => throw ArgumentError('Unknown GradeEnum displayName: $displayName'),
    );
  }
}