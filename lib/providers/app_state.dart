import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/nursery.dart';

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
  User? _user;
  Nursery? _selectedNursery;

  ScreenType get currentScreen => _currentScreen;
  User? get user => _user;
  Nursery? get selectedNursery => _selectedNursery;

  void setScreen(ScreenType screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    if (user.type == UserType.parent) {
      _currentScreen = ScreenType.parentDashboard;
    } else {
      // Nursery users go to setup screen first
      _currentScreen = ScreenType.nurserySetup;
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
