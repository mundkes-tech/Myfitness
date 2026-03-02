import 'Common.dart';
import 'package:flutter/material.dart';
import 'package:myfitness/services/plan_service.dart';
import 'package:myfitness/services/session_service.dart';

class addplanScreen extends StatefulWidget {
  const addplanScreen({super.key});

  @override
  State<addplanScreen> createState() => _addplanScreenState();
}

class _addplanScreenState extends State<addplanScreen> {
  var formkey = GlobalKey<FormState>();
  final PlanService _planService = PlanService();

  TextEditingController planNameController = TextEditingController();
  TextEditingController plantimeController = TextEditingController();
  String currentUserEmail = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    currentUserEmail = await SessionService.getUserEmail() ?? "";
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
      prefixIcon: Icon(icon, color: Colors.blueGrey.shade700),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade700, width: 1.5),
      ),
    );
  }

  @override
  void dispose() {
    planNameController.dispose();
    plantimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey.shade900,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Add Your Plan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.event_note,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Create a workout plan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Fill in plan details to organize your daily routine.",
                        style: TextStyle(
                          color: Colors.blueGrey.shade600,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: planNameController,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter plan name";
                          }
                          if (value.trim().length < 3) {
                            return "Plan name should be at least 3 characters";
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          label: "Plan Name",
                          hint: "Example: Morning Strength",
                          icon: Icons.fitness_center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: plantimeController,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter plan time";
                          }
                          return null;
                        },
                        decoration: _inputDecoration(
                          label: "Plan Time",
                          hint: "Example: 6:30 AM",
                          icon: Icons.schedule,
                        ),
                      ),
                      const SizedBox(height: 20),
                      appButton(
                        buttonText: "Add",
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          if (formkey.currentState!.validate() == true) {
                            currentUserEmail =
                                await SessionService.getUserEmail() ?? "";

                            if (currentUserEmail.isEmpty) {
                              showErrorMsg(
                                "Session expired. Please login again.",
                                Colors.red,
                              );
                              return;
                            }

                            showProgressDialog(context);

                            await _planService.addPlan(
                              planName: planNameController.text.trim(),
                              planTime: plantimeController.text.trim(),
                              userEmail: currentUserEmail,
                            );

                            hideProgress(context);
                            showErrorMsg(
                                "Plan added successfully", Colors.green);
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        bgColor: Colors.blueGrey.shade800,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
