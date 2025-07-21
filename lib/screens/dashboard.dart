// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../services/api_service.dart';
import '../models/transaction.dart';
import './addtransaction.dart';
import './login.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await ApiService.fetchTransactions();
      Provider.of<TransactionProvider>(context, listen: false)
          .setTransactions(transactions);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildBalanceCards(transactionProvider),
              const SizedBox(height: 16),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _buildTransactionList(transactions),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddTransactionScreen()),
          );
          _loadTransactions();
        },
        child: Icon(Icons.add),
        tooltip: 'Add Transaction',
      ),
    );
  }

  Widget _buildBalanceCards(TransactionProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCard('Balance', provider.balance, Colors.blue),
        _buildCard('Income', provider.totalIncome, Colors.green),
        _buildCard('Expenses', provider.totalExpenses, Colors.red),
      ],
    );
  }

  Widget _buildCard(String title, double amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'KES ${amount.toStringAsFixed(2)}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('No transactions yet.', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: transactions.length,
  itemBuilder: (ctx, index) {
    final tx = transactions[index];
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tx.amount >= 0 ? Colors.green : Colors.red,
          child: Icon(
            tx.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(tx.title),
        subtitle: Text(
            '${tx.category} • ${tx.date.toLocal().toString().split(' ')[0]}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'KES ${tx.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: tx.amount >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Delete Transaction'),
                    content: Text('Are you sure you want to delete this transaction?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await ApiService.deleteTransaction(tx.id);
                    Provider.of<TransactionProvider>(context, listen: false)
                        .removeTransaction(tx.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Transaction deleted.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  },
);

  }
}
