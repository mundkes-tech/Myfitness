import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Legs_workouts extends StatelessWidget {
  const Legs_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Legs Workouts',
      collectionName: 'legs_workouts',
    );
  }
}
