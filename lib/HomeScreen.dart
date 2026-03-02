import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:myfitness/DietPlanner.dart';
import 'package:myfitness/services/session_service.dart';
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

  final List<Color> _tabColors = [
    Colors.blueGrey, // Home
    Colors.teal, // Routine
    Colors.purple, // My Plans
    Colors.cyan, // Timer
    Colors.transparent, // More
  ];

  Future<void> getInfo() async {
    final String? savedEmail = await SessionService.getUserEmail();
    final String? savedName = await SessionService.getUserName();
    setState(() {
      email = savedEmail ?? "No data";
      name = savedName ?? "No data";
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
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay in app
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
              _buildMoreItem(
                  Icons.add_box_outlined, "Add Plan", addplanScreen()),
              _buildMoreItem(Icons.food_bank_outlined, "Diet Planner",
                  DietPlannerScreen()),
              _buildMoreItem(Icons.logout, "Logout", null, logout),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreItem(IconData icon, String title, Widget? screen,
      [VoidCallback? action]) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context);
        if (screen != null)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        if (action != null) action();
      },
    );
  }

  void logout() async {
    bool confirmLogout = await _onWillLogout();
    if (confirmLogout) {
      await SessionService.clearSession();
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title:
                Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("No",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold))),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Yes",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold))),
            ],
          ),
        ) ??
        false;
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
        body: _buildCurrentScreen(),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
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
              )),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return HomeContent(
          userName: name,
          onOpenRoutine: () => _onItemTapped(1),
          onOpenMyPlans: () => _onItemTapped(2),
          onOpenTimer: () => _onItemTapped(3),
          onOpenAddPlan: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addplanScreen()),
            );
          },
        );
      case 1:
        return dailyroutine();
      case 2:
        return myplanScreen();
      case 3:
        return TimerScreen();
      default:
        return HomeContent(
          userName: name,
          onOpenRoutine: () => _onItemTapped(1),
          onOpenMyPlans: () => _onItemTapped(2),
          onOpenTimer: () => _onItemTapped(3),
          onOpenAddPlan: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addplanScreen()),
            );
          },
        );
    }
  }
}

class HomeContent extends StatelessWidget {
  final String userName;
  final VoidCallback onOpenRoutine;
  final VoidCallback onOpenMyPlans;
  final VoidCallback onOpenTimer;
  final VoidCallback onOpenAddPlan;

  HomeContent({
    super.key,
    required this.userName,
    required this.onOpenRoutine,
    required this.onOpenMyPlans,
    required this.onOpenTimer,
    required this.onOpenAddPlan,
  });

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
          image: AssetImage("asset/background_home.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty && userName != "No data"
                          ? "Welcome, $userName"
                          : "Welcome to MyFitness",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Start your day with a quick workout and stay consistent.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _quickActionButton(
                          icon: Icons.sports_gymnastics,
                          label: "Routine",
                          onTap: onOpenRoutine,
                        ),
                        _quickActionButton(
                          icon: Icons.list_alt,
                          label: "My Plans",
                          onTap: onOpenMyPlans,
                        ),
                        _quickActionButton(
                          icon: Icons.timer,
                          label: "Timer",
                          onTap: onOpenTimer,
                        ),
                        _quickActionButton(
                          icon: Icons.add_circle_outline,
                          label: "Add Plan",
                          onTap: onOpenAddPlan,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: Colors.black,
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
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 14, 18, 4),
              child: Text(
                'Workout Categories',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            GridView.builder(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                    navigateToWorkout(
                        context, workoutCategories[index]["title"]!);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWorkoutCard(
      {required Map<String, String> category, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(category["image"]!, height: 85),
            SizedBox(height: 10),
            Text(category["title"]!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
