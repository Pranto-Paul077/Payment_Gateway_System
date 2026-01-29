import 'package:flutter/material.dart';
import 'mfs_input_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  final double amount;
  const PaymentMethodsScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("TOTAL PAYABLE", style: TextStyle(color: Colors.grey[600])),
            Text("৳ ${amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            _methodTile(context, "bKash", "Fast & Secure MFS", Colors.pink),
            _methodTile(context, "Nagad", "Digital Financial Service", Colors.orange),
            _methodTile(context, "Visa Card", "**** 1234", Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _methodTile(BuildContext context, String name, String sub, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Container(width: 40, height: 40, color: color.withOpacity(0.2), child: Icon(Icons.wallet, color: color)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MfsInputScreen(method: name, amount: amount)));
        },
      ),
    );
  }
}