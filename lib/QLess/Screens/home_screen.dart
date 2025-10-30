import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qless/QLess/Screens/profile_setings.dart';
import 'wallet_page.dart';
import 'payment_history.dart';
import 'qr_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedIndex = 0;
  final int _numPages = 3;
  Timer? _timer;

  final List<String> offerImages = [
    'assets/images/image 1.jpg',
    'assets/images/image 2.jpg',
    'assets/images/image 3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= _numPages) _currentPage = 0;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void navigateToWallet() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletPage()),
    );
  }

  void navigateToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentHistoryPage()),
    );
  }

  void navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
    );
  }

  void navigateToQr() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QrBillingScreen()),
    );
  }

  Widget buildIconButton({
    required IconData icon,
    required int index,
    required VoidCallback onPressed,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        onPressed();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.transparent,
        ),
        child: Icon(icon,
            color: isSelected ? Colors.white : Colors.black, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Q-Less',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Offers Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Offers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 150,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _numPages,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => print("Offer Image ${index + 1} clicked"),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: FadeInImage(
                            placeholder:
                            const AssetImage('assets/images/placeholder.jpg'),
                            image: AssetImage(offerImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _numPages,
                    effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.black,
                        dotColor: Colors.black26,
                        dotHeight: 8,
                        dotWidth: 8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Main Actions Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // Wallet Card
                GestureDetector(
                  onTap: navigateToWallet,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.account_balance_wallet,
                            color: Colors.black, size: 30),
                        Text('Q-Less Wallet',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Icon(Icons.arrow_forward_ios, color: Colors.black),
                      ],
                    ),
                  ),
                ),

                // History Card
                GestureDetector(
                  onTap: navigateToHistory,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.history, color: Colors.black, size: 30),
                        Text('Purchase History',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Icon(Icons.arrow_forward_ios, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildIconButton(
                  icon: Icons.home,
                  index: 0,
                  onPressed: () {}),
              const SizedBox(width: 20),
              buildIconButton(
                  icon: Icons.person,
                  index: 1,
                  onPressed: navigateToSettings),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          elevation: 6,
          backgroundColor: Colors.black,
          onPressed: navigateToQr,
          shape: const CircleBorder(),
          child: const Icon(Icons.qr_code_scanner,
              color: Colors.white, size: 40),
        ),
      ),
    );
  }
}