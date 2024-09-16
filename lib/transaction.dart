import 'package:hive/hive.dart';

part 'transaction.g.dart'; // File yang dihasilkan oleh build runner

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String date;

  Transaction({
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'description': description,
      'date': date,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      type: map['type'],
      amount: map['amount'],
      description: map['description'],
      date: map['date'],
    );
  }
}
