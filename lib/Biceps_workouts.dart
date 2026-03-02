import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Biceps_workouts extends StatelessWidget {
  const Biceps_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Biceps Workouts',
      collectionName: 'Biceps_workouts',
    );
  }
}
