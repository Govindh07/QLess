import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qless/QLess/Model/payment_model.dart';
import 'package:qless/QLess/Provider/payment_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class QrBillingScreen extends StatefulWidget {
  const QrBillingScreen({super.key});

  @override
  State<QrBillingScreen> createState() => _QrBillingScreenState();
}

class _QrBillingScreenState extends State<QrBillingScreen> with SingleTickerProviderStateMixin {
  final DraggableScrollableController _dragController = DraggableScrollableController();
  bool isExpanded = false;
  final double minsize = 0.25;
  final double maxsize = 0.8;
  bool isVisible = true;

  List<Map<String, dynamic>> cartItems = [];
  double total = 0;
  bool _isProcessing = false;
  String scanningMessage = "Scanning...";
  int _scannedItemsCount = 0;

  Random random = Random();

  late AnimationController _lineController;
  late Animation<double> _lineAnimation;
  late MobileScannerController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _lineController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _lineAnimation = Tween<double>(begin: 0, end: 250).animate(CurvedAnimation(parent: _lineController, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      });
    _lineController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _lineController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> addToCart(String code) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      int existingIndex = cartItems.indexWhere((item) => item["code"] == code);
      if (existingIndex >= 0) {
        setState(() {
          cartItems[existingIndex]["qty"] += 1;
          total += cartItems[existingIndex]["price"];
          _scannedItemsCount++;
          scanningMessage = "${cartItems[existingIndex]["name"]} qty +1";
        });
      } else {
        String productName = "";
        double price = 0.0;

        try {
          final url = "https://world.openfoodfacts.org/api/v0/product/$code.json";
          final response = await http.get(Uri.parse(url));

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data["status"] == 1) {
              productName = data["product"]["product_name"] ?? "";
            }
          }
        } catch (e) {
          debugPrint("API error: $e");
        }

        if (productName.isEmpty) {
          List<String> dummyNames = ["Water Bottle", "Chips Pack", "Chocolate", "Soda Can", "Snack Bar", "Energy Drink", "Cookies", "Juice Box"];
          productName = dummyNames[random.nextInt(dummyNames.length)];
        }

        price = (random.nextInt(100) + 20).toDouble();

        setState(() {
          cartItems.add({
            "code": code,
            "name": productName,
            "price": price,
            "qty": 1,
          });
          total += price;
          _scannedItemsCount++;
          scanningMessage = "$productName added (₹${price.toStringAsFixed(2)})";
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    Future.delayed(const Duration(seconds: 1), () {
      _isProcessing = false;
    });
  }

  void _processPayment() {
    if (cartItems.isEmpty) return;

    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

    // Create a new payment record - CORRECTED VERSION
    final payment = Payment(
      method: "QR Billing", // Payment method
      details: "Scanned Items: ${cartItems.length}", // Payment details
      amount: "₹${total.toStringAsFixed(2)}", // Formatted amount as string
      date: DateTime.now().toString(), // Date as string
    );

    // Add to payment history
    paymentProvider.addPayment(payment);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment of ₹${total.toStringAsFixed(2)} completed successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Clear cart after successful payment
    setState(() {
      cartItems.clear();
      total = 0;
      _scannedItemsCount = 0;
      scanningMessage = "Payment successful! Scan next items...";
    });
  }

  void _clearCart() {
    if (cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Clear Cart"),
        content: const Text("Are you sure you want to clear all items from the cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                cartItems.clear();
                total = 0;
                _scannedItemsCount = 0;
                scanningMessage = "Cart cleared. Start scanning...";
              });
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void toggleSheet() async {
    if (isExpanded) {
      await _dragController.animateTo(minsize, duration: const Duration(milliseconds: 350), curve: Curves.easeOutSine);
    } else {
      await _dragController.animateTo(maxsize, duration: const Duration(milliseconds: 350), curve: Curves.ease);
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void _toggleFlash() {
    setState(() {
      _cameraController.toggleTorch();
    });
  }

  void _switchCamera() {
    setState(() {
      _cameraController.switchCamera();
    });
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && !_isProcessing) {
        addToCart(code);
        break; // Process only one barcode at a time
      }
    }
  }

  String get billData {
    String items = cartItems.map((e) => "${e['name']} x${e['qty']} - ₹${(e['price']*e['qty']).toStringAsFixed(2)}").join("\n");
    return "Q-Less Bill\n\nItems:\n$items\n\nTotal: ₹${total.toStringAsFixed(2)}\n\nDate: ${DateTime.now().toString().split(' ')[0]}\nThank you!";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (cartItems.isNotEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Unsaved Items"),
              content: const Text("You have items in your cart. Are you sure you want to leave?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Stay"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: const Text("Leave", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Stack(children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (cartItems.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Unsaved Items"),
                        content: const Text("You have items in your cart. Are you sure you want to leave?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Stay"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pop(context);
                            },
                            child: const Text("Leave", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),

          // Camera Controls
          Positioned(
            top: 50,
            right: 20,
            child: Column(
              children: [
                // Flash Toggle
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: _toggleFlash,
                  ),
                ),
                // Camera Switch
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.cameraswitch, color: Colors.white),
                    onPressed: _switchCamera,
                  ),
                ),
              ],
            ),
          ),

          // Scanner Frame
          Center(
            child: Stack(
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Positioned(
                  top: _lineAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: Colors.redAccent,
                  ),
                ),
                // Scanner Corner Design
                ..._buildScannerCorners(),
              ],
            ),
          ),

          // Scanning Message
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      scanningMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_scannedItemsCount > 0)
                    Text(
                      "Scanned: $_scannedItemsCount items | Total: ₹${total.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
          ),

          // Cart Sheet
          if (isVisible)
            DraggableScrollableSheet(
              controller: _dragController,
              initialChildSize: minsize,
              minChildSize: minsize,
              maxChildSize: maxsize,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.shopping_cart_outlined, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('Cart Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  if (cartItems.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.clear_all, color: Colors.red),
                                      onPressed: _clearCart,
                                      tooltip: "Clear Cart",
                                    ),
                                ],
                              ),
                            ),
                            const Divider(),
                            if (cartItems.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      "No items scanned yet\nStart scanning QR codes to add items",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...cartItems.map((item) {
                                return ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.qr_code, color: Colors.blue),
                                  ),
                                  title: Text(
                                    item['name'],
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text("Code: ${item['code']}"),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "₹${(item['price'] * item['qty']).toStringAsFixed(2)}",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Qty: ${item['qty']}",
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            if (cartItems.isNotEmpty) ...[
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Amount:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text(
                                      "₹${total.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Get Bill QR Button
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.qr_code_2),
                                        label: const Text('Get Bill QR'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text("Bill QR Code"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey.shade300),
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: QrImageView(
                                                      data: billData,
                                                      size: 200,
                                                      backgroundColor: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "Total: ₹${total.toStringAsFixed(2)}",
                                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx),
                                                  child: const Text("Close"),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Pay Now Button
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.payment),
                                        label: const Text('Pay Now'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onPressed: _processPayment,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Toggle Cart Visibility Button
          Positioned(
            top: 120,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blue,
              child: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: Colors.white),
              onPressed: toggleVisibility,
            ),
          ),

          // Expand/Collapse Cart Button
          if (isVisible)
            AnimatedBuilder(
              animation: _dragController,
              builder: (context, child) {
                double size = _dragController.isAttached ? _dragController.size : minsize;
                double fab = (MediaQuery.of(context).size.height * size) - 25;
                return Positioned(
                  bottom: fab,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.blue,
                      child: Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Colors.white),
                      onPressed: toggleSheet,
                    ),
                  ),
                );
              },
            ),
        ]),
      ),
    );
  }

  List<Widget> _buildScannerCorners() {
    return [
      // Top Left
      Positioned(top: 0, left: 0, child: _buildCorner(true, true)),
      // Top Right
      Positioned(top: 0, right: 0, child: _buildCorner(false, true)),
      // Bottom Left
      Positioned(bottom: 0, left: 0, child: _buildCorner(true, false)),
      // Bottom Right
      Positioned(bottom: 0, right: 0, child: _buildCorner(false, false)),
    ];
  }

  Widget _buildCorner(bool isLeft, bool isTop) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.blueAccent,
            width: isLeft ? 3 : 0,
          ),
          top: BorderSide(
            color: Colors.blueAccent,
            width: isTop ? 3 : 0,
          ),
          right: BorderSide(
            color: Colors.blueAccent,
            width: !isLeft ? 3 : 0,
          ),
          bottom: BorderSide(
            color: Colors.blueAccent,
            width: !isTop ? 3 : 0,
          ),
        ),
      ),
    );
  }
}