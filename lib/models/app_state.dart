import 'package:flutter/material.dart';
import 'package:flutterproject/models/user.dart';

class AppState with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  void setCurrentUser(User? user) {
    _currentUser = user;
    notifyListeners();  
  }
}
