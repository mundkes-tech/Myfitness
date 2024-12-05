import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myfitness/ForgotpassScreen.dart';
import 'package:myfitness/HomeScreen.dart';
import 'Common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isPassVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                    child: Image.asset(
                  "asset/account.png",
                  height: 150,
                  width: 150,
                )),
                SizedBox(height: 30),

                Container(
                  // width: double.infinity,
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
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Invalid Email";
                            } else if (RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value) ==
                                false) {
                              return "Invalid Email format";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Enter Your Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: passwordController,
                          obscureText: isPassVisible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Invalid Password";
                            } else if (value!.length < 6) {
                              return "Mininmum length should be 6.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Enter Your Password",
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: appButton(
                                  buttonText: "Login",
                                  onPressed: () async {
                                    if (formkey.currentState!.validate() ==
                                        true) {
                                      showProgressDialog(context);

                                      var userData = await FirebaseFirestore
                                          .instance
                                          .collection('Users')
                                          .where(
                                            'email',
                                            isEqualTo:
                                                emailController.text.toString(),
                                          )
                                          .where(
                                            'password',
                                            isEqualTo: passwordController.text
                                                .toString(),
                                          )
                                          .get();
                                      hideProgress(context);
                                      if (userData.docs.length > 0) {
                                        var userInfo = userData.docs[0];

                                        var mapData = userInfo.data();

                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setString(
                                            'email', mapData['Name']);
                                        await prefs.setString(
                                            'Name', mapData['email']);
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      } else {
                                        showErrorMsg("User not found",Colors.red);
                                      }
                                    }
                                  }),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: appButton(
                                buttonText: "Signup",
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen()));
                                },
                                bgColor: Colors.redAccent,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotpassScreen()),
                    );
                  },
                  child: Text.rich(
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                    TextSpan(
                      children: [
                        TextSpan(
                            text: "Forgot Password",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight
                                    .bold) // style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
