import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/ForgotpassScreen.dart';
import 'package:myfitness/HomeScreen.dart';
import 'package:myfitness/services/password_service.dart';
import 'package:myfitness/services/session_service.dart';
import 'Common.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isPassVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: Colors.blueGrey.shade800),
      hintStyle: TextStyle(color: Colors.blueGrey.shade400),
      prefixIcon: Icon(icon, color: Colors.blueGrey.shade700),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade700, width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Login to continue your fitness journey",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    "asset/user.png",
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Enter your email and password",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.blueGrey.shade600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your email";
                            } else if (RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value) ==
                                false) {
                              return "Invalid email format";
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            label: "Email",
                            hint: "Enter your email",
                            icon: Icons.email_outlined,
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: isPassVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            label: "Password",
                            hint: "Enter your password",
                            icon: Icons.lock_outline,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isPassVisible = !isPassVisible;
                                });
                              },
                              child: Icon(
                                  isPassVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                  color: Colors.blueGrey.shade700),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: appButton(
                                  buttonText: "Login",
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (formkey.currentState!.validate() ==
                                        true) {
                                      showProgressDialog(context);

                                      var userData =
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .where(
                                                'email',
                                                isEqualTo:
                                                    emailController.text.trim(),
                                              )
                                              .get();
                                      hideProgress(context);
                                      if (userData.docs.isNotEmpty) {
                                        var userInfo = userData.docs[0];
                                        var mapData = userInfo.data();

                                        final String enteredEmail =
                                            emailController.text.trim();
                                        final String enteredPassword =
                                            passwordController.text.trim();

                                        final String? storedHash =
                                            mapData['password_hash'];
                                        final String? legacyPassword =
                                            mapData['password'];

                                        bool isValidUser = false;

                                        if (storedHash != null &&
                                            storedHash.isNotEmpty) {
                                          isValidUser =
                                              PasswordService.verifyPassword(
                                            email: enteredEmail,
                                            enteredPassword: enteredPassword,
                                            storedHash: storedHash,
                                          );
                                        } else if (legacyPassword != null &&
                                            legacyPassword == enteredPassword) {
                                          isValidUser = true;
                                          final String migratedHash =
                                              PasswordService.hashPassword(
                                            email: enteredEmail,
                                            password: enteredPassword,
                                          );
                                          await FirebaseFirestore.instance
                                              .collection('Users')
                                              .doc(userInfo.id)
                                              .update({
                                            'password_hash': migratedHash,
                                            'password': FieldValue.delete(),
                                          });
                                        }

                                        if (!isValidUser) {
                                          showErrorMsg(
                                              "Invalid password", Colors.red);
                                          return;
                                        }

                                        await SessionService.saveLoginSession(
                                          email: mapData['email'] ?? '',
                                          name: mapData['Name'] ?? '',
                                        );
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      } else {
                                        showErrorMsg(
                                            "User not found", Colors.red);
                                      }
                                    }
                                  }),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: appButton(
                                buttonText: "Signup",
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                                },
                                bgColor: Colors.blueGrey.shade700,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotpassScreen()),
                    );
                  },
                  child: Text.rich(
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.blueGrey),
                    TextSpan(
                      children: [
                        const TextSpan(
                            text: "Forgot Password?",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
