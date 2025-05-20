// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:another_carousel_pro/another_carousel_pro.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Chest_workouts.dart'; // Ensure these imports are correct
// import 'Back_workouts.dart';
// import 'Shoulder_workouts.dart';
// import 'Abs_workouts.dart';
// import 'Legs_workouts.dart';
// import 'Biceps_workouts.dart';
// import 'Triceps_workouts.dart';
// import 'Mind_relaxation_excercises.dart';
// import 'Forearms_workouts.dart';
// import 'package:myfitness/dailyroutine.dart'; // Ensure these imports are correct
// import 'package:myfitness/LoginScreen.dart';
// import 'package:myfitness/TimerScreen.dart';
// import 'package:myfitness/myplanScreen.dart';
// import 'package:myfitness/addplanScreen.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String name = "";
//   String email = "";
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     HomeContent(), // Home screen content
//     dailyroutine(),
//     myplanScreen(),
//     TimerScreen()
//   ];
//
//   Future<void> getInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       email = prefs.getString("email") ?? "No data";
//       name = prefs.getString("Name") ?? "No data";
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getInfo();
//   }
//
//   void _onItemTapped(int index) {
//     if (index == 4) {
//       _showMoreMenu(); // Show bottom sheet instead of switching screens
//       return;
//     }
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//
//   void _showMoreMenu() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildMoreItem(Icons.add_box_outlined, "Add Plan", addplanScreen()),
//               _buildMoreItem(Icons.logout, "Logout", null, logout),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildMoreItem(IconData icon, String title, Widget? screen, [VoidCallback? action]) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.black),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       onTap: () {
//         Navigator.pop(context);
//         if (screen != null) Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
//         if (action != null) action();
//       },
//     );
//   }
//
//   void logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//           (route) => false,
//     );
//   }
//
//   Future<bool> _onWillPop() async {
//     return await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Exit App"),
//         content: Text("Are you sure you want to exit?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: Text("No"),
//           ),
//           TextButton(
//             onPressed: () {
//               if (Platform.isAndroid) {
//                 SystemNavigator.pop();
//               } else if (Platform.isIOS) {
//                 exit(0);
//               }
//             },
//             child: Text("Yes"),
//           ),
//         ],
//       ),
//     ) ?? false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: _selectedIndex == 0
//             ? AppBar(
//           title: Text("Home", style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.purple,
//           centerTitle: true,
//         )
//             : null, // Hide AppBar for other screens
//         body: _screens[_selectedIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           selectedItemColor: Colors.purple,
//           unselectedItemColor: Colors.grey,
//           backgroundColor: Colors.white,
//           selectedIconTheme: IconThemeData(size: 30, color: Colors.purple),
//           unselectedIconTheme: IconThemeData(size: 24, color: Colors.grey),
//           selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//             BottomNavigationBarItem(icon: Icon(Icons.sports_gymnastics), label: "Routine"),
//             BottomNavigationBarItem(icon: Icon(Icons.list), label: "My Plans"),
//             BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Timer"),
//             BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class HomeContent extends StatelessWidget {
//   final List<Map<String, String>> workoutCategories = [
//     {"title": "Chest", "image": "asset/gym.jpg"},
//     {"title": "Back", "image": "asset/back.jpg"},
//     {"title": "Abs", "image": "asset/abs.jpg"},
//     {"title": "Biceps", "image": "asset/biceps.jpg"},
//     {"title": "Legs", "image": "asset/leg.jpg"},
//     {"title": "Triceps", "image": "asset/triceps.jpg"},
//     {"title": "Shoulders", "image": "asset/shoulder.jpg"},
//     {"title": "Forearms", "image": "asset/forearms.jpg"},
//     {"title": "Mind Relaxation", "image": "asset/mind relaxing.jpg"},
//   ];
//
//   void navigateToWorkout(BuildContext context, String title) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       switch (title) {
//         case "Chest":
//           return Chest_workouts();
//         case "Back":
//           return Back_workouts();
//         case "Abs":
//           return Abs_workouts();
//         case "Biceps":
//           return Biceps_workouts();
//         case "Triceps":
//           return Triceps_workouts();
//         case "Shoulders":
//           return Shoulder_workouts();
//         case "Forearms":
//           return Forearms_workouts();
//         case "Legs":
//           return Legs_workouts();
//         case "Mind Relaxation":
//           return Mind_relaxation_excercises();
//         default:
//           return HomeScreen();
//       }
//     }));
//   }
//
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF0099CC), Color(0xFFCCCCFF)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 220,
//               width: double.infinity,
//               child: AnotherCarousel(
//                 images: [
//                   AssetImage("asset/1.jpg"),
//                   AssetImage("asset/2.jpg"),
//                   AssetImage("asset/3.jpg"),
//                   AssetImage("asset/4.jpg")
//                 ],
//                 dotSize: 4,
//                 indicatorBgPadding: 2,
//                 autoplay: true,
//                 animationCurve: Curves.fastOutSlowIn,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 18).copyWith(top: 8),
//               child: Container(
//                 child: Text(
//                   'Workout Categories',
//                   style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black, // Text color for contrast
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//
//             GridView.builder(
//               padding: EdgeInsets.all(16),
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1.2,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 12,
//               ),
//               itemCount: workoutCategories.length,
//               itemBuilder: (context, index) {
//                 return buildWorkoutCard(
//                   category: workoutCategories[index],
//                   onTap: () {
//                     navigateToWorkout(context, workoutCategories[index]["title"]!);
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildWorkoutCard({required Map<String, String> category, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 7,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(category["image"]!, height: 85),
//             SizedBox(height: 10),
//             Text(category["title"]!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chest_workouts.dart';
import 'Back_workouts.dart';
import 'Shoulder_workouts.dart';
import 'Abs_workouts.dart';
import 'Legs_workouts.dart';
import 'Biceps_workouts.dart';
import 'Triceps_workouts.dart';
import 'Mind_relaxation_excercises.dart';
import 'Forearms_workouts.dart';
import 'package:myfitness/dailyroutine.dart';
import 'package:myfitness/LoginScreen.dart';
import 'package:myfitness/TimerScreen.dart';
import 'package:myfitness/myplanScreen.dart';
import 'package:myfitness/addplanScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  String email = "";
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    dailyroutine(),
    myplanScreen(),
    TimerScreen()
  ];

  final List<Color> _tabColors = [
    Colors.blueGrey,   // Home
    Colors.teal,  // Routine
    Colors.purple,    // My Plans
    Colors.cyan, // Timer
    Colors.transparent, // More
  ];

  Future<void> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email") ?? "No data";
      name = prefs.getString("Name") ?? "No data";
    });
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Exit App"),
        content: Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in app
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Exit the app
            },
            child: Text("Yes"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }


  void _onItemTapped(int index) async {
    if (index == 4) {
      // Don't change selected index, just open More menu
      await _showMoreMenu();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }



  Future<void> _showMoreMenu() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMoreItem(Icons.add_box_outlined, "Add Plan", addplanScreen()),
              _buildMoreItem(Icons.logout, "Logout", null, logout),
            ],
          ),
        );
      },
    );
  }


  Widget _buildMoreItem(IconData icon, String title, Widget? screen, [VoidCallback? action]) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        if (screen != null) Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        if (action != null) action();
      },
    );
  }

  void logout() async {
    bool confirmLogout = await _onWillLogout();
    if (confirmLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
      );
    }
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Daily Routine";
      case 2:
        return "My Plans";
      case 3:
        return "Timer";
      case 4:
        return "More";
      default:
        return "Home";
    }
  }

  Future<bool> _onWillLogout() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text("No", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Yes", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    ) ?? false;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            _getAppBarTitle(_selectedIndex),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: _tabColors[_selectedIndex],
          centerTitle: true,
        ),
        body: _screens[_selectedIndex],

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                haptic: false,
                backgroundColor: Colors.white,
                color: Colors.grey,
                activeColor: Colors.white,
                tabBackgroundColor: _tabColors[_selectedIndex],
                gap: 8,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
                tabs: const [
                  GButton(icon: Icons.home, text: 'Home'),
                  GButton(icon: Icons.sports_gymnastics, text: 'Routine'),
                  GButton(icon: Icons.list, text: 'My Plans'),
                  GButton(icon: Icons.timer, text: 'Timer'),
                  GButton(icon: Icons.more_horiz, text: 'More'),
                ],
              )
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Map<String, String>> workoutCategories = [
    {"title": "Chest", "image": "asset/gym.png"},
    {"title": "Back", "image": "asset/back.png"},
    {"title": "Abs", "image": "asset/abs.png"},
    {"title": "Biceps", "image": "asset/biceps.png"},
    {"title": "Legs", "image": "asset/leg.png"},
    {"title": "Triceps", "image": "asset/triceps.png"},
    {"title": "Shoulders", "image": "asset/shoulder.png"},
    {"title": "Forearms", "image": "asset/forearms.png"},
    {"title": "Mind Relaxation", "image": "asset/mind_relaxing.png"},
  ];

  void navigateToWorkout(BuildContext context, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      switch (title) {
        case "Chest":
          return Chest_workouts();
        case "Back":
          return Back_workouts();
        case "Abs":
          return Abs_workouts();
        case "Biceps":
          return Biceps_workouts();
        case "Triceps":
          return Triceps_workouts();
        case "Shoulders":
          return Shoulder_workouts();
        case "Forearms":
          return Forearms_workouts();
        case "Legs":
          return Legs_workouts();
        case "Mind Relaxation":
          return Mind_relaxation_excercises();
        default:
          return HomeScreen();
      }
    }));
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("asset/background_home.jpg"), // Set your background image
          fit: BoxFit.cover, // Ensures the image covers the entire background
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 225,
              width: double.infinity,
              child: Container( // Wrap carousel with a separate background
                decoration: BoxDecoration(
                  color: Colors.black, // ✅ Prevent background image from affecting it
                ),
                child: AnotherCarousel(
                  images: [
                    AssetImage("asset/1.jpg"),
                    AssetImage("asset/2.jpg"),
                    AssetImage("asset/3.jpg"),
                    AssetImage("asset/4.jpg")
                  ],
                  dotSize: 4,
                  indicatorBgPadding: 2,
                  autoplay: true,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(seconds: 2),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18).copyWith(top: 8),
              child: Container(
                child: Text(
                  'Workout Categories',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            GridView.builder(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
              ),
              itemCount: workoutCategories.length,
              itemBuilder: (context, index) {
                return buildWorkoutCard(
                  category: workoutCategories[index],
                  onTap: () {
                    navigateToWorkout(context, workoutCategories[index]["title"]!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWorkoutCard({required Map<String, String> category, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(category["image"]!, height: 85),
            SizedBox(height: 10),
            Text(category["title"]!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

