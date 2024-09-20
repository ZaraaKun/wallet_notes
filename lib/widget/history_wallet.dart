import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final NumberFormat currencyFormatter;
  final Function deleteTransaction;
  final double screenWidth;
  final double screenHeight;

  HistoryList({
    required this.transactions,
    required this.currencyFormatter,
    required this.deleteTransaction,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  //Kotak History anjai gw lupa mulu
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: screenHeight * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'History',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2e2d2d),
                ),
              ),
            ),
            //
            //
            //List history
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (ctx, index) {
                  final transaction = transactions.reversed.toList()[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    //
                    //
                    //Nama History
                    child: ListTile(
                      title: Text(
                        transaction['description'],
                        style: TextStyle(
                            color: transaction['type'] == 'income'
                                ? Colors.green
                                : Colors.red,
                            fontSize:
                                MediaQuery.of(context).textScaleFactor * 16,
                            fontFamily: 'AntipastoPro'),
                      ),
                      //
                      //
                      //Jumlah duit yg dikeluarin dan tanggal
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currencyFormatter.format(transaction['amount']),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 14,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '${transaction['date']}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 14,
                            ),
                          ),
                        ],
                      ),

                      //
                      //
                      //
                      //
                      //Button buat hapus
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          //Konfirmasi
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(
                                  style: TextStyle(fontFamily: 'AntipastoPro'),
                                  'Konfirmasi Hapus'),
                              content: Text(
                                  style: TextStyle(fontFamily: 'AnripastoPro'),
                                  'Yakin ingin menghapus History ini?'),
                              actions: [
                                //Batal
                                TextButton(
                                  child: Text(
                                      style:
                                          TextStyle(fontFamily: 'AnripastoPro'),
                                      'Batal'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(Color(
                                            0xff000000)), // Warna teks // Mengatur warna latar belakang
                                  ),
                                ),
                                //Apus
                                ElevatedButton(
                                  child: Text(
                                      style:
                                          TextStyle(fontFamily: 'AnripastoPro'),
                                      'Hapus'),
                                  onPressed: () {
                                    deleteTransaction(transactions.length -
                                        1 -
                                        index); // Menghapus transaksi
                                    Navigator.of(ctx)
                                        .pop(); // Tutup setelah diapus
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffffffff)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
