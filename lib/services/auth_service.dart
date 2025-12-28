import 'package:shared_preferences/shared_preferences.dart';
import 'base_service.dart';

/// Authentication service for login, logout, and token management
class AuthService extends BaseService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userTypeKey = 'user_type';
  static const String _userNomKey = 'user_nom';
  static const String _userTelephoneKey = 'user_telephone';

  /// Login with email and password
  /// Returns user data with token on success, null on failure
  Future<Map<String, dynamic>?> login(String email, String motDePasse) async {
    try {
      final response = await post(
        '/utilisateurs/login',
        {
          'email': email,
          'motDePasse': motDePasse,
        },
        requireAuth: false,
      );

      if (response != null && response['token'] != null) {
        // Save token and user data
        await _saveUserData(response);
        // Set token for future requests
        setToken(response['token']);
        return response;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      rethrow;
    }
  }

  /// Register a new user
  /// Returns user data on success, null on failure
  Future<Map<String, dynamic>?> register({
    required String nom,
    required String email,
    required String motDePasse,
    required String type,
    String? telephone,
  }) async {
    try {
      final body = {
        'nom': nom,
        'email': email,
        'motDePasse': motDePasse,
        'type': type,
      };

      if (telephone != null && telephone.isNotEmpty) {
        body['telephone'] = telephone;
      }

      final response = await post(
        '/utilisateurs',
        body,
        requireAuth: false,
      );

      return response;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      rethrow;
    }
  }

  /// Logout - clear stored user data and token
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userTypeKey);
      await prefs.remove(_userNomKey);
      await prefs.remove(_userTelephoneKey);
      setToken(null);
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null) {
        setToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la vérification de connexion: $e');
      return false;
    }
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      
      if (token == null) {
        return null;
      }

      return {
        'id': prefs.getInt(_userIdKey),
        'email': prefs.getString(_userEmailKey),
        'type': prefs.getString(_userTypeKey),
        'nom': prefs.getString(_userNomKey),
        'telephone': prefs.getString(_userTelephoneKey),
        'token': token,
      };
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  /// Save user data to shared preferences
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, userData['token']);
      await prefs.setInt(_userIdKey, userData['id']);
      await prefs.setString(_userEmailKey, userData['email']);
      await prefs.setString(_userTypeKey, userData['type']);
      
      if (userData['nom'] != null) {
        await prefs.setString(_userNomKey, userData['nom']);
      }
      
      if (userData['telephone'] != null) {
        await prefs.setString(_userTelephoneKey, userData['telephone']);
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde des données utilisateur: $e');
    }
  }

  /// Get current user ID
  Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_userIdKey);
    } catch (e) {
      print('Erreur lors de la récupération de l\'ID utilisateur: $e');
      return null;
    }
  }

  /// Get current user type
  Future<String?> getUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTypeKey);
    } catch (e) {
      print('Erreur lors de la récupération du type utilisateur: $e');
      return null;
    }
  }
}
