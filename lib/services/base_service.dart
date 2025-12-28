import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base service class for making HTTP requests to the API
/// Provides reusable methods for GET, POST, PUT, DELETE operations
class BaseService {
  // Base URL of the API - change according to your environment
  static const String baseUrl = 'http://localhost:3000/api';

  // Token for authentication
  String? _token;

  // Set authentication token
  void setToken(String? token) {
    _token = token;
  }

  // Get authentication token
  String? getToken() {
    return _token;
  }

  // Get headers with optional authentication
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  /// Generic GET request
  /// [endpoint] - API endpoint path (e.g., '/users', '/children')
  /// [requireAuth] - whether authentication is required (default: true)
  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Generic POST request
  /// [endpoint] - API endpoint path
  /// [body] - request body data
  /// [requireAuth] - whether authentication is required (default: true)
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requireAuth = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Generic PUT request
  /// [endpoint] - API endpoint path
  /// [body] - request body data
  /// [requireAuth] - whether authentication is required (default: true)
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requireAuth = true,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Generic DELETE request
  /// [endpoint] - API endpoint path
  /// [requireAuth] - whether authentication is required (default: true)
  Future<dynamic> delete(String endpoint, {bool requireAuth = true}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _getHeaders(includeAuth: requireAuth),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Handle API response and throw appropriate errors
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Non autorisé - veuillez vous reconnecter');
    } else if (response.statusCode == 403) {
      throw Exception('Accès refusé');
    } else if (response.statusCode == 404) {
      throw Exception('Ressource non trouvée');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur serveur');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Erreur inconnue');
    }
  }
}
