import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../widget/info_wallet.dart';
import '../widget/history_wallet.dart';
import '../widget/input_slide.dart';
import '../transaction.dart'; // Import Transaction class

class WalletHome extends StatefulWidget {
  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  late Future<void> _initHiveFuture;
  late Box<Transaction> _transactionBox;
  double _totalBalance = 0.0;
  String _lastTransactionType = '';
  final TextEditingController _walletNameController =
      TextEditingController(text: 'Nama Wallet');

  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _transactionBox = await Hive.openBox<Transaction>('transactions');
    _loadTransactions();
  }

  void _loadTransactions() {
    final transactions = _transactionBox.values.toList();
    setState(() {
      _totalBalance = transactions.fold(0.0, (sum, transaction) {
        return transaction.type == 'income'
            ? sum + transaction.amount
            : sum - transaction.amount;
      });
    });
  }

  void _saveTransaction(Transaction transaction) {
    _transactionBox.add(transaction);
    _loadTransactions();
  }

  void _recalculateBalance() {
    final transactions = _transactionBox.values.toList();
    setState(() {
      _totalBalance = transactions.fold(0.0, (sum, transaction) {
        return transaction.type == 'income'
            ? sum + transaction.amount
            : sum - transaction.amount;
      });
    });
  }

  void _showInputSlide(String type) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return InputSlide(
          type: type,
          onSubmit: (amount, description) {
            final transaction = Transaction(
              type: type,
              amount: amount,
              description: description,
              date: DateFormat('yyyy-MM-dd | HH:mm').format(DateTime.now()),
            );
            _saveTransaction(transaction);
            setState(() {
              _lastTransactionType = type;
            });
          },
        );
      },
    );
  }

  void _editWalletName() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Ubah Nama Wallet'),
          content: TextField(
            controller: _walletNameController,
            decoration: InputDecoration(
              labelText: 'Nama Wallet',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () {
                setState(() {});
                Navigator.of(ctx).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        );
      },
    );
  }

  void _deleteTransaction(int index) {
    setState(() {
      _transactionBox.deleteAt(index);
      _recalculateBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet Notes'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      children: [
                        WalletInfo(
                          walletNameController: _walletNameController,
                          totalBalance: _totalBalance,
                          currencyFormatter: currencyFormatter,
                          onEdit: _editWalletName,
                          lastTransactionType: _lastTransactionType,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () => _showInputSlide('income'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Income',
                                style:
                                    TextStyle(fontSize: textScaleFactor * 18),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _showInputSlide('expense'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Outcome',
                                style:
                                    TextStyle(fontSize: textScaleFactor * 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        HistoryList(
                          transactions: _transactionBox.values
                              .toList() // Ensure toList() is used here
                              .map((transaction) => transaction.toMap())
                              .toList(),
                          currencyFormatter: currencyFormatter,
                          deleteTransaction: _deleteTransaction,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'made by kudou and AI',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
