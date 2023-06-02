import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../constants/Url.dart';
import '../model/OrderModel.dart';
import '../model/ProduitModel.dart';

OrderModel? orderModel;

class OrderService extends ChangeNotifier {
  String? image;
  String? name;
  double? prix;
  String? name_table;

  List<OrderModel> productList = [];

  void handlesaveproduct(
      {required ProduitModel produitModel, required String? name_table}) {
    image = produitModel.image!;
    name = produitModel.name!;
    prix = produitModel.prix!;
    this.name_table = name_table;
    final orderModel = OrderModel(
        image: image, name: name, prix: prix, name_table: this.name_table);
    productList.add(orderModel);
    print('her is the orders : '+productList.toString());
  }

  void handleremoveproduct({
    required ProduitModel produitModel,
    required String? name_table,
  }) {
    final orderModel = OrderModel(
      image: produitModel.image!,
      name: produitModel.name!,
      prix: produitModel.prix!,
      name_table: name_table,
    );

    productList.removeWhere((order) =>
    order.image == orderModel.image &&
        order.name == orderModel.name &&
        order.prix == orderModel.prix &&
        order.name_table == orderModel.name_table);

    print('Here is the order after deleted: ' + productList.toString());
  }



  Future<void> sendProduct() async {
    try {
      final List<Map<String, dynamic>> orders = productList.map((order) {
        return {
          'name_table': order.name_table,
          'image': order.image,
          'name': order.name,
          'prix': order.prix,
        };
      }).toList();

      final requestData = {'name_table': name_table, 'orders': productList};
      final encodedData = jsonEncode(requestData);

      print('Data sent to DB: $encodedData');

      final response = await http.post(
        Uri.parse(orderURL),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: encodedData,
      );

      print(response.body);
      print('response.body');
      print('the name :'+ encodedData);

      if (response.statusCode == 200) {
        // Request successful, handle the response
        log('Data sent successfully');
        productList.clear();
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
