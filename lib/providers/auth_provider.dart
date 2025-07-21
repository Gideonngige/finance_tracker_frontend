import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier{
  String? _token;
  bool get isAuthenticated => _token != null;

  Future<void> login(String token) async{
    _token = token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    notifyListeners();
  }

  Future<void> logout() async{
    _token = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('token')) return;
    _token = prefs.getString('token');
    notifyListeners();
  }
}