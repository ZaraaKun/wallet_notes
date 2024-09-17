import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wallet/widget/wallet_name_manager.dart';
import 'screen/home_wallet.dart';
import 'transaction.dart'; // Import Transaction class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter for the Transaction class
  Hive.registerAdapter(TransactionAdapter());

  // Open the box
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<String>('walletName');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WalletHome(), // Make sure this matches the HomeWallet class
    );
  }
}
