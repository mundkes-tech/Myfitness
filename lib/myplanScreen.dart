import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Common.dart';
import 'planModel.dart';

class myplanScreen extends StatefulWidget{
  @override
  State<myplanScreen> createState() => _myplanScreenState();
}

class _myplanScreenState extends State<myplanScreen> {
  var key = GlobalKey<ScaffoldState>();

  bool isNoData = false;
  bool isLoading = false;

  List<planModel> allData = [];

  Future<void> getplans() async {
    setState(() {
      isLoading = true;
    });
    var plandata = await FirebaseFirestore.instance.collection('plans').get();

    isLoading = false;



    if (plandata.docs.length > 0) {
      isNoData = false;
      allData.clear();
      plandata.docs.forEach((element) {
        var data = element.data();

        planModel PlanModel = planModel();

        PlanModel.id = element.reference.id;
        PlanModel.name = data["plan_name"];
        PlanModel.time = data["plan_time"];
        allData.add(PlanModel);
      });
    } else {
      isNoData = true;
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getplans();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("My Plans",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
      //   backgroundColor: Colors.blueAccent,
      // ),
        body: SafeArea(
        child: Container(
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : isNoData == true
              ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("no Data Found"),
                    appButton(
                        buttonText: "Refresh",
                        onPressed: () {
                          getplans();
                        })
                  ],
                ),
              ))
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: allData.length,
            itemBuilder: (BuildContext context, int index) {
              var singleData = allData[index];
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 2),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("Plan Name : ${singleData.name}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                          SizedBox(height: 10),
                          Text("Plan Time : ${singleData.time}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [



                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                            onTap: () {
                              var dialog = AlertDialog(
                                content: Text("Do you want to delete?"),
                                actions: [
                                  GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(context);

                                        showProgressDialog(context);
                                        var plandata = await FirebaseFirestore.instance
                                            .collection('plans')
                                            .doc("${singleData.id}")
                                            .delete();

                                        hideProgress(context);
                                        getplans();
                                      },
                                      child: Text("Delete")),
                                ],
                              );

                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return dialog;
                                  });
                            },
                            child: Icon(Icons.delete)),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
        )
    );
  }
}