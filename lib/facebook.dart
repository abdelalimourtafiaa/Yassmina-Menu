import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'ExpandeLeft.dart';
import 'instagram.dart';
import 'main.dart';
import 'view.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WebViewAppFacbook(),
    ),
  );
}

class WebViewAppFacbook extends StatefulWidget {
  const WebViewAppFacbook({Key? key}) : super(key: key);

  @override
  State<WebViewAppFacbook> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewAppFacbook> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }
  // ... to here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFfa7777),
        title: const Text('Facebook Page'),
      ),
      body: SafeArea(
        child: Row(
          children: [
            ExpandedLeft(),
            Expanded(
              flex: 19,

              child: const WebView(
              initialUrl: 'https://www.facebook.com/tawjihhoussam',
                javascriptMode: JavascriptMode.unrestricted,
          ),
            ),
        ],
        ),
      ),
    );
  }
}