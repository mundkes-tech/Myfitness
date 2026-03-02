import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Shoulder_workouts extends StatelessWidget {
  const Shoulder_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Shoulder Workouts',
      collectionName: 'Shoulders_workouts',
    );
  }
}
