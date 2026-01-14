import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceFirebaseService {
  static final _db = FirebaseFirestore.instance;

  static Future<bool> makeAttendance({
    required String className,
    required String studentId,
    required String studentName,
    required int rollNo,
    required String status,
    required String month,
  }) async {
    final today = DateTime.now();

    final datekey =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final docRef = _db
        .collection("attendance")
        .doc("class_$className")
        .collection(datekey)
        .doc(studentId);

    final snapshot = await docRef.get();

    if (snapshot.exists) {
      return false;
    }

    await docRef.set({
      "name": studentName,
      "rollNo": rollNo,
      "status": status,
      "month": month,
      "timestamp": FieldValue.serverTimestamp(),
    });
    return true;
  }
}
