class Payment {
  final String method; // e.g., "UPI - Google Pay"
  final String details; // e.g., entered UPI ID or Card Number
  final String amount; // for now keep static or add input
  final String date;

  Payment({
    required this.method,
    required this.details,
    required this.amount,
    required this.date,
  });
}