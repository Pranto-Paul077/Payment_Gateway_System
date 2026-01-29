import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'payment_methods_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _supabase = Supabase.instance.client;
  final TextEditingController _amountController = TextEditingController();
  late final Stream<List<Map<String, dynamic>>> _transactionStream;

  @override
  void initState() {
    super.initState();
    final user = _supabase.auth.currentUser;
    final userId = user != null ? user.id : '';

    _transactionStream = _supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data);
  }

  Future<void> _signOut() async {
    await _supabase.auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dashboard"),
        backgroundColor: const Color(0xFFE2136E),
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _signOut, icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE2136E),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const Text("Available Balance", style: TextStyle(color: Colors.white70)),
                const Text("৳ 5,240.50", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Enter Amount", border: InputBorder.none, prefixText: "৳ "),
                        ),
                      ),


                      TextButton(
                        onPressed: () {
                          final text = _amountController.text.trim();

                          final amount = double.tryParse(text);

                          if (amount != null && amount > 0) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentMethodsScreen(amount: amount)));
                            _amountController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter a valid amount"), backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: const Text("PAY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                      // -------------------------------
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(alignment: Alignment.centerLeft, child: Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _transactionStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Center(child: Text("Waiting for data..."));
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final transactions = snapshot.data!;
                if (transactions.isEmpty) return const Center(child: Text("No transactions yet"));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final date = DateTime.parse(tx['created_at']).toLocal();

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink.shade50,
                          child: const Icon(Icons.payment, color: Colors.pink),
                        ),
                        title: Text(tx['payment_method']),
                        subtitle: Text(DateFormat('dd MMM, hh:mm a').format(date)),
                        trailing: Text("- ৳${tx['amount']}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}