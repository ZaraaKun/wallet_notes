import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screen/home_wallet.dart';

class WalletInfo extends StatelessWidget {
  final String walletName; // Ini harus String
  final double totalBalance;
  final NumberFormat currencyFormatter;
  final Function onEdit;
  final String lastTransactionType;

  WalletInfo({
    required this.walletName,
    required this.totalBalance,
    required this.currencyFormatter,
    required this.onEdit,
    required this.lastTransactionType,
  });

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400.0),
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'lib/images/walletbaground.png'), // Ganti dengan path gambar Anda
          fit: BoxFit.cover, // Mengatur gambar agar menutupi seluruh container
        ),
        borderRadius:
            BorderRadius.circular(12.0), // Radius sudut sesuai keinginan
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  walletName, // Gunakan walletName di sini
                  style: TextStyle(
                    fontFamily: 'AntipastoPro',
                    fontSize: textScaleFactor * 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () => onEdit(),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                currencyFormatter.format(totalBalance),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              // Show plus or minus icon based on the last transaction type
              if (lastTransactionType == 'income')
                Icon(
                  Icons.arrow_upward_rounded,
                  color: Color(0xff00ff08), // Green for income
                  size: 32,
                )
              else if (lastTransactionType == 'expense')
                Icon(
                  Icons.arrow_downward_rounded,
                  color: Color(0xffff1100), // Red for expense
                  size: 32,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
