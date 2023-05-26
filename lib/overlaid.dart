import 'package:flutter/material.dart';

class SuccessMessageOverlay {
  static show(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        top: 45,
        bottom: 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(30), // Set the desired border radius
              color: Colors.white.withOpacity(
                  0.8), // Set the desired transparent background color
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                    'Icons/success.png'), // Replace with your success image
                SizedBox(height: 10),
                Text(
                  'votre demande à été bien ajouter',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}