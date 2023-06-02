import 'package:http/http.dart' as http;
import 'package:menu/model/CategorieModel.dart';
import 'package:menu/model/TableModel.dart';
import 'package:menu/model/apiRespons.dart';
import 'dart:convert';

import '../constants/Url.dart';

Future<ApiResponse> fetchTable() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse(tableURL),
      headers: {
        'Accept': 'application/json',
      },
    );
    switch (response.statusCode) {
      case 200:
        List<dynamic> data = jsonDecode(response.body)['table'];
        List<TableModel> table = data.map((e) => TableModel.fromJson(e)).toList();
        apiResponse.data = table;
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
