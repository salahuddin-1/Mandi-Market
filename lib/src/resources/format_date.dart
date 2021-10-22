import 'package:intl/intl.dart';

String formatDate(DateTime? date) {
  if (date == null) {
    return "";
  }
  return DateFormat.yMMMMd().format(date);
}

String formatDateShort(DateTime? date) {
  if (date == null) {
    return "";
  }
  var formatDate = DateFormat.yMMMMd().format(date);

  var year = date.year;
  var month = formatDate.substring(0, 3);
  var day = date.day;

  return "$day $month, $year";
}
