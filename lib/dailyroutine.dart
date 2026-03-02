import 'package:flutter/material.dart';

class dailyroutine extends StatefulWidget {
  const dailyroutine({super.key});

  @override
  State<dailyroutine> createState() => _dailyroutineState();
}

class _dailyroutineState extends State<dailyroutine> {
  final List<Map<String, String>> routineItems = [
    {
      'title': 'Drink Water',
      'subtitle': '250 ml',
      'image': 'asset/drink-water.png',
    },
    {
      'title': 'Stretching',
      'subtitle': '5 minutes',
      'image': 'asset/exercising.png',
    },
    {
      'title': 'Exercise',
      'subtitle': '30 minutes',
      'image': 'asset/exercise.png',
    },
    {
      'title': 'Meditation',
      'subtitle': '10 minutes',
      'image': 'asset/meditation.png',
    },
    {
      'title': 'Get Sunlight',
      'subtitle': '5 minutes',
      'image': 'asset/sun.png',
    },
    {
      'title': 'Eat Breakfast',
      'subtitle': 'Healthy meal',
      'image': 'asset/eating.png',
    },
  ];

  late final List<bool> completed;

  @override
  void initState() {
    super.initState();
    completed = List<bool>.filled(routineItems.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = completed.where((item) => item).length;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF1F5F9),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Daily Routine",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Completed $completedCount of ${routineItems.length} tasks",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: completedCount / routineItems.length,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: routineItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = routineItems[index];
                    return _buildRoutineCard(
                      index: index,
                      title: item['title']!,
                      subtitle: item['subtitle']!,
                      imagePath: item['image']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoutineCard({
    required int index,
    required String title,
    required String subtitle,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(imagePath),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}. $title",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            activeColor: Colors.teal.shade700,
            value: completed[index],
            onChanged: (val) {
              setState(() {
                completed[index] = val ?? false;
              });
            },
          ),
        ],
      ),
    );
  }
}
