// import 'package:flutter/material.dart';
// import 'package:q_less/QLess/Screens/home_screen.dart';
// import 'package:q_less/QLess/Screens/edit_profile_page.dart'; // Import your edit page
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   int _selectedIndex = 0;
//
//   void onTapPlaceholder(String name) {
//     print('$name clicked');
//   }
//
//   void navigateToHome(BuildContext context) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const HomePage()),
//     );
//   }
//
//   void navigateToEditProfile(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const EditProfilePage()),
//     );
//   }
//
//   void navigateToSettings(BuildContext context) {
//     // You can implement this later
//   }
//
//   Widget buildIconButton({
//     required IconData icon,
//     required int index,
//     required VoidCallback onPressed,
//   }) {
//     bool isSelected = _selectedIndex == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedIndex = index;
//         });
//         onPressed();
//       },
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isSelected ? Colors.black : Colors.transparent,
//         ),
//         child: Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 30),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Header Section
//           Container(
//             height: 200,
//             decoration: const BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(40),
//                 bottomRight: Radius.circular(40),
//               ),
//             ),
//             child: Stack(
//               children: [
//                 Positioned(
//                   top: 50,
//                   left: 20,
//                   child: GestureDetector(
//                     onTap: () => navigateToHome(context),
//                     child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.person, color: Colors.black, size: 40),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Anna Avetisyan',
//                         style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 20),
//           buildProfileItem(icon: Icons.person, label: "Anna Avetisyan"),
//           buildProfileItem(icon: Icons.calendar_today, label: "06 September 1986"),
//           buildProfileItem(icon: Icons.phone, label: "+91 88888 88888"),
//           buildProfileItem(icon: Icons.account_circle, label: "Instagram account"),
//           buildProfileItem(icon: Icons.email, label: "anna@example.com"),
//           buildProfileItem(icon: Icons.remove_red_eye, label: "Password"),
//
//           const SizedBox(height: 30),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   navigateToEditProfile(context); // Navigate to edit page
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: const Text("Edit profile", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//           ),
//         ],
//       ),
//
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         color: Colors.white,
//         child: SizedBox(
//           height: 70,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               buildIconButton(
//                 icon: Icons.home,
//                 index: 0,
//                 onPressed: () => navigateToHome(context),
//               ),
//               const SizedBox(width: 20),
//               buildIconButton(
//                 icon: Icons.settings,
//                 index: 1,
//                 onPressed: () => onTapPlaceholder("Settings"),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: SizedBox(
//         height: 70,
//         width: 70,
//         child: FloatingActionButton(
//           elevation: 6,
//           backgroundColor: Colors.black,
//           onPressed: () => onTapPlaceholder("Scan"),
//           shape: const CircleBorder(),
//           child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 40),
//         ),
//       ),
//     );
//   }
//
//   static Widget buildProfileItem({required IconData icon, required String label}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: Colors.black12,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.black),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(color: Colors.black, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:q_less/QLess/Screens/edit_profile_page.dart';
import 'package:q_less/QLess/Screens/home_screen.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

  void onTapPlaceholder(String name) {
    print('$name clicked');
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  void navigateToSettings(BuildContext context) {
    // You can implement this later
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => navigateToHome(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.black, size: 40),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Anna Avetisyan',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            buildProfileItem(icon: Icons.person, label: "Anna Avetisyan"),
            buildProfileItem(icon: Icons.calendar_today, label: "06 September 1986"),
            buildProfileItem(icon: Icons.phone, label: "‪+91 88888 88888‬"),
            buildProfileItem(icon: Icons.account_circle, label: "Instagram account"),
            buildProfileItem(icon: Icons.email, label: "anna@example.com"),
            buildProfileItem(icon: Icons.remove_red_eye, label: "Password"),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigateToEditProfile(context); // Navigate to edit page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Edit profile", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),




    );
  }

  static Widget buildProfileItem({required IconData icon, required String label}) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
            ),
        );
    }
}