import 'package:intl/intl.dart';

class HTUtils {
  HTUtils._();

  static String getFormattedDate() {
    final today = DateTime.now();
    return DateFormat('EEEE, MMMM d').format(today);
  }

  static String getInSentenceCase(String title) {
    final letter = title.substring(0, 1).toUpperCase();
    final endLetters = title.substring(1).toLowerCase();
    return '$letter$endLetters';
  }
}
