import 'package:chuckapi/helper/url.dart';
import 'package:chuckapi/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future aboutTab(
    BuildContext context, ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
  return showModalBottomSheet(
    context: context,
    elevation: 10,
    // enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    backgroundColor: MyTheme.isDark
        ? darkDynamic?.background
        : lightDynamic?.background ?? Theme.of(context).canvasColor,
    isScrollControlled: false,
    builder: (context) {
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: lightDynamic?.primary ?? Colors.blue,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'About',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: lightDynamic?.primary ?? Colors.blue,
                      fontSize: 20.0,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
              child: Divider(
                color: Colors.pink,
                thickness: 1,
                indent: 18,
                endIndent: 18,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/twitter_profile.jpg'),
                            backgroundColor: Colors.transparent,
                            radius: 32.0,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Anup',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                    "This app fetches random jokes from"),
                                Text(
                                  'https://api.chucknorris.io/',
                                  style: TextStyle(
                                      color: MyTheme.isDark
                                          ? Colors.lightGreenAccent
                                          : lightDynamic?.primary ??
                                              Colors.lightGreenAccent),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const SizedBox(
                                  height: 48.0,
                                ),
                                const Text(
                                  "Thank you for trying this app.",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const Text(
                                  "This app is for learning purpose only.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    final Uri url =
                        Uri.parse('https://twitter.com/mrsneakyturtle/');
                    launchInWebView(url);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/twitter-brands.svg',
                    color: Colors.blue,
                    height: 36,
                    width: 36,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final Uri url = Uri.parse(
                        'https://github.com/anupthedev/flutter-extra/releases/latest');
                    launchInWebView(url);
                  },
                  icon: SvgPicture.asset(
                    'assets/images/github-brands.svg',
                    color: MyTheme.isDark ? Colors.white : Colors.black,
                    height: 36,
                    width: 36,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
          ],
        ),
      );
    },
  );
}
