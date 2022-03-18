import 'package:http/http.dart';
import 'dart:convert';

class Networkhelper {
  Networkhelper(this.url);
  final String url;

  Future getData() async {
    Response response = await get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      var decodeddata = jsonDecode(data);
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
