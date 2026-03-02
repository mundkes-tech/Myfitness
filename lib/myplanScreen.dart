import 'package:flutter/material.dart';
import 'package:myfitness/services/plan_service.dart';
import 'package:myfitness/services/session_service.dart';
import 'Common.dart';
import 'planModel.dart';

class myplanScreen extends StatefulWidget {
  const myplanScreen({super.key});

  @override
  State<myplanScreen> createState() => _myplanScreenState();
}

class _myplanScreenState extends State<myplanScreen> {
  var key = GlobalKey<ScaffoldState>();
  final PlanService _planService = PlanService();

  bool isNoData = false;
  bool isLoading = false;
  String currentUserEmail = "";

  List<planModel> allData = [];

  Future<void> loadUser() async {
    currentUserEmail = await SessionService.getUserEmail() ?? "";
  }

  Future<void> getplans() async {
    setState(() {
      isLoading = true;
    });
    allData = await _planService.getPlansByUserEmail(currentUserEmail);
    setState(() {
      isLoading = false;
      isNoData = allData.isEmpty;
    });
  }

  Future<void> _deletePlan(String planId) async {
    showProgressDialog(context);
    await _planService.deletePlanById(planId);
    hideProgress(context);
    await getplans();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadUser();
      await getplans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF1F5F9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "My Plans",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Track and manage your saved workout plans",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : isNoData
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_note_outlined,
                                    size: 54,
                                    color: Colors.blueGrey.shade400,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "No plans found",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blueGrey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Add your first plan and it will appear here.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade600,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  appButton(
                                      buttonText: "Refresh",
                                      onPressed: () {
                                        getplans();
                                      },
                                      bgColor: Colors.blueGrey.shade800)
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: allData.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (BuildContext context, int index) {
                              var singleData = allData[index];
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      spreadRadius: 1,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.fitness_center,
                                        color: Colors.blueGrey.shade800,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            singleData.name ?? "Untitled Plan",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                size: 17,
                                                color: Colors.blueGrey.shade600,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                singleData.time ?? "No time",
                                                style: TextStyle(
                                                  color:
                                                      Colors.blueGrey.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        var dialog = AlertDialog(
                                          title: const Text("Delete Plan"),
                                          content: const Text(
                                              "Do you want to delete this plan?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await _deletePlan(
                                                    singleData.id ?? "");
                                              },
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );

                                        showDialog(
                                            context: context,
                                            builder: (builder) {
                                              return dialog;
                                            });
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                      color: Colors.red.shade400,
                                    )
                                  ],
                                ),
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
}
