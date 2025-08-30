import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(DietPlannerApp());

class DietPlannerApp extends StatelessWidget {
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
  @override
  _DietPlannerScreenState createState() => _DietPlannerScreenState();
}

class _DietPlannerScreenState extends State<DietPlannerScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  int? _age;
  double? _height;
  double? _weight;
  String? _gender;
  String? _activityLevel;
  bool _isLoading = false;
  String _dietPlan = '';

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateDietPlan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(Duration(seconds: 2)); // Simulate AI delay

    // 👉 Replace this dummy response with your OpenAI API response
    _dietPlan = '''
Here is a diet plan for you:

🕒 **Breakfast**
- Oatmeal with banana
- Boiled egg
- Green tea

🍴 **Lunch**
- Grilled chicken
- Brown rice
- Steamed vegetables

🥛 **Snack**
- Greek yogurt or a handful of almonds

🍽 **Dinner**
- Baked salmon
- Quinoa
- Mixed greens salad

🥤 Stay hydrated and try to get 7–8 hours of sleep.
''';

    setState(() => _isLoading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Your Diet Plan'),
        content: SingleChildScrollView(child: Text(_dietPlan)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
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
            _buildNumberField("Age", (val) => _age = int.tryParse(val!)),
            _buildNumberField("Height (cm)", (val) => _height = double.tryParse(val!)),
            _buildNumberField("Weight (kg)", (val) => _weight = double.tryParse(val!)),
            _buildDropdown(
                label: "Gender",
                items: ['Male', 'Female'],
                value: _gender,
                onChanged: (val) => _gender = val),
            _buildDropdown(
                label: "Activity Level",
                items: ['Sedentary', 'Moderate', 'Active'],
                value: _activityLevel,
                onChanged: (val) => _activityLevel = val),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.auto_awesome),
              onPressed: _generateDietPlan,
              label: Text('Generate Diet Plan'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
        onChanged: onSave,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: value,
        hint: Text("Select $label"),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => setState(() => onChanged(val)),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diet Planner'),
        centerTitle: true,
        elevation: 5,
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green.shade100, Colors.white]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: _isLoading
                ? Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Generating your diet plan...", style: TextStyle(fontSize: 16)),
              ],
            )
                : _buildAnimatedForm(),
          ),
        ),
      ),
    );
  }
}
