import 'package:cloud_firestore/cloud_firestore.dart';

class RollNoService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<int> getNextRollNo(String studentClass) async {
    final snapshot = await _db
        .collection('students')
        .where('studentClass', isEqualTo: studentClass)
        .get();

    return snapshot.docs.length + 1;
  }
}
