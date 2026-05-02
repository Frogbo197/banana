import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator
  //http://10.0.2.2:8001

// Web
  //http://127.0.0.1:8001
  static const baseUrl = "http://10.0.2.2:8001/api";

  static Future<List> getUsers() async {
    final res = await http.get(Uri.parse("$baseUrl/users"));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("API lỗi");
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser(String email) async {
    final res = await http.get(
      Uri.parse("$baseUrl/users?email=$email"),
    );

    return json.decode(res.body);
  }
}