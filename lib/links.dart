import 'package:url_launcher/url_launcher.dart';

const String kSponsoredUrl = 'https://uplcm.com/4/12161943';
const String kPrivacyUrl = 'https://wgcalc-hp-2610.web.app/privacy-policy.html';
const String kAboutUrl = 'https://wgcalc-hp-2610.web.app/about.html';
const String kSupportEmail = 'thedevstudio013@gmail.com';

Future<void> openUrl(String url) async {
  try {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {
    // Nothing to do if no browser is available.
  }
}
