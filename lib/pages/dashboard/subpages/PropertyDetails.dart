import 'dart:developer';
import 'dart:io';

import 'package:MyE2/pages/classes/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyE2/pages/models/AppState.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PropertyDetails extends StatefulWidget {
  AppState appState;
  String url;

  bool isConnected = true;

  dynamic webView;

  PropertyDetails({
    Key key,
    @required this.appState,
    this.url,
  }) : super(key: key);

  @override
  _PropertyDetailsState createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Property Details')),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
        onWebViewCreated: (controller) {
          widget.webView = controller;
        },
        onProgress: (int progress) {
          if (progress > 40) {
            widget.webView.evaluateJavascript(
                "\$(\$(\"content-holder\")[0]).attr('style', 'margin-top: 0px;');");
            widget.webView.evaluateJavascript("\$('.header').hide();");
          }
        },
        onPageFinished: (String url) async {},
      ),
    );
  }
}
