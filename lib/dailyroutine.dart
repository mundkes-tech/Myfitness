import 'package:flutter/material.dart';

class dailyroutine extends StatefulWidget{
  @override
  State<dailyroutine> createState() => _dailyroutineState();
}

class _dailyroutineState extends State<dailyroutine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.blue,
        //   automaticallyImplyLeading: false,
        //   title: Text(
        //     "Daily Schedule",
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        body: SingleChildScrollView(
        child: Column(
            children: [
                  Container(
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
                    height: 95,
                    width: double.infinity,
                    child : Row(
                        children: [
                          Image.asset('asset/drink-water.png',height: 100, alignment: Alignment.centerLeft),
                          SizedBox(width: 20),
                          Text("1. Drink Water(250 ml)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                        ]
                    ),
                  ),
                ),
                Container(
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
                    height: 95,
                    width: double.infinity,
                    child : Row(
                        children: [
                          Image.asset('asset/exercising.png',height: 100, alignment: Alignment.centerLeft),
                          SizedBox(width: 20),
                          Text("2. Stretching(5 minutes)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                        ]
                    ),
                  ),
                ),
                Container(
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
                      height: 95,
                      width: double.infinity,
                      child:Row(
                          children: [
                            Image.asset('asset/exercise.png',height: 100, alignment: Alignment.centerLeft),
                            SizedBox(width: 20),
                            Text("3. Exercise(30 minutes)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                          ]
                      ),
                    )
                ),
                Container(
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
                      height: 95,
                      width: double.infinity,
                      child:Row(
                          children: [
                            Image.asset('asset/meditation.png',height: 100, alignment: Alignment.centerLeft),
                            SizedBox(width: 20),
                            Text("4. Meditation(10 minutes)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                          ]
                      ),
                    )
                ),
                Container(
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
                      height: 95,
                      width: double.infinity,
                      child:Row(
                          children: [
                            Image.asset('asset/sun.png',height: 100, alignment: Alignment.centerLeft),
                            SizedBox(width: 20),
                            Text("5. Get some sunlight(5 mins)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                          ]
                      ),
                    )
                ),
                Container(
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
                      height: 95,
                      width: double.infinity,
                      child:Row(
                          children: [
                            Image.asset('asset/eating.png',height: 100, alignment: Alignment.centerLeft),
                            SizedBox(width: 20),
                            Text("6. Eat breakfast",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                          ]
                      ),
                    )
                ),
            ])
        )
    );
  }
}