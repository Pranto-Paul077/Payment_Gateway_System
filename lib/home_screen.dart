import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  final _amountController = TextEditingController();
  late final Stream<List<Map<String, dynamic>>> _transactionStream;

  @override
  void initState() {
    super.initState();

    _transactionStream = _supabase
        .from('transactions')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data);
  }


  Future<void> _makePayment() async {
    if (_amountController.text.isEmpty) return;

    final amount = double.parse(_amountController.text);
    final user = _supabase.auth.currentUser;
    final trxId = const Uuid().v4().substring(0, 8).toUpperCase();

    try {
      await _supabase.from('transactions').insert({
        'user_id': user!.id,
        'amount': amount,
        'payment_method': 'bKash',
        'account_number': '01700000000',
        'trx_id': trxId,
      });

      _amountController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Payment Successful!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _signOut() async {
    await _supabase.auth.signOut();
    if(mounted) Navigator.pushReplacementNamed(context, '/'); // মেইনে ফিরে যাবে
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("bKash Live Demo"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _signOut, icon: const Icon(Icons.logout))],
      ),
      body: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.pink.withOpacity(0.05),
            child: Column(
              children: [
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
                  decoration: const InputDecoration(
                      hintText: "Enter Amount",
                      prefixText: "৳ ",
                      border: InputBorder.none
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _makePayment,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white),
                  child: const Text("Tap to Pay (Realtime)"),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _transactionStream,
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final transactions = snapshot.data!;

                if (transactions.isEmpty) {
                  return const Center(child: Text("No transactions yet."));
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final data = transactions[index];

                    final date = DateTime.parse(data['created_at']).toLocal();
                    final formattedDate = DateFormat('hh:mm a, dd MMM').format(date);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.asset('assets/bkash_logo.png', width: 40, errorBuilder: (c,e,s)=> const Icon(Icons.payment, color: Colors.pink)),
                        title: Text("Payment to Merchant"),
                        subtitle: Text("TrxID: ${data['trx_id']} \n$formattedDate"),
                        isThreeLine: true,
                        trailing: Text(
                          "- ৳${data['amount']}",
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
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