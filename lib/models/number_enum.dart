enum NumberEnum {
  ONCE('주 1회'),
  TWICE('주 2회'),
  THREE_TIMES('주 3회'),
  FOUR_TIMES('주 4회'),
  FIVE_TIMES('주 5회'),
  SIX_TIMES('주 6회');

  final String displayName;

  const NumberEnum(this.displayName);

  factory NumberEnum.fromString(String value) {
    switch (value) {
      case 'ONCE':
        return NumberEnum.ONCE;
      case 'TWICE':
        return NumberEnum.TWICE;
      case 'THREE_TIMES':
        return NumberEnum.THREE_TIMES;
      case 'FOUR_TIMES':
        return NumberEnum.FOUR_TIMES;
      case 'FIVE_TIMES':
        return NumberEnum.FIVE_TIMES;
      case 'SIX_TIMES':
        return NumberEnum.SIX_TIMES;
      default:
        throw ArgumentError('Unknown NumberEnum value: $value');
    }
  }

  static NumberEnum fromDisplayName(String displayName) {
    return NumberEnum.values.firstWhere(
          (e) => e.displayName == displayName,
      orElse: () => throw ArgumentError('Unknown NumberEnum displayName: $displayName'),
    );
  }
}