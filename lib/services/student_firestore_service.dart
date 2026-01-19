import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_details.dart';

class StudentFirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addStudent({
    required String userId,
    required String id,
    required int rollNo,
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
    await FirebaseFirestore.instance.collection('students').doc(id).set({
      "userId": userId,
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

  static Future<List<StudentDetails>> fetchStudents(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('students')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return StudentDetails(
        id: doc.id,
        rollNo: data['rollNo'] is int
            ? data['rollNo']
            : int.tryParse(data['rollNo']?.toString() ?? '0') ?? 0,
        name: data['name'] ?? '',
        age: data['age'] ?? '',
        address: data['address'] ?? '',
        gender: data['gender'] ?? '',
        dob: data['dob'] ?? '',
        admissionDate: data['admissionDate'] ?? '',
        studentClass: data['studentClass'] ?? '',
        parentDetails: data['parentDetails'] ?? '',
        imagePath: data['localImagePath'],
      );
    }).toList();
  }

  static Future<void> deleteStudent(String id) async {
    await _firestore.collection('students').doc(id).delete();
  }
}
