import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_numeric_keyboard/flutter_numeric_keyboard.dart';

class InputSlide extends StatefulWidget {
  final String type;
  final Function(double amount, String description) onSubmit;
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  InputSlide({required this.type, required this.onSubmit});

  @override
  _InputSlideState createState() => _InputSlideState();
}

class _InputSlideState extends State<InputSlide> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final PanelController _panelController = PanelController();

  void _formatInput(String value) {
    // Menghapus semua karakter non-digit dari input, kecuali titik (untuk pemisah ribuan)
    String newValue = value.replaceAll(RegExp(r'[^\d]'), '');

    // Memformat nilai baru jika ada isinya
    if (newValue.isNotEmpty) {
      // Mengubah string baru menjadi integer dan memformatnya
      String formattedValue =
          NumberFormat.decimalPattern('id').format(int.parse(newValue));

      // Menentukan posisi kursor yang baru
      int cursorPosition = _amountController.selection.baseOffset;
      if (cursorPosition > formattedValue.length) {
        cursorPosition = formattedValue.length;
      }

      _amountController.value = TextEditingValue(
        text: formattedValue,
        selection:
            TextSelection.fromPosition(TextPosition(offset: cursorPosition)),
      );
    } else {
      // Jika tidak ada nilai, kosongkan field
      _amountController.value = TextEditingValue(
        text: '',
        selection: TextSelection.fromPosition(TextPosition(offset: 0)),
      );
    }
  }

  void _submit() {
    final String rawAmount =
        _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
    final double amount = double.tryParse(rawAmount) ?? 0.0;
    final String description = _descriptionController.text;

    if (amount <= 0 || description.isEmpty) {
      return;
    }

    widget.onSubmit(amount, description);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: _panelController,
      panel: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.type == 'income'
                  ? 'Tambah Pemasukan'
                  : 'Tambah Pengeluaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            SizedBox(
              width: 200.0,
              height: 60.0,
              child: Row(
                children: [
                  Text(
                    'Rp',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xffbab4b4),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      focusNode: widget._amountFocusNode,
                      keyboardType: TextInputType.number,
                      readOnly: true, // Agar tidak muncul keyboard bawaan
                      style: TextStyle(fontSize: 20.0),
                      decoration: InputDecoration(
                          hintText: 'Jumlah Uang',
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          filled: true,
                          fillColor: Color(0xffffffff).withOpacity(0.3)),
                      onSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(widget._descriptionFocusNode);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            TextField(
              controller: _descriptionController,
              focusNode: widget._descriptionFocusNode,
              decoration: InputDecoration(
                hintText: 'Deskripsi',
                labelStyle: TextStyle(fontSize: 14.0),
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              style: TextStyle(fontSize: 14.0),
              onSubmitted: (value) {
                _submit();
              },
            ),
            SizedBox(height: 10.0),
            FlutterNumericKeyboard(
              width: 800,
              height: 200,
              showResult: false,
              resultFunction: (value) {
                _formatInput(value);
              },
              rightIconBack: Icon(
                Icons.backspace,
                color: Colors.blueGrey,
              ),
              leftIconReset: Icon(
                Icons.refresh,
                color: Colors.blueGrey,
              ),
              showRightIcon: true,
              showLeftIcon: true,
              backgroundColor: Colors.white,
              backgroundRadius: 20,
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              child: Text(widget.type == 'income' ? 'Tambah In' : 'Tambah Out'),
              onPressed: _submit,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Tap to open'),
      ),
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      minHeight: 500.0, // Set this to the height you want
      maxHeight: 900.0, // Set this to the height you want

      onPanelSlide: (position) {
        if (position > 0.5) {
          _panelController
              .animatePanelToPosition(0.50); // Adjust this value as needed
        }
      },
    );
  }
}
