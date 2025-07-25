import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier{
  String? _token;
  String? userEmail;
  bool get isAuthenticated => _token != null;

  String? get token => _token;

  Future<void> login(String token, String email) async{
    _token = token;
    userEmail = email;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('email', email);
    notifyListeners();
  }

  Future<void> logout() async{
    _token = null;
    userEmail = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('token')) return;
    _token = prefs.getString('token');
     userEmail = prefs.getString('email');
    notifyListeners();
  }
}