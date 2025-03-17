import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConvertPage extends StatefulWidget {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final List<String> historyList;

  const ConvertPage({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.historyList,
  });

  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  double? result;
  bool isLoading = true; // เพิ่ม state สำหรับโหลดข้อมูล

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
        isLoading = false; // หยุดโหลดเมื่อได้ค่า
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ผลการแปลงสกุลเงิน',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold, // ตัวหนา
            color: Colors.white, // สีขาว
          ),
        ),
        backgroundColor: Colors.green, // พื้นหลัง AppBar สีเขียว
      ),
      backgroundColor: Colors.white, // พื้นหลังแอปสีขาว
      body: Center(
        child: isLoading
            ? CircularProgressIndicator(color: Colors.green) // แสดง Loading
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.amount} ${widget.fromCurrency} =',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '${result!.toStringAsFixed(2)} ${widget.toCurrency}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold, // ตัวหนา
                      color: Colors.lightGreen, // สีขาว
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      widget.historyList.add(
                          '${widget.amount} ${widget.fromCurrency} -> ${result!.toStringAsFixed(2)} ${widget.toCurrency}');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen, // ปุ่มสีเขียวอ่อน
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'บันทึกและกลับไป',
                      style: TextStyle(color: Colors.white, fontSize: 16), // ฟอนต์สีขาว
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
