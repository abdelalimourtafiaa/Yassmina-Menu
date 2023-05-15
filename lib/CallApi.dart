import 'package:http/http.dart' as http;
class CallApi{
  final String _url = 'http://127.0.0.1:8000/api/';
  final String _imgUrl='http://mark.dbestech.com/uploads/';
  getImage(){
    return _imgUrl;
  }
  getProductData(apiUrl) async {
    http.Response response = await http.get(
        Uri.parse(_url+apiUrl)) ;
    try {
      if (response.statusCode == 200) {
        return response;
      } else {
        return 'failed';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }
}