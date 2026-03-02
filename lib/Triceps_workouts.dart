import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Triceps_workouts extends StatelessWidget {
  const Triceps_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Triceps Workouts',
      collectionName: 'Triceps_workouts',
    );
  }
}
