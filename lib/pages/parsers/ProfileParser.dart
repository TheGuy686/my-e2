import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:MyE2/pages/classes/globals.dart';
import 'package:MyE2/utils/Endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProfileParser {
  static HeadlessInAppWebView headlessWebView;
  static dynamic _controller;

  static parseFromPage(String profileId) async {
    p('THERE YOU ARE');

    p('https://app.earth2.io/#profile/${profileId}');

    headlessWebView = new HeadlessInAppWebView(
      initialUrl: 'https://app.earth2.io/#profile/${profileId}',
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(),
      ),
      onProgressChanged: (controller, progress) {
        p('PROGRESS: ${progress}');
      },
      onConsoleMessage: (controller, consoleMessage) {
        // p("CONSOLE MESSAGE: " + consoleMessage.message);
      },
      onLoadStart: (controller, url) async {
        p('on load start');
      },
      onLoadStop: (controller, url) async {
        p('loaded');

        Timer(Duration(milliseconds: 500), () async {
          String settingsSectionHtml = await readJS(controller);

          parseProfileInfo(settingsSectionHtml);
        });
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {},
    );

    headlessWebView.run();
  }

  static Future<String> readJS(controller) async {
    String sectionsHtml = await controller.evaluateJavascript(
        source:
            "document.getElementsByClassName('settings-content')[0].innerHTML");

    return sectionsHtml;
  }

  static Map parseProfileInfo(String html) {
    Map profile = {};

    RegExp re = new RegExp(
      r'<img class="picture" alt="user picture" src="(.*?)">',
      caseSensitive: false,
      multiLine: true,
    );

    var match = re.firstMatch(html);

    profile['avatar'] = match.group(1);

    re = new RegExp(
      r'<div class="name">(.*?)<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['alias'] = match.group(1);

    re = new RegExp(
      r'<div class="description">Owns <b>([0-9]+)<\/b> Properties<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    inspect(match.group(0));

    profile['owns'] = match.group(1);

    re = new RegExp(
      r'<div class="totaltiles">.*?<b>(.*?)<\/b>.*?<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['tiles'] = match.group(1);

    re = new RegExp(
      r'<div class="networth">.*?<b>E\$(.*?)<\/b><\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['networth'] = match.group(1);

    re = new RegExp(
      r'<div class="profit">.*?<b>E\$(.*?) \((.*?)%\)<\/b><\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['netProfit'] = match.group(1);
    profile['netProfitPercent'] = match.group(2);

    inspect(profile);

    return profile;
  }
}
