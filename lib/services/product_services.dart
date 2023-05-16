import 'package:http/http.dart' as http;
import 'package:menu/model/apiRespons.dart';
import 'dart:convert';

import '../constants/Url.dart';
import '../model/ProduitModel.dart';

Future<ApiResponse> fetchProducts() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse(productURL),
      headers: {
        'Accept': 'application/json',
      },
    );

    switch (response.statusCode) {
      case 200:
        List<dynamic> data = jsonDecode(response.body)['produit'];
        List<ProduitModel> produit = data.map((e) => ProduitModel.fromJson(e)).toList();
        apiResponse.data = produit;
        break;
      case 401:
        apiResponse.error = 'unauthorized';
        break;
      default:
        print(response.statusCode);
        apiResponse.error = 'somethingWentWrong';
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = 'serverError';
  }
  return apiResponse;
}
