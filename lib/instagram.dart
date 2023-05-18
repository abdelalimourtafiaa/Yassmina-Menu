import 'dart:io';                            // Add this import.
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'facebook.dart';
import 'main.dart';
import 'view.dart';

void main() {
  runApp(
    const MaterialApp(
      home: WebViewAppInstagram(),
    ),
  );
}

class WebViewAppInstagram extends StatefulWidget {
  const WebViewAppInstagram({Key? key}) : super(key: key);

  @override
  State<WebViewAppInstagram> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewAppInstagram> {
  // Add from here ...
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
        title: const Text('Instagram Page'),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFfa7777),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(35),bottomRight: Radius.circular(35))
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.home,size: 35,color: Colors.white,), onPressed: () { Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>  MyHomePage()),
                        ); },
                        ),
                        SizedBox(height: 50,),
                        IconButton(
                          icon: Icon(Icons.facebook,size: 35,color: Colors.white,), onPressed: () {
                          Navigator.push(
                            context,MaterialPageRoute(builder: (context) => WebViewAppFacbook()),
                          ); },
                        ),
                        SizedBox(height: 50,),
                        IconButton(
                          icon: Image.asset('Icons/instagram.png',color: Colors.white,width: 35,height: 35,), onPressed: () { Navigator.push(
                          context,MaterialPageRoute(builder: (context) => WebViewAppInstagram()),
                        ); },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 19,

              child: const WebView(
                initialUrl: 'https://www.instagram.com/complexeyassminaaourir/',
              ),
            ),
          ],
        ),
      ),
    );
  }
}