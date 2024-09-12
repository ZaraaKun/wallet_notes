import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import library intl untuk format Rupiah

void main() {
  runApp(WalletApp());
}

class WalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Digital',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: WalletHome(),
    );
  }
}

class WalletHome extends StatefulWidget {
  @override
  _WalletHomeState createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  final List<Map<String, dynamic>> _transactions = [];
  double _totalBalance = 0.0; // Variable untuk menyimpan total uang
  final TextEditingController _walletNameController = TextEditingController(
      text: 'Nama Wallet'); // Controller untuk nama wallet

  // Formatter untuk Rupiah
  final NumberFormat currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

  void _showInputDialog(String type) {
    showDialog(
      context: context,
      builder: (ctx) {
        final TextEditingController _amountController = TextEditingController();
        final TextEditingController _descriptionController =
            TextEditingController();

        return AlertDialog(
          title: Text(
              type == 'income' ? 'Tambah Pemasukan' : 'Tambah Pengeluaran'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                ),
                onChanged: (value) => _formatInput(value, _amountController),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child: Text(type == 'income' ? 'Tambah In' : 'Tambah Out'),
              onPressed: () {
                final String formattedAmount =
                    _amountController.text.replaceAll('.', '');
                final double amount = double.tryParse(formattedAmount) ?? 0.0;
                final String description = _descriptionController.text;

                if (amount <= 0 || description.isEmpty) {
                  return;
                }

                setState(() {
                  _transactions.add({
                    'type': type,
                    'amount': amount,
                    'description': description,
                    'date':
                        DateFormat('yyyy-MM-dd | HH:mm').format(DateTime.now())
                  });

                  // Update total balance based on the transaction type
                  if (type == 'income') {
                    _totalBalance += amount; // Tambah jika pemasukan
                  } else if (type == 'expense') {
                    _totalBalance -= amount; // Kurangi jika pengeluaran
                  }
                });

                Navigator.of(ctx).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Mengatur border radius
          ),
        );
      },
    );
  }

  void _deleteTransaction(int index) {
    setState(() {
      final transaction = _transactions[index];

      // Update total balance ketika transaksi dihapus
      if (transaction['type'] == 'income') {
        _totalBalance -= transaction['amount'];
      } else if (transaction['type'] == 'expense') {
        _totalBalance += transaction['amount'];
      }

      _transactions.removeAt(index);
    });
  }

  // Fungsi untuk memformat angka menjadi format Rupiah saat mengetik
  void _formatInput(String value, TextEditingController controller) {
    // Menghilangkan titik dan memformat kembali
    String newValue = value.replaceAll('.', '');
    if (newValue.isNotEmpty) {
      controller.value = TextEditingValue(
        text: NumberFormat.decimalPattern('id').format(int.parse(newValue)),
        selection: TextSelection.fromPosition(
            TextPosition(offset: controller.text.length)),
      );
    }
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
                setState(() {
                  // Update nama wallet
                });
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet Notes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                      Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 400.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 24.0,
                          horizontal: 20.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _walletNameController.text,
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white),
                                  onPressed: _editWalletName,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '${currencyFormatter.format(_totalBalance)}',
                              style: TextStyle(
                                fontSize: textScaleFactor * 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => _showInputDialog('income'),
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
                            onPressed: () => _showInputDialog('expense'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Outcome',
                              style: TextStyle(fontSize: textScaleFactor * 18),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.0)),
                        height: constraints.maxHeight * 0.6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'History',
                                  style: TextStyle(
                                    fontSize: textScaleFactor * 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2e2d2d),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _transactions.length,
                                  itemBuilder: (ctx, index) {
                                    final transaction =
                                        _transactions.reversed.toList()[index];
                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05,
                                        vertical: screenHeight * 0.01,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          transaction['description'],
                                          style: TextStyle(
                                            color:
                                                transaction['type'] == 'income'
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontSize: textScaleFactor * 16,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${currencyFormatter.format(transaction['amount'])} - ${transaction['date']}',
                                          style: TextStyle(
                                              fontSize: textScaleFactor * 14),
                                        ),
                                        trailing: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _deleteTransaction(index),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
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
