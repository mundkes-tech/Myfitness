import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Abs_workouts extends StatelessWidget {
  const Abs_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Abs Workouts',
      collectionName: 'abs_workouts',
    );
  }
}
