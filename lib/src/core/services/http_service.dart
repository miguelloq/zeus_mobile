import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  Future<String> getJson({required String url}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      var json = jsonDecode(response.body);
      throw Exception('${json["error"]}');
    }
  }

  Future<String> postJson(
      {required String url, required Object postBody}) async {
    final response = await http.post(Uri.parse(url),
        body: postBody,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      var json = jsonDecode(response.body);
      throw Exception('${json["error"]}');
    }
  }

  Future<String> deleteJson({
    required String url,
  }) async {
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      var json = jsonDecode(response.body);
      throw Exception('${json["error"]}');
    }
  }

  Future<String> putJson(
      {required String url, required Object postBody}) async {
    print(postBody);
    final response = await http.put(Uri.parse(url),
        body: postBody,
        headers: <String, String>{'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      var json = jsonDecode(response.body);
      throw Exception('${json["error"]}');
    }
  }
}
