import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/Common.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var isPassVisible = true;
  var isConfirmPassVisible = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String selectedGender = "";

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "asset/add-user.png",
                  height: 100,
                  width: 100,
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Create a New Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white,),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
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
                        spreadRadius: 3,
                        blurRadius: 6),
                  ],
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Enter Your Name",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.person, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "Invalid email format";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Enter Your Email",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.email, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: isPassVisible,
                        controller: passwordController,
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
                          labelText: "Enter Your Password",
                          labelStyle: TextStyle(color: Colors.black),
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
                                color: Colors.black),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
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
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Enter Your Phone",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.phone, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                  value: "male",
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  }),
                              Text("Male", style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                  value: "female",
                                  groupValue: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  }),
                              Text("Female", style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                      appButton(
                        buttonText: "Register",
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            showProgressDialog(context);

                            var userData = await FirebaseFirestore.instance
                                .collection('Users')
                                .where('email', isEqualTo: emailController.text.toString())
                                .get();

                            if (userData.docs.isNotEmpty) {
                              hideProgress(context);
                              showErrorMsg("User already registered", Colors.red);
                            } else {
                              CollectionReference users = FirebaseFirestore.instance.collection('Users');
                              await users.add({
                                'Name': nameController.text.toString(),
                                'email': emailController.text.toString(),
                                'password': passwordController.text.toString(),
                                'Phone Number': phoneController.text.toString(),
                                'Gender': selectedGender,
                              });

                              hideProgress(context);
                              showErrorMsg("Registration Successful", Colors.green);
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text.rich(
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.purple),
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


