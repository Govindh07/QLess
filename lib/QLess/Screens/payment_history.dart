import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qless/QLess/Model/payment_model.dart';
import 'package:qless/QLess/Provider/payment_provider.dart';


class PaymentHistoryPage extends StatelessWidget {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);
    final history = provider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          "No payments yet",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final Payment p = history[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(p.method),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(p.details),
                  const SizedBox(height: 4),
                  Text(
                    p.date,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Text(
                p.amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
