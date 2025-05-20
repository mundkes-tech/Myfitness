// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// class Mind_relaxation_excercises extends StatefulWidget {
//   @override
//   State<Mind_relaxation_excercises> createState() => _Mind_relaxation_excercisesState();
// }
//
// class _Mind_relaxation_excercisesState extends State<Mind_relaxation_excercises> {
//   FlutterTts flutterTts = FlutterTts();
//   List<String> affirmations = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAffirmations();
//   }
//
//   // Fetch affirmations from Firestore
//   Future<void> fetchAffirmations() async {
//     FirebaseFirestore.instance.collection('affirmations').get().then((querySnapshot) {
//       List<String> loadedAffirmations = [];
//       for (var doc in querySnapshot.docs) {
//         loadedAffirmations.add(doc['text']);
//       }
//       setState(() {
//         affirmations = loadedAffirmations;
//       });
//     }).catchError((error) {
//       print("Error fetching affirmations: $error");
//     });
//   }
//
//   // Function to read affirmation aloud
//   void speak(String text) async {
//     await flutterTts.speak(text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Mind Relaxation", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.purple,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.teal.shade300, Colors.teal.shade900],
//           ),
//         ),
//         child: affirmations.isEmpty
//             ? Center(child: CircularProgressIndicator()) // Show loading if data is not yet fetched
//             : ListView.builder(
//           padding: EdgeInsets.all(16),
//           itemCount: affirmations.length,
//           itemBuilder: (context, index) {
//             return FadeInUp(
//               duration: Duration(milliseconds: 500 + (index * 100)),
//               child: Card(
//                 color: Colors.white.withOpacity(0.8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 5,
//                 child: ListTile(
//                   contentPadding: EdgeInsets.all(16),
//                   title: Text(
//                     affirmations[index],
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   trailing: Icon(Icons.volume_up, color: Colors.teal),
//                   onTap: () {
//                     speak(affirmations[index]); // Speak affirmation
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitness/HomeScreen.dart';


class Mind_relaxation_excercises extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MindRelaxationScreen(),
    );
  }
}


class MindRelaxationScreen extends StatelessWidget {
  final CollectionReference activitiesRef =
  FirebaseFirestore.instance.collection('mind_relaxation');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mind Relaxation"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), // 👈 Replace with your Home widget
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: activitiesRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No relaxation activities found."));
            }

            var activities = snapshot.data!.docs.map((doc) {
              return {
                'title': doc['title'] ?? 'No Title',
                'image': doc['image'] ?? 'https://via.placeholder.com/100'
              };
            }).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(activities[index]['title']!),
                          content: Text("Relax and enjoy ${activities[index]['title']} 😊"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            activities[index]['image']!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          activities[index]['title']!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

