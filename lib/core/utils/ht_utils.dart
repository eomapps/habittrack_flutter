import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HTUtils {
  HTUtils._();

  static String getFormattedDate(DateTime? dateTime) {
    return DateFormat('EEEE, MMMM d').format(dateTime ?? DateTime.now());
  }

  static String getInSentenceCase(String title) {
    final letter = title.substring(0, 1).toUpperCase();
    final endLetters = title.substring(1).toLowerCase();
    return '$letter$endLetters';
  }

  static Future<void> openUrl() async {
    final Uri url = Uri.parse('https://github.com/eomapps/habittrack_flutter');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
