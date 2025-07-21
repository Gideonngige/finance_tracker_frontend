import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class ApiService{
  static const String baseUrl = 'https://finance-tracker-backend-5zm5.onrender.com/api';

  static Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // login
  static Future<String?> login(String email, String password) async{
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email':email, 'password':password}),
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      String token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    }
    else{
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // register
  static Future<void> register(String email, String password) async{
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({'email':email, 'password':password}),
    );

    if(response.statusCode != 201){
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // fetch Transactions
  static Future<List<Transaction>> fetchTransactions() async{
    final token = await getToken();
    final url = Uri.parse('$baseUrl/transactions');
    final response = await http.get(
      url,
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token',
      },
    );

    if(response.statusCode == 200){
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    }
    else{
      throw Exception('Failed to fetch transactions: ${response.body}');
    }
  }

  // Add Transaction
  static Future<void> addTransaction(Transaction transaction) async{
    final token = await getToken();
    final url = Uri.parse('$baseUrl/transactions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type':'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaction.toJson()),
      );
    
    if(response.statusCode != 201){
      print('Failed to add transaction: ${response.body}');
      throw Exception('Failed to add transaction: ${response.body}');
    }
  }

  // delete Transactio
  static Future<void> deleteTransaction(String id) async{
    final token = await getToken();
    final url = Uri.parse('$baseUrl/transactions/$id');
    final response = await http.delete(
      url, 
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token',
      },
    );

    if(response.statusCode != 200){
      throw Exception('Failed to delete transaction: ${response.body}');
    }
  }
}