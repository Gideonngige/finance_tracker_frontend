import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobProvider with ChangeNotifier {
  List<dynamic> _jobs = [];
  List<dynamic> get jobs => _jobs;

  Future<void> fetchJobs() async {
    final url = 'https://finance-tracker-backend-5zm5.onrender.com/api/jobs/';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _jobs = json.decode(response.body);
      notifyListeners();
    }
  }

  Future<void> postJob(Map<String, dynamic> data, String token) async {
    final url = 'https://finance-tracker-backend-5zm5.onrender.com/api/jobs/';
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      fetchJobs(); // refresh
    }
  }

  Future<void> applyToJob(String jobId, String note, String token) async {
    final url = 'https://finance-tracker-backend-5zm5.onrender.com/api/jobs/$jobId/apply/';
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'note': note}),
    );
    if (response.statusCode == 200) {
      // success
    }
  }
}
