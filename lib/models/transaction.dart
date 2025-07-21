class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json){
    return Transaction(
      id: json['_id'], 
      title: json['title'], 
      amount: double.parse(json['amount'].toString()), 
      category: json['category'], 
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'title':title,
      'amount':amount,
      'category':category,
      'date': date.toIso8601String(),
    };
  }
}