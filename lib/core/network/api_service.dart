
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://45.129.87.38:6065/";

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse(baseUrl + path);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('POST ${response.statusCode}: ${response.body}');
    }
  }

  Future<dynamic> get(String path) async {
    final url = Uri.parse(baseUrl + path);
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) ;
    } else {
      throw Exception('GET ${response.statusCode}: ${response.body}');
    }
  }
}
