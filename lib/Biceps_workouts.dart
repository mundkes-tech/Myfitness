import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class Biceps_workouts extends StatefulWidget {
  @override
  _Biceps_workoutsState createState() => _Biceps_workoutsState();
}

class _Biceps_workoutsState extends State<Biceps_workouts> {
  FlutterTts flutterTts = FlutterTts();
  List<Map<String, dynamic>> workouts = [];
  int completedExercises = 0;
  ConfettiController confettiController = ConfettiController(duration: Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    FirebaseFirestore.instance.collection('Biceps_workouts').get().then((querySnapshot) {
      List<Map<String, dynamic>> loadedWorkouts = [];
      for (var doc in querySnapshot.docs) {
        loadedWorkouts.add(doc.data());
      }
      setState(() {
        workouts = loadedWorkouts;
      });
    }).catchError((error) {
      print("Error fetching workouts: $error");
    });
  }

  void completeWorkout(int index) {
    setState(() {
      completedExercises++;
      if (completedExercises == workouts.length) {
        confettiController.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biceps Workouts", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFB2EBF2), // Cool & Calm Theme
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: completedExercises / (workouts.isEmpty ? 1 : workouts.length)),
                  duration: Duration(seconds: 1),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white,
                      color: Color(0xFF4DB6AC), // Refreshing Aqua Progress
                      minHeight: 8,
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      duration: Duration(milliseconds: 500 + (index * 100)),
                      child: GestureDetector(
                        onTap: () {
                          if (workouts[index] != null) {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    ExerciseDetailPage(
                                      workout: workouts[index],
                                      onComplete: () => completeWorkout(index),
                                    ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(1, 0),
                                      end: Offset(0, 0),
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.white,
                          elevation: 3,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Image.network(workouts[index]["image"], width: 70),
                            title: Text(
                              workouts[index]["name"],
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF4DB6AC)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseDetailPage extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onComplete;

  ExerciseDetailPage({required this.workout, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    List<String> instructions = List<String>.from(workout["instructions"] ?? []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          workout['name'] ?? "Exercise",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          /// ✅ **Background Image**
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/background form.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ✅ **Gradient Overlay for Readability**
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          /// ✅ **Main Content**
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ **Exercise Image with Glass Effect**
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.network(
                            workout["intro_image"],
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// ✅ **Workout Details Card (Glassmorphism Effect)**
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 10, offset: Offset(-5, -5)),
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: Offset(5, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎯 Target Muscles: ${workout['muscles'] ?? 'N/A'}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),

                      Text("📌 Instructions:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: instructions.map<Widget>((line) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                                Expanded(
                                  child: Text(
                                    line.trim(),
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                /// ✅ **Interactive Button with Animation**
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onComplete();
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      "✔ Mark as Complete",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 15,
                      shadowColor: Colors.yellowAccent.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}