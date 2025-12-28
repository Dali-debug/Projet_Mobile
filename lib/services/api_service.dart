import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/utilisateur.dart';
import '../models/garderie.dart';
import '../models/enfant.dart';
import '../models/message.dart';

class ApiService {
  // URL de base de l'API - changez selon votre configuration
  static const String baseUrl = 'http://localhost:3000/api';

  // Headers par défaut
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
      };

  // ============= UTILISATEURS =============

  // Authentification
  static Future<Map<String, dynamic>?> login(
      String email, String motDePasse) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/utilisateurs/login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'motDePasse': motDePasse,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de l\'authentification: $e');
      return null;
    }
  }

  // Créer un utilisateur
  static Future<Map<String, dynamic>?> createUtilisateur({
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

      final response = await http.post(
        Uri.parse('$baseUrl/utilisateurs'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la création de l\'utilisateur: $e');
      return null;
    }
  }

  // Obtenir un utilisateur par ID
  static Future<Map<String, dynamic>?> getUtilisateur(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/utilisateurs/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  // ============= GARDERIES =============

  // Obtenir toutes les garderies
  static Future<List<Map<String, dynamic>>> getGarderies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/garderies'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des garderies: $e');
      return [];
    }
  }

  // Obtenir une garderie par ID
  static Future<Map<String, dynamic>?> getGarderie(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/garderies/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de la garderie: $e');
      return null;
    }
  }

  // Obtenir la garderie d'un directeur
  static Future<Map<String, dynamic>?> getGarderieByDirecteur(
      int directeurId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/garderies/by-directeur/$directeurId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de la garderie du directeur: $e');
      return null;
    }
  }

  // Créer une garderie
  static Future<Map<String, dynamic>?> createGarderie({
    required String nom,
    required String adresse,
    required double tarif,
    required double disponibilite,
    required String description,
    int? directeurId,
    String? photo,
    int? nombrePlaces,
  }) async {
    try {
      final body = {
        'nom': nom,
        'adresse': adresse,
        'tarif': tarif,
        'disponibilite': disponibilite,
        'description': description,
      };
      
      if (directeurId != null) {
        body['directeur_id'] = directeurId;
      }
      
      if (photo != null && photo.isNotEmpty) {
        body['photo'] = photo;
      }
      
      if (nombrePlaces != null) {
        body['nombre_places'] = nombrePlaces;
      }      final response = await http.post(
        Uri.parse('$baseUrl/garderies'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la création de la garderie: $e');
      return null;
    }
  }

  // Mettre à jour une garderie
  static Future<Map<String, dynamic>?> updateGarderie({
    required int id,
    required String nom,
    required String adresse,
    required double tarif,
    required double disponibilite,
    required String description,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/garderies/$id'),
        headers: headers,
        body: jsonEncode({
          'nom': nom,
          'adresse': adresse,
          'tarif': tarif,
          'disponibilite': disponibilite,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la mise à jour de la garderie: $e');
      return null;
    }
  }

  // ============= ENFANTS =============

  // Obtenir tous les enfants
  static Future<List<Map<String, dynamic>>> getEnfants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des enfants: $e');
      return [];
    }
  }

  // Obtenir les enfants d'un parent
  static Future<List<Map<String, dynamic>>> getEnfantsByParent(int parentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants/by-parent/$parentId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des enfants du parent: $e');
      return [];
    }
  }

  // Obtenir les enfants d'une garderie
  static Future<List<Map<String, dynamic>>> getEnfantsByGarderie(int garderieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/enfants/by-garderie/$garderieId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des enfants de la garderie: $e');
      return [];
    }
  }

  // Créer un enfant
  static Future<Map<String, dynamic>?> createEnfant({
    required String nom,
    required int age,
    int? parentId,
    int? garderieId,
  }) async {
    try {
      final body = {
        'nom': nom,
        'age': age,
      };
      
      if (parentId != null) {
        body['parent_id'] = parentId;
      }
      
      if (garderieId != null) {
        body['garderie_id'] = garderieId;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/enfants'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la création de l\'enfant: $e');
      return null;
    }
  }

  // ============= MESSAGES =============

  // Obtenir les messages d'une conversation
  static Future<List<Map<String, dynamic>>> getConversation(
      String expediteurId, String destinataireId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/messages/conversation/$expediteurId/$destinataireId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des messages: $e');
      return [];
    }
  }

  // Créer un message
  static Future<Map<String, dynamic>?> createMessage({
    required String id,
    required String expediteurId,
    required String destinataireId,
    required String contenu,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/messages'),
        headers: headers,
        body: jsonEncode({
          'id': id,
          'expediteurId': expediteurId,
          'destinataireId': destinataireId,
          'contenu': contenu,
          'dateEnvoi': DateTime.now().toIso8601String(),
          'estLu': false,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la création du message: $e');
      return null;
    }
  }

  // Marquer un message comme lu
  static Future<bool> markMessageAsRead(String messageId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/messages/$messageId/lu'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors du marquage du message: $e');
      return false;
    }
  }
}
