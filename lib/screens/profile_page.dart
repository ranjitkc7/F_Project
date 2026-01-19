import 'package:att_app/screens/login_page.dart';
import 'package:att_app/screens/setting_page.dart';
import 'package:att_app/services/goole_auth_service.dart';
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
  String userImage = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    setState(() {
      userName = "Guest";
      userEmail = "";
      userImage = "";
      isLoading = false;
    });
    return;
  }

  try {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    setState(() {
      userName = doc.data()?['name'] ??
          user.displayName ??
          "No Name";

      userEmail = doc.data()?['email'] ??
          user.email ??
          "No Email";

      userImage = doc.data()?['image'] ??
          user.photoURL ??
          "";

      isLoading = false;
    });
  } catch (e) {
    setState(() {
      userName = user.displayName ?? "No Name";
      userEmail = user.email ?? "No Email";
      userImage = user.photoURL ?? "";
      isLoading = false;
    });
  }
}


  Future<void> handleLogout() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signOut();

      await AuthService.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: userImage.isNotEmpty
                        ? NetworkImage(userImage)
                        : AssetImage("assets/images/ppp.png") as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName.isEmpty ? "Loading..." : userName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    userEmail.isEmpty ? "Loading.." : userEmail,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text("Change Password"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text("Logout"),
              onTap: handleLogout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color:Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
          size: 28,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userImage.isNotEmpty
                        ? NetworkImage(userImage)
                        : const AssetImage("assets/images/ppp.png")
                              as ImageProvider,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
