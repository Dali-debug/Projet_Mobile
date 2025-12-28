import 'package:flutter/material.dart';
import '../models/utilisateur.dart';
import '../models/nursery.dart';
import '../services/chat_service.dart';
import '../services/api_service.dart';

enum ScreenType {
  welcome,
  auth,
  parentDashboard,
  nurseryDashboard,
  nurserySetup,
  search,
  nurseryDetails,
}

class AppState extends ChangeNotifier {
  ScreenType _currentScreen = ScreenType.auth;
  Utilisateur? _user;
  Nursery? _selectedNursery;
  final ChatService _chatService = ChatService();

  ScreenType get currentScreen => _currentScreen;
  Utilisateur? get user => _user;
  Nursery? get selectedNursery => _selectedNursery;
  ChatService get chatService => _chatService;

  int get unreadMessagesCount {
    if (_user == null) return 0;
    return _chatService.getTotalMessagesNonLus(_user!.id.toString());
  }

  void setScreen(ScreenType screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setUser(Utilisateur user) async {
    _user = user;
    if (user.type == UtilisateurType.parent) {
      _currentScreen = ScreenType.parentDashboard;
    } else {
      // Vérifier si le directeur/garderie a déjà configuré sa garderie
      final garderie = await ApiService.getGarderieByDirecteur(user.id);
      if (garderie != null) {
        // Garderie déjà configurée, aller au dashboard
        _currentScreen = ScreenType.nurseryDashboard;
      } else {
        // Nouvelle garderie, aller au setup
        _currentScreen = ScreenType.nurserySetup;
      }
    }
    notifyListeners();
  }

  void completeNurserySetup() {
    _currentScreen = ScreenType.nurseryDashboard;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _currentScreen = ScreenType.auth;
    notifyListeners();
  }

  void selectNursery(Nursery nursery) {
    _selectedNursery = nursery;
    _currentScreen = ScreenType.nurseryDetails;
    notifyListeners();
  }
}
