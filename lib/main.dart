import 'dart:async';
import 'dart:convert';
import 'dart:core';


import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:menu/CallApi.dart';
import 'package:menu/SplashScreen.dart';
import 'package:menu/instagram.dart';
import 'package:menu/model/CategorieModel.dart';
import 'package:menu/services/category_service.dart';
import 'package:menu/services/product_services.dart';
import 'package:menu/slider.dart';
import 'constants/Url.dart';
import 'facebook.dart';
import 'model/ProduitModel.dart';
import 'model/apiRespons.dart';


void main() {
  runApp(MyApp());
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





