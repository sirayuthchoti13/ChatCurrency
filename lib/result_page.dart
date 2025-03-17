import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultPage extends StatefulWidget {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  const ResultPage({super.key, required this.amount, required this.fromCurrency, required this.toCurrency});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double? result;

  @override
  void initState() {
    super.initState();
    convertCurrency();
  }

  Future<void> convertCurrency() async {
    final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/${widget.fromCurrency}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final rates = json.decode(response.body)['rates'];
      setState(() {
        result = widget.amount * (rates[widget.toCurrency] ?? 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversion Result'),
        backgroundColor: Colors.green, // สีเขียวเข้มสำหรับแอปบาร์
      ),
      body: Container(
        color: Colors.white, // สีพื้นหลังขาว
        child: Center(
          child: result == null
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.amount} ${widget.fromCurrency} =',
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                    SizedBox(height: 8),
                    Text('${result!.toStringAsFixed(2)} ${widget.toCurrency}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen, // ปุ่มสีเขียวอ่อน
                        foregroundColor: Colors.white, // ฟอนต์สีขาว
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Convert Again'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
