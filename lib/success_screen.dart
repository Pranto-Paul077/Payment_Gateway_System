import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final double amount;
  final String trxId;

  const SuccessScreen({super.key, required this.amount, required this.trxId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text("Payment Successful", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("Transaction ID: #$trxId", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Text("Amount Paid: ৳ $amount", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), // ড্যাশবোর্ডে ফিরে যাবে
                child: const Text("Back to Home"),
              )
            ],
          ),
        ),
      ),
    );
  }
}