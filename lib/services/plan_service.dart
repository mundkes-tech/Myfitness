import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitness/planModel.dart';

class PlanService {
  final FirebaseFirestore _firestore;

  PlanService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addPlan({
    required String planName,
    required String planTime,
    required String userEmail,
  }) async {
    await _firestore.collection('plans').add({
      'plan_name': planName,
      'plan_time': planTime,
      'user_email': userEmail,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<List<planModel>> getPlansByUserEmail(String userEmail) async {
    final QuerySnapshot<Map<String, dynamic>> planData = await _firestore
        .collection('plans')
        .where('user_email', isEqualTo: userEmail)
        .get();

    return planData.docs.map((element) {
      final Map<String, dynamic> data = element.data();
      final planModel plan = planModel();
      plan.id = element.id;
      plan.name = data['plan_name'];
      plan.time = data['plan_time'];
      return plan;
    }).toList();
  }

  Future<void> deletePlanById(String planId) async {
    await _firestore.collection('plans').doc(planId).delete();
  }
}
