import 'dart:io';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:myfitness/dailyroutine.dart';
import 'package:myfitness/LoginScreen.dart';
import 'package:myfitness/TimerScreen.dart';
import 'package:myfitness/myplanScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addplanScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String value = "";
  var key = GlobalKey<ScaffoldState>();

  String name = "";
  String email = "";
  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("Name") ?? "No data";
    name = prefs.getString("email") ?? "No data";
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          exit(0);
          return false;
        },
        child: Scaffold(
            key: key,
            drawer: Drawer(
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle_outlined, size: 30),
                        title: Text("${name}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Text("${email}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      )
                    ],
                  ),
                  Divider(color: Colors.pink, endIndent: 16, indent: 16,height: 16),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Divider(color: Colors.pink, endIndent: 16, indent: 16),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => dailyroutine()));
                    },
                    leading: Icon(Icons.sports_gymnastics),
                    title: Text("Daily Routine",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black))
                  ),
                  Divider(color: Colors.pink, endIndent: 16, indent: 16),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => addplanScreen()));
                    },
                    leading: Icon(Icons.add_box_outlined),
                    title: Text("Add Plan",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Divider(color: Colors.pink, endIndent: 16, indent: 16),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => myplanScreen()));
                    },
                    leading: Icon(Icons.fitness_center_sharp),
                    title: Text("My Plans",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Divider(color: Colors.pink, endIndent: 16, indent: 16),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TimerScreen()));
                    },
                    leading: Icon(Icons.timer),
                    title: Text("Timer",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Divider(color: Colors.pink, endIndent: 16, indent: 16),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    onTap: () {
                      var dialog = AlertDialog(
                        content: Text("Do you want to logout?"),
                        actions: [
                          Text("No"),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                  (Route<dynamic> route) => false);
                            },
                            child: Text("Yes"),
                          )
                        ],
                      );

                      showDialog(
                          context: context,
                          builder: (builder) {
                            return dialog;
                          });
                    },
                  ),

                ],
              ),
            ),


            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  key.currentState!.openDrawer();
                },
                child: Icon(
                  Icons.menu_outlined,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blue,
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: AnotherCarousel(
                      images: const [
                        AssetImage("asset/1.jpg"),
                        AssetImage("asset/2.jpg"),
                        AssetImage("asset/3.jpg"),
                      ],
                      dotSize: 6,
                      indicatorBgPadding: 2,
                    ),
                  ),
                  Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          top: 5,
                          bottom: 5,
                          right: 16,
                        ),
                        child: Center(
                          child: Text(
                            'Different Body Part Workouts',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  GestureDetector(
                    child : Container(
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
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child : Row(
                            children: [
                              Image.asset('asset/bench-press.jpg', alignment: Alignment.centerLeft),
                              SizedBox(width: 20),
                              Text("Chest",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                            ]
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
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
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child:Row(
                              children: [
                                Image.asset('asset/back.jpg', alignment: Alignment.centerLeft),
                                SizedBox(width: 20),
                                Text("Human Back",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                              ]
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
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
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child:Row(
                              children: [
                                Image.asset('asset/plank.jpg', alignment: Alignment.centerLeft),
                                SizedBox(width: 20),
                                Text("Abbs",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                              ]
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
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
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child:Row(
                            children: [
                              Image.asset('asset/workout.jpg', alignment: Alignment.centerLeft),
                              SizedBox(width: 20),
                              Text("Bicep Muscle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                            ]
                        ),
                      )
                  ),
                  ),
                  GestureDetector(
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
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child:Row(
                            children: [
                              Image.asset('asset/squat.jpg', alignment: Alignment.centerLeft),
                              SizedBox(width: 20),
                              Text("Leg",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                            ]
                        ),
                      )
                  ),
                  )
                ])));
  }
}
