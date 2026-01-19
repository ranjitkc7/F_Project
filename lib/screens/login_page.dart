import 'package:att_app/services/goole_auth_service.dart';
import 'package:att_app/widgets/loadar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'navigation_page.dart';
import '../widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isShowPassword = false;
  bool isLoading = false;

  final _fromKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void submitLogin() async {
    if (!_fromKey.currentState!.validate()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      User user = userCredential.user!;
      await user.reload();
      user = FirebaseAuth.instance.currentUser!;

      if (!user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please verify your email before logging in",
              style: TextStyle(color: Color.fromARGB(255, 251, 25, 9)),
            ),
          ),
        );
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigationPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Login failed",
            style: TextStyle(color: Color.fromARGB(255, 251, 25, 9)),
          ),
        ),
      );
    }
  }

  void handleGoogleSignIn() async {
    try {
      CustomDialog.showProgressBar(context);
      final userCredential = await AuthService.signInWithGoogle();
      CustomDialog.hideProgressBar(context);

      if (userCredential == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In cancelled")),
        );
        setState(() => isLoading = false);
        return;
      }
      final user = FirebaseAuth.instance.currentUser!;

       final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

         if (!userDoc.exists) {
    
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "image": user.photoURL ?? "",
        "isVerified": true, 
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
     CustomDialog.hideProgressBar(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NavigationPage()),
      );
    } catch (e) {
      CustomDialog.hideProgressBar(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 236, 213),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 244, 236, 213),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _fromKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 2.0),
                        child: Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Enter the email address",
                          prefixIcon: const Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isShowPassword,
                        decoration: InputDecoration(
                          hintText: "Enter the password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isShowPassword = !isShowPassword;
                              });
                            },
                            icon: !isShowPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: submitLogin,
                          radius: 12,
                          color: const Color.fromARGB(255, 98, 8, 242),
                          text: "Login",
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Already haven't an account? SignUp",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Or maybe continue with",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: handleGoogleSignIn,
                            child: Image.asset(
                              "assets/images/google.png",
                              width: 30,
                              height: 30,
                            ),
                          ),

                          TextButton(
                            onPressed: () {},
                            child: Image.asset(
                              "assets/images/fb.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
