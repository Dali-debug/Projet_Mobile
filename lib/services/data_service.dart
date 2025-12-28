import 'base_service.dart';

/// Data service for fetching children, activities, and other data
class DataService extends BaseService {
  // ============= ENFANTS (CHILDREN) =============

  /// Get all children
  Future<List<Map<String, dynamic>>> getAllEnfants() async {
    try {
      final response = await get('/enfants');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des enfants: $e');
      rethrow;
    }
  }

  /// Get children by parent ID
  Future<List<Map<String, dynamic>>> getEnfantsByParent(int parentId) async {
    try {
      final response = await get('/enfants/by-parent/$parentId');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des enfants du parent: $e');
      rethrow;
    }
  }

  /// Get children by garderie ID
  Future<List<Map<String, dynamic>>> getEnfantsByGarderie(
      int garderieId) async {
    try {
      final response = await get('/enfants/by-garderie/$garderieId');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des enfants de la garderie: $e');
      rethrow;
    }
  }

  /// Get child by ID
  Future<Map<String, dynamic>?> getEnfantById(int id) async {
    try {
      final response = await get('/enfants/$id');
      return response;
    } catch (e) {
      print('Erreur lors de la récupération de l\'enfant: $e');
      rethrow;
    }
  }

  /// Create a new child
  Future<Map<String, dynamic>?> createEnfant({
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

      final response = await post('/enfants', body);
      return response;
    } catch (e) {
      print('Erreur lors de la création de l\'enfant: $e');
      rethrow;
    }
  }

  /// Update child
  Future<Map<String, dynamic>?> updateEnfant({
    required int id,
    required String nom,
    required int age,
  }) async {
    try {
      final response = await put(
        '/enfants/$id',
        {
          'nom': nom,
          'age': age,
        },
      );
      return response;
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'enfant: $e');
      rethrow;
    }
  }

  /// Delete child
  Future<bool> deleteEnfant(int id) async {
    try {
      await delete('/enfants/$id');
      return true;
    } catch (e) {
      print('Erreur lors de la suppression de l\'enfant: $e');
      return false;
    }
  }

  // ============= ACTIVITES (ACTIVITIES) =============

  /// Get all activities
  Future<List<Map<String, dynamic>>> getAllActivites() async {
    try {
      final response = await get('/activites');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des activités: $e');
      rethrow;
    }
  }

  /// Get activity by ID
  Future<Map<String, dynamic>?> getActiviteById(int id) async {
    try {
      final response = await get('/activites/$id');
      return response;
    } catch (e) {
      print('Erreur lors de la récupération de l\'activité: $e');
      rethrow;
    }
  }

  /// Create a new activity
  Future<Map<String, dynamic>?> createActivite({
    required String titre,
    required String description,
  }) async {
    try {
      final response = await post(
        '/activites',
        {
          'titre': titre,
          'description': description,
        },
      );
      return response;
    } catch (e) {
      print('Erreur lors de la création de l\'activité: $e');
      rethrow;
    }
  }

  /// Update activity
  Future<Map<String, dynamic>?> updateActivite({
    required int id,
    required String titre,
    required String description,
  }) async {
    try {
      final response = await put(
        '/activites/$id',
        {
          'titre': titre,
          'description': description,
        },
      );
      return response;
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'activité: $e');
      rethrow;
    }
  }

  /// Delete activity
  Future<bool> deleteActivite(int id) async {
    try {
      await delete('/activites/$id');
      return true;
    } catch (e) {
      print('Erreur lors de la suppression de l\'activité: $e');
      return false;
    }
  }

  // ============= PAIEMENTS (PAYMENTS) =============

  /// Get all payments
  Future<List<Map<String, dynamic>>> getAllPaiements() async {
    try {
      final response = await get('/paiements');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des paiements: $e');
      rethrow;
    }
  }

  /// Get payments by parent ID
  Future<List<Map<String, dynamic>>> getPaiementsByParent(int parentId) async {
    try {
      final response = await get('/paiements/by-parent/$parentId');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des paiements du parent: $e');
      rethrow;
    }
  }

  /// Get payments by status
  Future<List<Map<String, dynamic>>> getPaiementsByStatus(
      String statut) async {
    try {
      final response = await get('/paiements/by-status/$statut');
      if (response is List) {
        return response.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Erreur lors de la récupération des paiements par statut: $e');
      rethrow;
    }
  }

  /// Create a new payment
  Future<Map<String, dynamic>?> createPaiement({
    required double montant,
    required String datePaiement,
    required String statut,
    int? parentId,
    int? enfantId,
    int? garderieId,
  }) async {
    try {
      final body = {
        'montant': montant,
        'datePaiement': datePaiement,
        'statut': statut,
      };

      if (parentId != null) {
        body['parent_id'] = parentId;
      }

      if (enfantId != null) {
        body['enfant_id'] = enfantId;
      }

      if (garderieId != null) {
        body['garderie_id'] = garderieId;
      }

      final response = await post('/paiements', body);
      return response;
    } catch (e) {
      print('Erreur lors de la création du paiement: $e');
      rethrow;
    }
  }
}
