
import 'package:url_launcher/url_launcher.dart';

Future<void> launchStripeOnboarding(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.inAppWebView); 
  } else {
    throw 'Could not launch $url';
  }
}
