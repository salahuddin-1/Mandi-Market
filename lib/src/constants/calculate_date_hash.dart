int calculateDateHash(DateTime date) {
  final int day = date.day;
  final int month = date.month;
  final int year = date.year;
  final int initialYear = 2021;
  // Calculated by taking
  // day =12 ,month = 12, year = 2021
  // initial year = year
  // Formula (month * constantMultiplier) + day * (current year - initial year)
  final int initialYearLastCalculatedValue = 403;

  // Multiply by this number to get different month value
  // Note it should be >= 31 (Total days) to avoid collisions
  final int constantMultiplier = 31;

  int value = month * constantMultiplier;

  value = day + value;

  value = value + (initialYearLastCalculatedValue * (year - initialYear));

  return value;
}
