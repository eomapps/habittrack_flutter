import 'package:intl/intl.dart';

class HTUtils {
  HTUtils._();

  static String getFormattedDate() {
    final today = DateTime.now();
    return DateFormat('EEEE, MMMM d').format(today);
  }
}
