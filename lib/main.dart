import 'package:flutter/material.dart';
import 'screen/home_wallet.dart';

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
