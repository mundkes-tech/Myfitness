import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Back_workouts extends StatelessWidget {
  const Back_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Back Workouts',
      collectionName: 'back_workouts',
    );
  }
}
