import 'package:cloud_firestore/cloud_firestore.dart';

class StudentFirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addStudent({
    required String id,
    required String rollNo,
    required String name,
    required String age,
    required String address,
    required String gender,
    required String dob,
    required String admissionDate,
    required String studentClass,
    required String parentDetails,
    required String? localImagePath,
  }) async {
    await _firestore.collection('students').doc(id).set({
      "id": id,
      "rollNo": rollNo,
      "name": name,
      "age": age,
      "address": address,
      "gender": gender,
      "dob": dob,
      "admissionDate": admissionDate,
      "studentClass": studentClass,
      "parentDetails": parentDetails,
      "localImagePath": localImagePath,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateStudent({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(id)
        .update(data);
  }
}
