import 'package:flutter/material.dart';
import 'convert_page.dart';
import 'history_page.dart';
import 'info_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final List<String> historyList;

  const HomePage({super.key, this.historyList = const []});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  String fromCurrency = 'USD';
  String toCurrency = 'THB';
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> currencies = [
    'USD', 'THB', 'EUR', 'JPY', 'GBP', 'CNY', 'KRW', 'AUD', 'CAD', 'CHF',
    'SGD', 'HKD', 'NZD', 'INR', 'RUB', 'ZAR', 'SEK', 'NOK', 'MXN', 'BRL'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void swapCurrencies() {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed) {
      _controller.reset();
    }
    _controller.forward(from: 0.0);

    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
  }

  void incrementAmount() {
    setState(() {
      double currentAmount = double.tryParse(amountController.text) ?? 0;
      amountController.text = (currentAmount + 1).toString();
    });
  }

  void decrementAmount() {
    setState(() {
      double currentAmount = double.tryParse(amountController.text) ?? 0;
      if (currentAmount > 0) {
        amountController.text = (currentAmount - 1).toString();
      }
    });
  }

  void handleConvert() {
    if (amountController.text.isEmpty) {
      Fluttertoast.showToast(msg: "กรุณากรอกจำนวนเงิน");
      return;
    }

    double? amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      Fluttertoast.showToast(msg: "กรุณากรอกจำนวนเงินที่ถูกต้อง");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConvertPage(
            amount: amount,
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            historyList: widget.historyList,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แปลงสกุลเงิน',
          style: GoogleFonts.prompt(
            fontSize: 22,
            fontWeight: FontWeight.bold, // ตัวหนา
            color: Colors.white, // สีขาว
          ),
        ),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "ประวัติ"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "ข้อมูล"),
        ],
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage(historyList: widget.historyList)));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InfoPage()));
          }
        },
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // รูปแปลงสกุลเงินเต็มแถบด้านบน
          Container(
            width: double.infinity, // ให้รูปเต็มจอ
            height: 250, // ปรับขนาดให้พอดี
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/exchange_image.jpg'), // ใช้รูปที่ต้องการ
                fit: BoxFit.fitWidth, // ป้องกันการตัดรูป ให้เต็มความกว้าง
                alignment: Alignment.center, // จัดให้อยู่ตรงกลาง
              ),
            ),
          ),

          // ใช้ Expanded ดัน UI ด้านล่างขึ้น
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16), // ลด Padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ช่องกรอกจำนวนเงิน
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // คีย์บอร์ดแบบตัวเลข
                    decoration: InputDecoration(
                      labelText: 'กรอกจำนวนเงิน',
                      labelStyle: GoogleFonts.prompt(fontSize: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.remove_circle, color: Colors.redAccent), onPressed: decrementAmount),
                          IconButton(icon: Icon(Icons.add_circle, color: Colors.green), onPressed: incrementAmount),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // เลือกสกุลเงินและปุ่ม Swap
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<String>(
                        value: fromCurrency,
                        onChanged: (value) => setState(() => fromCurrency = value!),
                        items: currencies.map((currency) {
                          return DropdownMenuItem(value: currency, child: Text(currency, style: GoogleFonts.prompt()));
                        }).toList(),
                      ),

                      RotationTransition(
                        turns: _animation,
                        child: IconButton(
                          icon: Icon(Icons.swap_horiz, size: 36, color: Colors.blueAccent),
                          onPressed: swapCurrencies,
                        ),
                      ),

                      DropdownButton<String>(
                        value: toCurrency,
                        onChanged: (value) => setState(() => toCurrency = value!),
                        items: currencies.map((currency) {
                          return DropdownMenuItem(value: currency, child: Text(currency, style: GoogleFonts.prompt()));
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // ปุ่มแปลงเงิน
                  GestureDetector(
                    onTap: handleConvert,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.green.shade500, Colors.green.shade700]),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'แปลง',
                          style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
