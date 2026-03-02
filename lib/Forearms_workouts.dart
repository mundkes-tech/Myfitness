import 'package:flutter/material.dart';
import 'package:myfitness/workout_module_screen.dart';

class Forearms_workouts extends StatelessWidget {
  const Forearms_workouts({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkoutModuleScreen(
      moduleTitle: 'Forearms Workouts',
      collectionName: 'Forearms_workouts',
    );
  }
}
