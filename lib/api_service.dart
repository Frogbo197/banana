import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.0.2.2:8000/api";

  static Future<List> getUsers() async {
    final res = await http.get(Uri.parse("$baseUrl/users"));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("API lỗi");
    }
  }
}