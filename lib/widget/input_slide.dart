import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class InputSlide extends StatefulWidget {
  final String type;
  final Function(double amount, String description) onSubmit;

  InputSlide({required this.type, required this.onSubmit});

  @override
  _InputSlideState createState() => _InputSlideState();
}

class _InputSlideState extends State<InputSlide> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final NumberFormat currencyFormatter = NumberFormat.decimalPattern('id');

  void _formatInput(String value) {
    String newValue = value.replaceAll('.', '');
    if (newValue.isNotEmpty) {
      _amountController.value = TextEditingValue(
        text: NumberFormat.decimalPattern('id').format(int.parse(newValue)),
        selection: TextSelection.fromPosition(
            TextPosition(offset: _amountController.text.length)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.type == 'income'
                  ? 'Tambah Pemasukan'
                  : 'Tambah Pengeluaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            SizedBox(
              width: 200.0, // Ganti dengan lebar yang diinginkan
              height: 60.0, // Ganti dengan tinggi yang diinginkan
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  prefixText: 'Rp. ', // Prefix untuk 'Rp'
                  hintText: 'Jumlah Uang',
                  prefixStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold), // Warna prefix

                  border: InputBorder.none, // Menghapus outline border
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  filled: true,
                  fillColor: Color(0xffffffff), // Warna latar belakang input
                ),
                onChanged: _formatInput,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text(widget.type == 'income' ? 'Tambah In' : 'Tambah Out'),
              onPressed: () {
                final String formattedAmount =
                    _amountController.text.replaceAll('.', '');
                final double amount = double.tryParse(formattedAmount) ?? 0.0;
                final String description = _descriptionController.text;

                if (amount <= 0 || description.isEmpty) {
                  return;
                }

                widget.onSubmit(amount, description);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Tap to open'),
      ),
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      minHeight: 350.0, // Setengah dari layar
    );
  }
}
