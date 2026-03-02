import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Chest_workouts extends StatelessWidget {
  const Chest_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Chest Workouts',
      collectionName: 'chest_workouts',
    );
  }
}
