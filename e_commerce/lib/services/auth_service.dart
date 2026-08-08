import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('LOGIN STATUS: ${response.statusCode}');
    print('LOGIN RESPONSE: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data['token'] != null) {
        return data['token'];
      }

      throw Exception('Login succeeded but no token was returned.');
    }

    if (response.statusCode == 401) {
      throw Exception('Invalid username or password.');
    }

    throw Exception('Login failed. Server returned ${response.statusCode}.');
  }
}
