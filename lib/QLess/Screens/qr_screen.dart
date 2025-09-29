import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: QrBillingScreen(),));
}

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

  Random random = Random();


  late AnimationController _lineController;
  late Animation<double> _lineAnimation;

  @override
  void initState() {
    super.initState();
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
          List<String> dummyNames = ["Water Bottle", "Chips Pack", "Chocolate", "Soda Can", "Snack Bar"];
          productName = dummyNames[random.nextInt(dummyNames.length)];
        }

        price = (random.nextInt(100) + 20).toDouble();

        setState(() {
          cartItems.add({
            "code":    code,
            "name": productName,"price": price,
            "qty": 1,
          });
          total += price;
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

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null) {
        addToCart(code);
      }
    }
  }

  String get billData {
    String items = cartItems.map((e) => "${e['name']} x${e['qty']} - ₹${(e['price']*e['qty']).toStringAsFixed(2)}").join("\n");
    return "Bill:\n$items\n\nTotal: ₹${total.toStringAsFixed(2)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [

          MobileScanner(
            controller: MobileScannerController(detectionSpeed: DetectionSpeed.normal),
            onDetect: _onDetect,
          ),


          Center(
            child: Stack(
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),),

                Positioned(
                  top: _lineAnimation.value,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    color: Colors.redAccent,
                  ),),
              ],
            ),),


          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(8),
              child: Text(
                scanningMessage,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),


          if (isVisible)
            DraggableScrollableSheet(
              controller:
              _dragController,
              initialChildSize: minsize,
              minChildSize:  minsize,
              maxChildSize: maxsize,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.shopping_cart_outlined),
                            SizedBox(width: 5),
                            Text('Cart Items'),
                          ],
                        ),
                      ),
                      const Divider(),
                      ...cartItems.map((item) {
                        return ListTile(
                          leading: const Icon(Icons.qr_code),
                          title: Text(item['name']),
                          subtitle: Text("Qty: ${item['qty']}"),
                          trailing: Text("₹${(item['price'] * item['qty']).toStringAsFixed(2)}"),
                        );
                      }).toList(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (cartItems.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Bill QR"),
                                  content: SizedBox(
                                    height: 250,
                                    width: 250,
                                    child: QrImageView(
                                      data: billData,
                                      size: 200,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text("Close"),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                            child: const Center(child: Text('Get Bill', style: TextStyle(color: Colors.white))),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),


          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.blue,
              child: Icon(isVisible ? Icons.hide_source_outlined : Icons.panorama_fisheye, color: Colors.white),
              onPressed: toggleVisibility,
            ),
          ),


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
        );
  }
}