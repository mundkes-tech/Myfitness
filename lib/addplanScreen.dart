import 'package:cloud_firestore/cloud_firestore.dart';
import 'Common.dart';
import 'package:flutter/material.dart';

class addplanScreen extends StatefulWidget {
  const addplanScreen({super.key});

  @override
  State<addplanScreen> createState() => _addplanScreenState();
}

class _addplanScreenState extends State<addplanScreen> {
  var formkey = GlobalKey<FormState>();

  TextEditingController planNameController = TextEditingController();
  TextEditingController plantimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
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
          "Add your Plan",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formkey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 2),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: planNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Plan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      //
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: plantimeController,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: "Plan time",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      //
                      SizedBox(
                        height: 16,
                      ),
                      appButton(
                          buttonText: "Add",
                          onPressed: () async {
                            if (formkey.currentState!.validate() == true) {
                              showProgressDialog(context);

                              CollectionReference users = FirebaseFirestore.instance.collection('plans');
                              await users.add({
                                'plan_name': planNameController.text.toString(),
                                'plan_time': plantimeController.text.toString(),
                              });

                              showErrorMsg("Plan Added success",Colors.greenAccent);
                              hideProgress(context);
                              Navigator.pop(context);
                            }
                          },bgColor: Colors.red)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
