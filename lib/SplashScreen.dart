import 'package:flutter/material.dart';
import 'package:myfitness/LoginScreen.dart';
import 'package:myfitness/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkIsLogin() async {
    Future.delayed(Duration(seconds: 7), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      if (email != null) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 180)),
          Image.asset(
            "asset/weightlifting.gif",
            height: 320,
            width: 320,
          ),
          SizedBox(height: 20),
          Text(
            "MyFitness",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
          SizedBox(height: 10),
          Text(
            "Go Fit",
            style: TextStyle(fontSize: 20),
          ),
        ],
      )),
    ));
  }
}

