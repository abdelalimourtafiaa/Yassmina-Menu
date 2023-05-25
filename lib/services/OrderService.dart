import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants/Url.dart';
import '../model/OrderModel.dart';
import '../model/ProduitModel.dart';

OrderModel? orderModel;
class OrderService extends ChangeNotifier{
  String? image;
  String? name;
  double? prix;


  List<OrderModel> productList = [];
   handlesaveproduct({required ProduitModel produitModel}) {
     print("her is the  product : ${produitModel.prix}");
     productList.clear();
    image=produitModel.image!;
    name=produitModel.name!;
    prix=produitModel.prix!;
     final orderModel=OrderModel( image: image, name: name, prix: prix);
     productList.add(orderModel);
     log( productList.toString());

   }

  Future<void>sendProduct()async {
     try {
      final response = await http.post(
        Uri.parse(orderURL),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(productList),

      );

      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        // Request successful, handle the response
        log('Data sent successfully');

      } else {
        // Request failed, handle the error
        log('Failed to send data');
      }
    } catch (error) {
      // Handle any error that occurred during the request
      log('Error: $error');
    }
  }

}

