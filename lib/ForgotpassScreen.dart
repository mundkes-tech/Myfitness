import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/services/password_service.dart';

import 'Common.dart';

class ForgotpassScreen extends StatefulWidget {
  const ForgotpassScreen({super.key});

  @override
  State<ForgotpassScreen> createState() => _ForgotpassScreenState();
}

class _ForgotpassScreenState extends State<ForgotpassScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newpassController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool isPassVisible = true;
  bool showPasswordFields = false;

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
    newpassController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (formkey.currentState!.validate() != true) {
      return;
    }

    showProgressDialog(context);

    final QuerySnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('email', isEqualTo: emailController.text.trim())
        .get();

    if (userData.docs.isNotEmpty) {
      if (showPasswordFields) {
        final QueryDocumentSnapshot<Map<String, dynamic>> user =
            userData.docs[0];
        final String passwordHash = PasswordService.hashPassword(
          email: emailController.text.trim(),
          password: newpassController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.id)
            .update({
          'password_hash': passwordHash,
          'password': FieldValue.delete(),
        });

        hideProgress(context);
        showErrorMsg("Password reset successfully", Colors.green);
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        hideProgress(context);
        setState(() {
          showPasswordFields = true;
        });
      }
    } else {
      hideProgress(context);
      showErrorMsg("User not found", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  showPasswordFields
                      ? "Enter your new password"
                      : "Verify your email to continue",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
                        "Reset Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        showPasswordFields
                            ? "Create a new strong password"
                            : "Step 1: verify your registered email",
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.blueGrey.shade600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        readOnly: showPasswordFields,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter email";
                          }
                          final bool isValidEmail = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value.trim());
                          if (!isValidEmail) {
                            return "Invalid email format";
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          label: "Email",
                          hint: "Enter your email",
                          icon: Icons.email_outlined,
                        ),
                      ),
                      if (showPasswordFields) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: newpassController,
                          obscureText: isPassVisible,
                          validator: (value) {
                            if (!showPasswordFields) {
                              return null;
                            }
                            if (value == null || value.isEmpty) {
                              return "Please enter new password";
                            } else if (value.length < 6) {
                              return "Minimum length should be 6";
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            label: "New Password",
                            hint: "Enter new password",
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
                        ),
                      ],
                      const SizedBox(height: 20),
                      appButton(
                        buttonText: showPasswordFields
                            ? "Reset Password"
                            : "Verify Email",
                        onPressed: _submit,
                        bgColor: Colors.blueGrey.shade700,
                      ),
                    ],
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
