import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qless/QLess/Screens/payment_page.dart';


class PaymentUI extends StatefulWidget {
  const PaymentUI({super.key});

  @override
  State<PaymentUI> createState() => _PaymentUIState();
}

class _PaymentUIState extends State<PaymentUI> {
  String? selectedPayment;
  String? selectedUpiApp;
  bool showUpiApps = false;
  bool showCardForm = false;

  final TextEditingController upiController = TextEditingController();
  final TextEditingController cardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Select Payment Method",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPaymentOption("UPI", expandable: true, isCard: false),
            if (showUpiApps) ...[
              _buildUpiApps(),
              if (selectedUpiApp != null) ...[
                _circleTextField("Enter UPI ID", upiController),
                _proceedButton(
                  context,
                  onPressed: () => _showConfirmDialog(
                    context,
                    method: "UPI - $selectedUpiApp",
                    details: upiController.text,
                  ),
                ),
              ],
            ],

            _buildPaymentOption("Credit / Debit Card",
                expandable: true, isCard: true),
            if (showCardForm) _buildCardForm(context),
          ],
        ),
      ),
    );
  }

  /// Payment Option Tile
  Widget _buildPaymentOption(String name,
      {bool expandable = false, bool isCard = false}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: RadioListTile<String>(
        value: name,
        groupValue: selectedPayment,
        onChanged: (value) {
          setState(() {
            selectedPayment = value;
            if (expandable && !isCard) {
              showUpiApps = true;
              showCardForm = false;
            } else if (expandable && isCard) {
              showCardForm = true;
              showUpiApps = false;
            }
          });
        },
        title: Text(name,
            style: const TextStyle(color: Colors.black, fontSize: 16)),
        activeColor: Colors.black,
      ),
    );
  }

  /// UPI Apps
  Widget _buildUpiApps() {
    return Column(
      children: [
        _upiCircleBox("Google Pay"),
        _upiCircleBox("PhonePe"),
      ],
    );
  }

  Widget _upiCircleBox(String name) {
    return GestureDetector(
      onTap: () => setState(() => selectedUpiApp = name),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selectedUpiApp == name ? Colors.black : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(color: Colors.black, fontSize: 16)),
            if (selectedUpiApp == name)
              const Icon(Icons.check_circle, color: Colors.black)
          ],
        ),
      ),
    );
  }

  /// Circular TextField
  Widget _circleTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }

  /// Button
  Widget _proceedButton(BuildContext context, {required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      onPressed: onPressed,
      child: const Text("Proceed to Pay",
          style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  /// Confirmation Dialog
  void _showConfirmDialog(BuildContext context,
      {required String method, required String details}) {
    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill details")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text("Pay with $method\nDetails: $details"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentPage(
                    method: method,
                    details: details,
                    amount: "₹500", // Example
                  ),
                ),
              );
            },
            child: const Text("Pay Now"),
          ),
        ],
      ),
    );
  }

  /// Card Form
  Widget _buildCardForm(BuildContext context) {
    return Column(
      children: [
        _circleTextField("Card Number", cardController),
        Row(
          children: [
            Expanded(child: _circleTextField("MM/YY", TextEditingController())),
            const SizedBox(width: 10),
            Expanded(child: _circleTextField("CVV", TextEditingController())),
          ],
        ),
        _circleTextField("Card Holder Name", TextEditingController()),
        _proceedButton(
          context,
          onPressed: () => _showConfirmDialog(
            context,
            method: "Credit/Debit Card",
            details: cardController.text,
          ),
        ),
      ],
    );
  }
}