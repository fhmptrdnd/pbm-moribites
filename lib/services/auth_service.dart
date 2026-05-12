import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'https://task.itprojects.web.id';
  final storage = const FlutterSecureStorage();

  Future<bool> login(String nim, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': nim, 
        'password': password, 
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['data']['token'];
      
      await storage.write(key: 'token', value: token);
      return true;
    } else {
      return false;
    }
  }
}