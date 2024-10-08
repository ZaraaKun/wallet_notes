import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../widget/info_wallet.dart';
import '../widget/history_wallet.dart';
import '../widget/input_slide.dart';
import '../transaction.dart';
import '../widget/wallet_name_manager.dart';

class WalletHome extends StatefulWidget {
  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  late Future<void> _initHiveFuture;
  late Box<Transaction> _transactionBox;
  late Box<String> _walletBox; // Box untuk nama wallet
  double _totalBalance = 0.0;
  String _lastTransactionType = '';
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _initHiveFuture = _initHive();
  }

  Future<void> _initHive() async {
    _transactionBox = await Hive.openBox<Transaction>('transactions');
    _walletBox = await Hive.openBox<String>('walletName');

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
          title: Text(
            'Ubah Nama Wallet',
            style: TextStyle(fontFamily: 'AntipastoPro'),
          ),
          content: TextField(
            style: TextStyle(fontFamily: 'AntipastoPro'),
            controller: TextEditingController(
                text:
                    _walletBox.get('walletName', defaultValue: 'Nama Wallet')),
            decoration: InputDecoration(
              labelText: 'Wallet',
            ),
            onChanged: (value) {
              _walletBox.put('walletName', value);
            },
          ),
          actions: [
            TextButton(
              child:
                  Text(style: TextStyle(fontFamily: 'AntipastoPro'), 'Batal'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child:
                  Text(style: TextStyle(fontFamily: 'AntipastoPro'), 'Simpan'),
              onPressed: () {
                setState(() {}); // Update nama wallet
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

    return FutureBuilder(
      future: _initHiveFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0), // Atur tinggi yang diinginkan
            child: AppBar(
              title: Text('Wallet Notes'),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: ('AntipastoPro')),
              backgroundColor: Colors.purple,
              centerTitle: true,
            ),
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          children: [
                            WalletNameManager(),
                            WalletInfo(
                              walletName:
                                  _walletBox.get('walletName') ?? 'Nama Wallet',
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
                                    backgroundColor: Color(0xffa358ae),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Income',
                                    style: TextStyle(
                                        fontSize: textScaleFactor * 18,
                                        color: Colors.white,
                                        fontFamily: 'AntipastoPro'),
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
                                    style: TextStyle(
                                        fontSize: textScaleFactor * 18,
                                        fontFamily: 'AntipastoPro'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            HistoryList(
                              transactions: _transactionBox.values
                                  .toList()
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
      },
    );
  }
}
