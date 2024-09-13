import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widget/info_wallet.dart';
import '../widget/history_wallet.dart';
import '../widget/input_slide.dart';

class WalletHome extends StatefulWidget {
  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  final List<Map<String, dynamic>> _transactions = [];
  double _totalBalance = 0.0;
  final TextEditingController _walletNameController =
      TextEditingController(text: 'Nama Wallet');

  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  void _showInputSlide(String type) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return InputSlide(
          type: type,
          onSubmit: (amount, description) {
            setState(() {
              _transactions.add({
                'type': type,
                'amount': amount,
                'description': description,
                'date': DateFormat('yyyy-MM-dd | HH:mm').format(DateTime.now()),
              });

              if (type == 'income') {
                _totalBalance += amount;
              } else if (type == 'expense') {
                _totalBalance -= amount;
              }
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
      final transaction = _transactions[index];

      if (transaction['type'] == 'income') {
        _totalBalance -= transaction['amount'];
      } else if (transaction['type'] == 'expense') {
        _totalBalance += transaction['amount'];
      }

      _transactions.removeAt(index);
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
        backgroundColor: Color(0xffbb78d5),
      ),
      body: LayoutBuilder(
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
                              style: TextStyle(fontSize: textScaleFactor * 18),
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
                              style: TextStyle(fontSize: textScaleFactor * 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      HistoryList(
                        transactions: _transactions,
                        currencyFormatter: currencyFormatter,
                        deleteTransaction: _deleteTransaction,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
