import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletInfo extends StatelessWidget {
  final TextEditingController walletNameController;
  final double totalBalance;
  final NumberFormat currencyFormatter;
  final Function onEdit;
  final String lastTransactionType;

  WalletInfo({
    required this.walletNameController,
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
                  walletNameController.text,
                  style: TextStyle(
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
          SizedBox(height: 8.0),
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
                  Icons.add_circle,
                  color: Colors.green, // Green for income
                  size: 32,
                )
              else if (lastTransactionType == 'expense')
                Icon(
                  Icons.remove_circle,
                  color: Colors.red, // Red for expense
                  size: 32,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
