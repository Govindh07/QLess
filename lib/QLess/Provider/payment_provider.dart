import 'package:flutter/foundation.dart';
import 'package:qless/QLess/Model/payment_model.dart';


class PaymentProvider extends ChangeNotifier {
  final List<Payment> _history = [];

  List<Payment> get history => _history;

  void addPayment(Payment payment) {
    _history.add(payment);
    notifyListeners();
  }
}
