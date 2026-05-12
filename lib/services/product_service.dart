import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/product_model.dart'; 

class ProductService {
  final String baseUrl = 'https://task.itprojects.web.id';

  Future<List<ProductModel>> fetchProducts(String token) async {
    final url = Uri.parse('$baseUrl/api/products');  
    
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
        'Accept': 'application/json', 
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      List<dynamic> productsData = [];

      if (jsonResponse['data'] != null && jsonResponse['data']['products'] != null) {
        // Skenario A: Dibungkus dalam "data" -> "products"
        productsData = jsonResponse['data']['products'];
      } else if (jsonResponse['products'] != null) {
        // Skenario B: Langsung "products" di luar
        productsData = jsonResponse['products'];
      } else if (jsonResponse['data'] is List) {
        // Skenario C: "data" itu sendiri adalah list-nya
        productsData = jsonResponse['data'];
      }

      return productsData.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data produk: ${response.body}');
    }
  }

  Future<void> submitFinalTask({
    required String token,
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl, 
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      debugPrint('Tugas berhasil disubmit!');
    } else {
      throw Exception('Gagal submit tugas: ${response.body}');
    }
  }

  Future<bool> saveDraft({
    required String token,
    required String name,
    required int price,
    required String description,
  }) async {
    final url = Uri.parse('$baseUrl/api/products');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal menyimpan produk: ${response.body}');
    }
  }

  Future<bool> submitTask({
    required String token,
    required String name,
    required int price,
    required String description,
    required String githubUrl, 
  }) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token', 
        'Content-Type': 'application/json',
        'Accept': 'application/json', 
      },
      body: jsonEncode({
        'name': name, 
        'price': price, 
        'description': description, 
        'github_url': githubUrl, 
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal submit tugas: ${response.body}');
    }
  }

  Future<bool> deleteDraft(String token, int productId) async {
    final url = Uri.parse('$baseUrl/api/products/$productId'); 
    
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Gagal menghapus cookies: ${response.body}');
    }
  }
}