import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qless/QLess/Screens/edit_profile.dart';
import 'package:qless/QLess/Screens/help_support.dart';
import 'package:qless/QLess/Screens/log_out.dart';
import 'package:qless/QLess/Screens/payment_ui.dart';


class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: false,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile row
          ListTile(
            leading: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            title: const Text("John", style: TextStyle(fontSize: 18)),
            subtitle: const Text("john134@gmail.com"),
            onTap: () {},
          ),
          const SizedBox(height: 20),

          const Text(
            "Account settings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Settings with circle border
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfilePage()));
              },
              child: buildSettingItem(

                  Icons.person, "Edit profile")),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentUI()));
              },
              child: buildSettingItem(Icons.payment, "Payments")),
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpSupportPage()));
              },
              child: buildSettingItem(Icons.help, "Help")),
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Logout()));
              },
              child: buildSettingItem(Icons.logout, "Logout")),
        ],
      ),
    );
  }

  Widget buildSettingItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.2),
        borderRadius: BorderRadius.circular(50), // 👈 circle border
        color: Colors.white,
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(text, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

      ),


    );


  }
}