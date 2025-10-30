import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qless/QLess/Model/payment_model.dart';
import 'package:qless/QLess/Provider/payment_provider.dart';
import 'package:qless/QLess/Screens/payment_history.dart';

class PaymentPage extends StatelessWidget {
  final String method;
  final String details;
  final String amount;

  const PaymentPage({
    super.key,
    required this.method,
    required this.details,
    required this.amount,
  });

  void _makePayment(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      final payment = Payment(
        method: method,
        details: details,
        amount: amount,
        date: DateTime.now().toString().substring(0, 16),
      );
      Provider.of<PaymentProvider>(context, listen: false).addPayment(payment);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Payment Successful!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaymentHistoryPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _makePayment(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }
}