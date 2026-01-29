import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'success_screen.dart';

class OtpScreen extends StatefulWidget {
  final String method;
  final double amount;
  final String phone;

  const OtpScreen({super.key, required this.method, required this.amount, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isLoading = false;
  final _otpController = TextEditingController();

  Future<void> _verifyAndPay() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login first!")));
        return;
      }

      final trxId = const Uuid().v4().substring(0, 8).toUpperCase();


      await Supabase.instance.client.from('transactions').insert({
        'user_id': user.id, //
        'amount': widget.amount,
        'payment_method': widget.method,
        'account_number': widget.phone,
        'status': 'success',
        'trx_id': trxId,
      });


      if (!mounted) return;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SuccessScreen(amount: widget.amount, trxId: "TXN-$trxId"))
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Enter OTP sent to ${widget.phone}"),
            const SizedBox(height: 20),

            TextField(
              controller: _otpController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,

              // [FIXED HERE] letterSpacing moved to style
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 10.0,
              ),

              decoration: const InputDecoration(
                hintText: "X X X X X X",
                counterText: "",
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E8B90), foregroundColor: Colors.white),
                onPressed: _verifyAndPay,
                child: const Text("Confirm Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}