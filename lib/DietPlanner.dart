import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(DietPlannerApp());

class DietPlannerApp extends StatelessWidget {
  const DietPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet Planner',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Arial',
      ),
      home: DietPlannerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DietPlannerScreen extends StatefulWidget {
  const DietPlannerScreen({super.key});

  @override
  State<DietPlannerScreen> createState() => _DietPlannerScreenState();
}

class _DietPlannerScreenState extends State<DietPlannerScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? _age;
  double? _height;
  double? _weight;
  String? _gender;
  String? _activityLevel;
  bool _isLoading = false;
  String _dietPlan = '';

  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      isDense: true,
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.green.shade700),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
      ),
    );
  }

  Future<void> _generateDietPlan() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    _dietPlan = '''
  Profile Summary:
  - Age: ${_age ?? '-'} years
  - Height: ${_height ?? '-'} cm
  - Weight: ${_weight ?? '-'} kg
  - Gender: ${_gender ?? '-'}
  - Activity: ${_activityLevel ?? '-'}

Here is a diet plan for you:

🕒 Breakfast
- Oatmeal with banana
- Boiled egg
- Green tea

🍴 Lunch
- Grilled chicken
- Brown rice
- Steamed vegetables

🥛 Snack
- Greek yogurt or a handful of almonds

🍽 Dinner
- Baked salmon
- Quinoa
- Mixed greens salad

🥤 Stay hydrated and try to get 7–8 hours of sleep.
''';

    setState(() => _isLoading = false);

    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Your Diet Plan'),
        content: SingleChildScrollView(
          child: Text(
            _dietPlan,
            style: const TextStyle(height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedForm() {
    return FadeTransition(
      opacity: _fadeIn,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildNumberField(
              label: "Age",
              hint: "Enter your age",
              icon: Icons.cake_outlined,
              onSave: (val) => _age = int.tryParse(val ?? ''),
            ),
            _buildNumberField(
              label: "Height (cm)",
              hint: "Enter height in cm",
              icon: Icons.height,
              onSave: (val) => _height = double.tryParse(val ?? ''),
            ),
            _buildNumberField(
              label: "Weight (kg)",
              hint: "Enter weight in kg",
              icon: Icons.monitor_weight_outlined,
              onSave: (val) => _weight = double.tryParse(val ?? ''),
            ),
            _buildDropdown(
              label: "Gender",
              icon: Icons.person_outline,
              items: const ['Male', 'Female'],
              value: _gender,
              onChanged: (val) => _gender = val,
            ),
            _buildDropdown(
              label: "Activity Level",
              icon: Icons.directions_run,
              items: const ['Sedentary', 'Moderate', 'Active'],
              value: _activityLevel,
              onChanged: (val) => _activityLevel = val,
            ),
            const SizedBox(height: 20),
            appActionButton(),
          ],
        ),
      ),
    );
  }

  Widget appActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.auto_awesome),
        onPressed: _isLoading ? null : _generateDietPlan,
        label: Text(_isLoading ? 'Generating...' : 'Generate Diet Plan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required String hint,
    required IconData icon,
    required Function(String?) onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: _inputDecoration(label: label, hint: hint, icon: icon),
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val == null || val.trim().isEmpty) {
            return 'Required';
          }
          final double? parsed = double.tryParse(val.trim());
          if (parsed == null || parsed <= 0) {
            return 'Enter a valid value';
          }
          return null;
        },
        onChanged: onSave,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(
          label: label,
          hint: "Select $label",
          icon: icon,
        ),
        value: value,
        hint: Text("Select $label"),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (val) => setState(() => onChanged(val)),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planner'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, const Color(0xFFF8FAFC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personalized Diet Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Provide your details to generate a balanced meal plan.',
                      style: TextStyle(color: Colors.white70, fontSize: 13.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _isLoading
                    ? Column(
                        children: const [
                          SizedBox(height: 12),
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Generating your diet plan...",
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 12),
                        ],
                      )
                    : _buildAnimatedForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
