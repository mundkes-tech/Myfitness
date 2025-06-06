import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 50),
                Center(
                    child: Image.asset(
                      "asset/user.png",
                      height: 150,
                      width: 150,
                    )),
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFFFCC),
                        Color(0xFF006666)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 5,
                          blurRadius: 7),
                    ],
                  ),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child:
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                        ),),
                        SizedBox(height: 20),
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
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 20),
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
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: "Enter your password",
                            hintStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isPassVisible = !isPassVisible;
                                  });
                                },
                                child: Icon(isPassVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined, color: Colors.black)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: appButton(
                                  buttonText: "Login",
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (formkey.currentState!.validate() == true) {
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
                                        showErrorMsg("User not found", Colors.red);
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
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotpassScreen()),
                    );
                  },
                  child: Text.rich(
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.purple),
                    TextSpan(
                      children: [
                        TextSpan(
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

