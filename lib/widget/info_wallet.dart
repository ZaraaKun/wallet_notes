import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletInfo extends StatelessWidget {
  final TextEditingController walletNameController;
  final double totalBalance;
  final NumberFormat currencyFormatter;
  final Function onEdit;

  WalletInfo({
    required this.walletNameController,
    required this.totalBalance,
    required this.currencyFormatter,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 400.0),
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
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
          Text(
            '${currencyFormatter.format(totalBalance)}',
            style: TextStyle(
              fontSize: textScaleFactor * 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
