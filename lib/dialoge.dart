import 'package:flutter/material.dart';

void showMyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Title'),
        content: Container(
          width: 600.0,
          height: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'Icons/poinsettia.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 16),
              Text('Descreption',
                style: TextStyle(
                  fontSize: 25
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL',
              style: TextStyle(
                  color: Colors.black54
              ),
            ),
          ),
          TextButton(
            onPressed: () {

              // Do something when the button is pressed
            },
            child: Text('Enregestrer le choix',
            style: TextStyle(
              color: Colors.green
            ),
            ),
          ),
        ],
      );
    },
  );
}
