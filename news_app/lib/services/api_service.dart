import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class ApiService {
  // Base URL selection based on environment
  String get baseUrl {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        // For Android emulator, use 10.0.2.2 instead of localhost
        return 'http://10.212.247.218:8000';
      } else if (Platform.isIOS) {
        // iOS simulator can use localhost
        return 'http://localhost:8000';
      } else {
        // For testing on physical device or web
        return 'http://10.212.247.218:8000'; // your Wi-Fi IPv4
      }
    } else {
      // Production server URL
      return 'https://your-production-server.com';
    }
  }

  /// Fetch list of news headlines with optional filtering
  Future<List<dynamic>> fetchNews({
    String? category,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (category != null && category.isNotEmpty && category != 'all') {
        queryParams['category'] = category;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.parse('$baseUrl/news/').replace(queryParameters: queryParams);

      final response = await http
          .get(
            uri,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

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

  /// Get all available categories with counts
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/categories/'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Get categories error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }

  /// Get articles by category
  Future<List<dynamic>> getArticlesByCategory(
    String category, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = {
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      final uri = Uri.parse('$baseUrl/categories/$category')
          .replace(queryParameters: queryParams);

      final response = await http
          .get(
            uri,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load category articles: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Get articles by category error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }

  /// Search articles
  Future<List<dynamic>> searchArticles(
    String query, {
    String? category,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      Map<String, String> queryParams = {
        'q': query,
        'limit': limit.toString(),
        'offset': offset.toString(),
      };

      if (category != null && category.isNotEmpty && category != 'all') {
        queryParams['category'] = category;
      }

      final uri = Uri.parse('$baseUrl/search/').replace(queryParameters: queryParams);

      final response = await http
          .get(
            uri,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Search articles error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }

  /// Check if backend server is alive
  Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/')).timeout(const Duration(seconds: 5));
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

  /// Get database statistics
  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/stats/'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Get stats error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }

  /// Create a new article manually
  Future<Map<String, dynamic>> createArticle({
    required String title,
    required String content,
    String? summary,
    String? category,
    String? sourceFile,
    String? publishedDate,
  }) async {
    try {
      final body = {
        'title': title,
        'content': content,
        if (summary != null) 'summary': summary,
        if (category != null) 'category': category,
        if (sourceFile != null) 'source_file': sourceFile,
        if (publishedDate != null) 'published_date': publishedDate,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/news/'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create article: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Create article error: $e\n$stack');
      throw Exception('Network error: $e');
    }
  }

  /// Delete an article
  Future<bool> deleteArticle(int articleId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/news/$articleId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e, stack) {
      debugPrint('Delete article error: $e\n$stack');
      return false;
    }
  }

  /// Upload PDF file
  Future<Map<String, dynamic>> uploadPdf(File pdfFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload-pdf/'));

      final filename = path.basename(pdfFile.path);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          pdfFile.path,
          filename: filename,
        ),
      );

      final streamedResponse = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to upload PDF: ${response.statusCode}');
      }
    } catch (e, stack) {
      debugPrint('Upload PDF error: $e\n$stack');
      throw Exception('Upload error: $e');
    }
  }
}