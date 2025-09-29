import 'dart:async';
import 'package:flutter/material.dart';
import 'package:q_less/QLess/Screens/profile_page.dart';
import 'package:q_less/QLess/Screens/profile_settings.dart';
import 'package:q_less/QLess/Screens/qr_screen.dart';
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
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
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

  void onTapPlaceholder(String name) {
    print('$name clicked');
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ProfilePage()),
    );
  }

  void navigateToWallet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletPage()),
    ).then((_) {
      setState(() {
        _selectedIndex = 0;
      });
    });
  }

  void navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryPage()),
    ).then((_) {
      setState(() {
        _selectedIndex = 0;
      });
    });
  }

  void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    ).then((_) {
      setState(() {
        _selectedIndex = 0;
      });
    });
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
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Scaffold(backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage())),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.black, size: 30),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onTapPlaceholder("Notification"),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Text('Notification', style: TextStyle(color: Colors.black)),
                          SizedBox(width: 8),
                          Icon(Icons.notifications, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Todays Offer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _numPages,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => onTapPlaceholder("Offer Image ${index + 1}"),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: FadeInImage(
                              placeholder: const AssetImage('assets/images/placeholder.jpg'),
                              image: AssetImage(offerImages[index]),
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: _numPages,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.black,
                        dotColor: Colors.black26,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => navigateToWallet(context),
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
                      Icon(Icons.account_balance_wallet, color: Colors.black, size: 30),
                      Text('Qless Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => navigateToHistory(context),
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
                      Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                onPressed: () => HomePage(),
              ),
              const SizedBox(width: 20),
              buildIconButton(
                icon: Icons.settings,
                index: 1,
                onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileSettingsPage())),
              ),
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
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>QrBillingScreen()));
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.qr_code_scanner, color: Colors.red, size: 40),
        ),
      ),
    );
  }
}

// Dummy pages (leave unchanged or replace with real ones)
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Qless Wallet'), backgroundColor: Colors.white),
    body: const Center(child: Text('This is the Qless Wallet Page')),
  );
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(backgroundColor: Colors.white,
    appBar: AppBar(title: const Text('History'), backgroundColor: Colors.white),
    body: const Center(child: Text('This is the History Page')),
  );
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Settings'), backgroundColor: Colors.white),
      body: const Center(child: Text('This is the Settings Page')),
      );
}