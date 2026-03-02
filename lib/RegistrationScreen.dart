import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/Common.dart';
import 'package:myfitness/services/password_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var isPassVisible = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGender = "";

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
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
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Set up your profile and start your fitness journey",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Image.asset(
                  "asset/add-user.png",
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
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
                        "Registration",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Fill your details to create an account",
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          label: "Full Name",
                          hint: "Enter your full name",
                          icon: Icons.person_outline,
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value.trim())) {
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
                        obscureText: isPassVisible,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          label: "Password",
                          hint: "Create your password",
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
                              color: Colors.blueGrey.shade700,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number is required";
                          } else if (value.length != 10) {
                            return "Invalid phone number";
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          label: "Phone Number",
                          hint: "Enter 10-digit number",
                          icon: Icons.phone_outlined,
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 14,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: "male",
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Male",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: "female",
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value!;
                                  });
                                },
                              ),
                              const Text(
                                "Female",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      appButton(
                        buttonText: "Register",
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          if (formkey.currentState!.validate()) {
                            showProgressDialog(context);

                            var userData = await FirebaseFirestore.instance
                                .collection('Users')
                                .where('email',
                                    isEqualTo: emailController.text.trim())
                                .get();

                            if (userData.docs.isNotEmpty) {
                              hideProgress(context);
                              showErrorMsg(
                                  "User already registered", Colors.red);
                            } else {
                              final String passwordHash =
                                  PasswordService.hashPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('Users');
                              await users.add({
                                'Name': nameController.text.trim(),
                                'email': emailController.text.trim(),
                                'password_hash': passwordHash,
                                'Phone Number': phoneController.text.trim(),
                                'Gender': selectedGender,
                              });

                              hideProgress(context);
                              showErrorMsg(
                                  "Registration Successful", Colors.green);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        bgColor: Colors.blueGrey.shade700,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Text.rich(
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.blueGrey),
                    TextSpan(
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
