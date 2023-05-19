import 'package:flutter/material.dart';

import 'facebook.dart';
import 'instagram.dart';
import 'view.dart';
class ExpandedLeft extends StatefulWidget {

  @override
  _ExpandedState createState() => _ExpandedState();

}
class _ExpandedState extends State<ExpandedLeft> {
  @override
  Widget build(BuildContext context) {
    return  Expanded(
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
    );
  }

}