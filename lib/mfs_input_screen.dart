import 'package:flutter/material.dart';
import 'otp_screen.dart';

class MfsInputScreen extends StatelessWidget {
  final String method;
  final double amount;
  final _phoneController = TextEditingController();

  MfsInputScreen({super.key, required this.method, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$method Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Enter $method Account Number", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "01XXXXXXXXX",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E8B90), foregroundColor: Colors.white),
                onPressed: () {
                  if (_phoneController.text.length == 11) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(method: method, amount: amount, phone: _phoneController.text)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Phone Number")));
                  }
                },
                child: const Text("Proceed to OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}