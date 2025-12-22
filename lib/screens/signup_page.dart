import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../widgets/button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isShowPassword = false;
  bool isShowConfirmPassword = false;

  final _fromKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void submitSignup() async {
    if (!_fromKey.currentState!.validate()) return;

    try {
      // Create user
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      User user = userCredential.user!;
      await user.sendEmailVerification();

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "isVerified": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Verification email sent. Please verify before login.",
            style: TextStyle(color: Color.fromARGB(255, 250, 247, 247)),
          ),
        ),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Auth errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Signup failed",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } on FirebaseException catch (e) {
      // Firestore errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Firestore error: ${e.message}",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 236, 213),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 244, 236, 213),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
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
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Welcome!",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Please sign up to continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter full name",
                      prefixIcon: const Icon(Icons.person),
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
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter email address",
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
                  SizedBox(height: 7),
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isShowPassword,
                    decoration: InputDecoration(
                      hintText: "Enter the password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShowPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
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
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "Password must contain at least one uppercase letter";
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "Password must contain at least one number";
                      }
                      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        return "Password must contain at least one special character";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 7),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isShowConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Re-enter the password",
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isShowConfirmPassword = !isShowConfirmPassword;
                          });
                        },
                        icon: Icon(
                          isShowConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
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
                        return "Confirm Password is required";
                      }
                      if (value != passwordController.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      color: const Color.fromARGB(255, 98, 8, 242),
                      radius: 12,
                      text: "Sign Up",
                      onPressed: submitSignup,
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        " Already have an account?  Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
