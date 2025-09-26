import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Base URL selection based on environment
  String get baseUrl {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        // 👇 For Android emulator, use 10.0.2.2 instead of localhost
        return 'http://10.212.247.218:8000';
      } else if (Platform.isIOS) {
        // iOS simulator can use localhost
        return 'http://localhost:8000';
      } else {
        // For testing on physical device or web
        return 'http://10.212.247.218:8000'; // 👈 your Wi-Fi IPv4
      }
    } else {
      // Production server URL
      return 'https://your-production-server.com';
    }
  }

  /// Fetch list of news headlines
  Future<List<dynamic>> fetchNews() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/news/'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Fetch news error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }

  /// Check if backend server is alive
  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Connection error: $e');
      return false;
    }
  }

  /// Fetch detailed news by ID
  Future<Map<String, dynamic>> getNewsDetails(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/news/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load news details: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Get news details error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }
}
