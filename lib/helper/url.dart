import 'package:url_launcher/url_launcher.dart';

// Future<void> launchInBrowser(String url) async {
//   if (await canLaunchUrl(url)) {
//     await launchUrl(
//       url,
//       forceSafariVC: false,
//       forceWebView: true,
//       headers: <String, String>{'my_header_key': 'my_header_value'},
//     );
//   }
// }

Future<void> launchInWebView(Uri url) async {
  final bool nativeAppLaunchSucceeded = await launchUrl(
    url,
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    );
  }
  //  if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.inAppWebView,
  //     webViewConfiguration: const WebViewConfiguration(
  //         headers: <String, String>{'my_header_key': 'my_header_value'}),
  //   )) {
  //     throw 'Could not launch $url';
  //   }
}
