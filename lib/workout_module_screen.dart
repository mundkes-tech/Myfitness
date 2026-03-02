import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/services/session_service.dart';

class WorkoutModuleScreen extends StatefulWidget {
  final String moduleTitle;
  final String collectionName;

  const WorkoutModuleScreen({
    super.key,
    required this.moduleTitle,
    required this.collectionName,
  });

  @override
  State<WorkoutModuleScreen> createState() => _WorkoutModuleScreenState();
}

class _WorkoutModuleScreenState extends State<WorkoutModuleScreen> {
  final ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  List<Map<String, dynamic>> workouts = [];
  Set<String> completedWorkoutIds = {};
  bool isLoading = true;
  String? errorMessage;
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(_initialize);
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    currentUserEmail = await SessionService.getUserEmail() ?? '';
    await fetchWorkouts();
  }

  String _progressDocId() {
    return '${currentUserEmail}_${widget.collectionName}';
  }

  String _workoutId(Map<String, dynamic> workout, [int? index]) {
    final String? fromDoc = workout['__id']?.toString();
    if (fromDoc != null && fromDoc.isNotEmpty) {
      return fromDoc;
    }

    final String? fromName = workout['name']?.toString();
    if (fromName != null && fromName.isNotEmpty) {
      return fromName;
    }

    return 'workout_${index ?? 0}';
  }

  int get _completedExercises {
    final Set<String> validIds = workouts.map((w) => _workoutId(w)).toSet();
    return completedWorkoutIds.where(validIds.contains).length;
  }

  Future<void> _loadProgressForModule() async {
    if (currentUserEmail.isEmpty) {
      return;
    }

    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('workout_progress')
            .doc(_progressDocId())
            .get();

    if (!snapshot.exists) {
      completedWorkoutIds = {};
      return;
    }

    final Map<String, dynamic>? data = snapshot.data();
    final List<dynamic> rawIds = (data?['completed_ids'] as List?) ?? [];
    completedWorkoutIds = rawIds.map((e) => e.toString()).toSet();
  }

  Future<void> _saveProgressForModule() async {
    if (currentUserEmail.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('workout_progress')
        .doc(_progressDocId())
        .set({
      'user_email': currentUserEmail,
      'module': widget.collectionName,
      'completed_ids': completedWorkoutIds.toList(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _resetProgressForModule() async {
    completedWorkoutIds = {};
    await _saveProgressForModule();
    setState(() {});
  }

  Future<void> _confirmAndResetProgress() async {
    final bool shouldReset = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset Progress'),
            content: const Text(
              'Do you want to clear your completed exercises for this module?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!shouldReset) {
      return;
    }

    await _resetProgressForModule();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress reset for this module.')),
    );
  }

  Future<void> fetchWorkouts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(widget.collectionName)
              .get();

      workouts = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> mapData = doc.data();
        mapData['__id'] = doc.id;
        return mapData;
      }).toList();

      await _loadProgressForModule();
    } catch (error) {
      errorMessage = "Failed to load workouts. Please try again.";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> completeWorkout(String workoutId) async {
    if (completedWorkoutIds.contains(workoutId)) {
      return;
    }

    final int completedBefore = _completedExercises;

    setState(() {
      completedWorkoutIds.add(workoutId);
      if (completedBefore != workouts.length &&
          _completedExercises == workouts.length &&
          workouts.isNotEmpty) {
        confettiController.play();
      }
    });

    await _saveProgressForModule();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = workouts.isEmpty
        ? 0
        : (_completedExercises / workouts.length).clamp(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.moduleTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset Progress',
            onPressed: _confirmAndResetProgress,
            icon: const Icon(Icons.restart_alt, color: Colors.black87),
          ),
        ],
        backgroundColor: const Color(0xFFB2EBF2),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 700),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white,
                      color: const Color(0xFF4DB6AC),
                      minHeight: 8,
                    );
                  },
                ),
              ),
              Expanded(child: _buildBodyContent()),
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

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: fetchWorkouts,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (workouts.isEmpty) {
      return const Center(
        child: Text(
          'No workouts found.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workouts.length,
      itemBuilder: (context, index) {
        final workout = workouts[index];
        final String workoutId = _workoutId(workout, index);
        final bool isCompleted = completedWorkoutIds.contains(workoutId);

        return FadeInUp(
          duration: Duration(milliseconds: 350 + (index * 70)),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      WorkoutExerciseDetailScreen(
                    workout: workout,
                    isCompleted: isCompleted,
                    onComplete: () => completeWorkout(workoutId),
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    workout["image"] ?? '',
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                title: Text(
                  workout["name"] ?? 'Workout',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF4DB6AC),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class WorkoutExerciseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> workout;
  final bool isCompleted;
  final VoidCallback onComplete;

  const WorkoutExerciseDetailScreen({
    super.key,
    required this.workout,
    required this.isCompleted,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> instructions =
        List<String>.from(workout["instructions"] ?? []);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          workout['name'] ?? "Exercise",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/background form.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 80),
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
                            workout["intro_image"] ?? '',
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 36,
                                ),
                              ),
                            ),
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(-5, -5)),
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(5, 5)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🎯 Target Muscles: ${workout['muscles'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "📌 Instructions:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: instructions.map<Widget>((line) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "• ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellowAccent,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    line.trim(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: isCompleted
                        ? null
                        : () {
                            onComplete();
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              Navigator.pop(context);
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCompleted ? Colors.grey : Colors.amberAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 15,
                      shadowColor: Colors.yellowAccent.withOpacity(0.8),
                    ),
                    child: Text(
                      isCompleted
                          ? "✔ Already Completed"
                          : "✔ Mark as Complete",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
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
