
import 'dart:core';



import 'package:flutter/material.dart';
import 'package:menu/SplashScreen.dart';
import 'package:menu/services/OrderService.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(

      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: MyApp())

  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:spalshscreen(),
    );
  }
}





