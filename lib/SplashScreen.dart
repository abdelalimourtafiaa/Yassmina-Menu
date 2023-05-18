import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'main.dart';
import 'view.dart';

class spalshscreen extends StatefulWidget{

     const spalshscreen({Key? key }) : super(key :key) ;
  @override
  State<spalshscreen> createState() => SplashScreen();
}

class SplashScreen extends State<spalshscreen>{

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 6),).then((value) => {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MyHomePage(),))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage("Icons/Yasmina1.png"),),
            SizedBox(height: 40,),

            SpinKitSquareCircle(
              color: Colors.redAccent,
              size: 50.0,
    ),
          ],
        ),
      ),
    );
  }

}