import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class WalletNameManager extends StatefulWidget {
  @override
  _WalletNameManagerState createState() => _WalletNameManagerState();
}

class _WalletNameManagerState extends State<WalletNameManager> {
  late final Box walletBox;
  final TextEditingController _walletNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeWalletBox();
  }

  Future<void> _initializeWalletBox() async {
    walletBox = await Hive.openBox<String>('walletName');

    _loadWalletName();
  }

  void _loadWalletName() {
    String? savedWalletName = walletBox.get('walletName');
    _walletNameController.text = savedWalletName ?? 'Nama Wallet';
  }

  void _saveWalletName() {
    walletBox.put('walletName', _walletNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
