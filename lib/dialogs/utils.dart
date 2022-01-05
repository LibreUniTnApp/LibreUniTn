import 'dart:ui' show Color;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;

Future<void> launch(String urlString) => custom_tabs.launch(
    urlString,
    customTabsOption: const CustomTabsOption(
        enableDefaultShare: false,
        extraCustomTabs: [
            'org.mozilla.firefox'
        ]
    ),
    safariVCOption: const SafariViewControllerOption(
        entersReaderIfAvailable: false,
        preferredBarTintColor: Color(0xffb10c26)
    )
);
