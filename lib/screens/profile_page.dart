import 'package:att_app/screens/login_page.dart';
import 'package:att_app/screens/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = " ";
  String userEmail = " ";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc["name"];
          userEmail = userDoc["email"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 98, 8, 242),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/ppp.png"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName.isEmpty ? "Loading..." : userName,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    userEmail.isEmpty ? "Loading.." : userEmail,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text("Change Password"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 98, 8, 242),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
      ),
      backgroundColor: const Color.fromARGB(255, 244, 236, 213),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/ppp.png"),
            ),
            SizedBox(height: 3),
            Text(
              userName.isEmpty ? "Loading..." : userName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(
              userEmail.isEmpty ? "Loading..." : userEmail,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
