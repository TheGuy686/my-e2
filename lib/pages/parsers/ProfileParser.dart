import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:MyE2/pages/classes/globals.dart';
import 'package:MyE2/pages/dashboard/models/Location.dart';
import 'package:MyE2/pages/dashboard/models/Profile.dart';
import 'package:MyE2/pages/dashboard/models/Property.dart';
import 'package:MyE2/utils/Endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ProfileParser {
  static HeadlessInAppWebView headlessWebView;
  static Profile prof;

  static parseFromPage(String profileId, Function updateProfile) async {
    headlessWebView = new HeadlessInAppWebView(
      initialUrl: 'https://app.earth2.io/#profile/${profileId}',
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(),
      ),
      onProgressChanged: (controller, progress) {
        p('PROGRESS: ${progress}');
      },
      onConsoleMessage: (controller, consoleMessage) {},
      onLoadStart: (controller, url) async {},
      onLoadStop: (controller, url) async {
        p('loaded');

        Timer(Duration(milliseconds: 500), () async {
          String settingsSectionHtml = await readJS(controller);

          parseProfileInfo(settingsSectionHtml, controller, updateProfile);
        });
      },
      onUpdateVisitedHistory: (controller, url, androidIsReload) {},
    );

    headlessWebView.run();
  }

  static Future<String> readJS(controller) async {
    return await controller.evaluateJavascript(
        source:
            "document.getElementsByClassName('settings-content')[0].innerHTML");
  }

  static Future<String> readPropertiesJS(controller) async {
    return await controller.evaluateJavascript(
        source:
            "document.getElementsByClassName('portfolio-content')[0].innerHTML");
  }

  static Future simulateNextClick(controller, updateProfile) async {
    await controller.evaluateJavascript(
        source: "\$('.pagination li.waves-effect a')[1].click();");

    Timer(
      Duration(milliseconds: 200),
      () async {
        doParseProperties(controller, updateProfile);
      },
    );
  }

  static Future parseProfileInfo(String html, controller, updateProfile) async {
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

    profile['owns'] = int.parse(match.group(1).replaceAll(RegExp(r','), ''));

    re = new RegExp(
      r'<div class="totaltiles">.*?<b>(.*?)<\/b>.*?<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['tiles'] = int.parse(match.group(1).replaceAll(RegExp(r','), ''));

    re = new RegExp(
      r'<div class="networth">.*?<b>E\$(.*?)<\/b><\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['networth'] =
        num.parse(match.group(1).replaceAll(RegExp(r','), ''));

    re = new RegExp(
      r'<div class="profit">.*?<b>E\$(.*?) \((.*?)%\)<\/b><\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    profile['netProfit'] =
        num.parse(match.group(1).replaceAll(RegExp(r','), ''));
    profile['netProfitPercent'] =
        num.parse(match.group(2).replaceAll(RegExp(r','), ''));

    profile['properties'] = {};

    prof = Profile(
      avatar: profile['avatar'],
      alias: profile['alias'],
      owns: profile['owns'],
      tiles: profile['tiles'],
      netWorth: profile['networth'],
      netProfit: profile['netProfit'],
      netProfitPercent: profile['netProfitPercent'],
    );

    await doParseProperties(controller, updateProfile);
  }

  static Future doParseProperties(controller, updateProfile) async {
    parseProperties(await readPropertiesJS(controller));

    if (prof.properties.length < prof.owns) {
      await simulateNextClick(controller, updateProfile);
    } else {
      updateProfile(prof);
    }
  }

  static Map parseProperty(String html) {
    Map prop = {};

    RegExp re = new RegExp(
      r'<a href="#propertyInfo\/(.*?)">',
      caseSensitive: false,
      multiLine: true,
    );

    var match = re.firstMatch(html);

    prop['id'] = match.group(1);

    re = new RegExp(
      r'<a href="#propertyInfo\/(.*?)">',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['id'] = match.group(1);

    re = new RegExp(
      r'<a href="(#propertyInfo\/[a-zA-Z0-9 -]+)">',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['link'] = match.group(1);

    re = new RegExp(
      r'id="profile-landfield-img-[0-9]+".*src="(.*\.jpg)"',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['thumbnail'] = match.group(1);

    re = new RegExp(
      r'<div class="description">(.*?)<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['description'] = match.group(1);

    re = new RegExp(
      r'<div class="price">.*?([0-9\.]+).*?<span class="trade-value">.*<i class="material-icons">layers<\/i>.*?([0-9\.]+).*?<\/span>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['price'] = match.group(1);
    prop['tradeValue'] = match.group(2);

    re = new RegExp(
      r'<div class="tile-count"><b>([0-9]+)<\/b> tiles<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['tiles'] = num.parse(match.group(1));

    re = new RegExp(
      r'data-land-centre="([0-9\.-]+) ([0-9\.-]+)"',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['loc'] = {
      'long': match.group(1),
      'lat': match.group(2),
    };

    re = new RegExp(
      r'<div class="coordinates">(.*?)<\/div>',
      caseSensitive: false,
      multiLine: true,
    );

    match = re.firstMatch(html);

    prop['loc']['location'] = match.group(1);

    return prop;
  }

  static void parseProperties(String html) {
    Map prop = {};

    var bits = html.split(RegExp(r'<div class="col-lg-4 col-md-6 col-12">'));

    bits.forEach(
      (propHtml) {
        var re = RegExp(r'<a href="#propertyInfo\/([a-zA-Z0-9 -]+)">');

        if (!re.hasMatch(propHtml)) return;

        prop = parseProperty(propHtml);

        prof.properties.add(
          Property(
            id: prop['id'],
            thumbnail: prop['thumbnail'],
            link: prop['link'],
            description: prop['description'],
            price: prop['price'],
            tradeValue: prop['tradeValue'],
            tiles: prop['tiles'],
            location: Location(
              long: prop['loc']['long'],
              lat: prop['loc']['lat'],
              location: prop['loc']['location'],
            ),
          ),
        );
      },
    );
  }
}
