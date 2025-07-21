import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier{
  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  double get totalIncome => _transactions.where((tx) => tx.amount > 0).fold(0.0, (sum, tx) => sum + tx.amount);

  double get totalExpenses => _transactions.where((tx) => tx.amount < 0).fold(0.0, (sum, tx) => sum + tx.amount.abs());

  double get balance => totalIncome - totalExpenses;

  void setTransactions(List<Transaction>transactions){
    _transactions = transactions;
    notifyListeners();
  }

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void removeTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    notifyListeners();
  }
}