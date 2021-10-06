import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  return DateFormat.yMMMMd().format(date!);
}

String formatDateShort(DateTime? date) {
  var formatDate = DateFormat.yMMMMd().format(date!);

  var year = date.year;
  var month = formatDate.substring(0, 3);
  var day = date.day;

  return "$day $month, $year";
}
