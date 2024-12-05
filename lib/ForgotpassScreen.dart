import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Common.dart';

class ForgotpassScreen extends StatefulWidget {
  @override
  State<ForgotpassScreen> createState() => _ForgotpassScreenState();
}

class _ForgotpassScreenState extends State<ForgotpassScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController newpassController = TextEditingController();
  var isPassVisible = true;
  var formkey = GlobalKey<FormState>();
  bool showPasswordFields = false;
  bool isEmailReadOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Forgot Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2),
                ],
              ),
              child: Center(
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Text("Reset Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                      SizedBox(height: 25),
                      TextFormField(
                        readOnly: showPasswordFields,
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Invalid Email";
                          } else if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!) ==
                              false) {
                            return "Invalid Email format";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: newpassController,
                        obscureText: isPassVisible,
                        validator: (value) {
                          if (value!.isEmpty) {

                            return "Invalid Password";
                          } else if (value.length < 6) {
                            return "Minimum length should be 6.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Enter New Password",
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isPassVisible == true) {
                                    isPassVisible = false;
                                  } else {
                                    isPassVisible = true;
                                  }
                                });
                              },
                              child: Icon(isPassVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off_outlined)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      appButton(
                          buttonText: "Submit",
                          onPressed: () async {
                            if (formkey.currentState!.validate() == true) {
                              showProgressDialog(context);

                              var userData = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .where(
                                    'email',
                                    isEqualTo: emailController.text.toString(),
                                  )
                                  .get();

                              if (userData.docs.length > 0) {
                                if (showPasswordFields == true) {
                                  var user = userData.docs[0];
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(user.id)
                                      .update({
                                    'password': newpassController.text.toString()
                                  });

                                  hideProgress(context);
                                  showErrorMsg("Password reset successfully.",Colors.green);
                                  Navigator.pop(context);
                                } else {
                                  hideProgress(context);
                                  setState(() {
                                    showPasswordFields = true;
                                    isEmailReadOnly = true;
                                  });
                                }
                              } else {
                                hideProgress(context);
                                showErrorMsg("User not found",Colors.red);
                              }
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        )));
  }
}
