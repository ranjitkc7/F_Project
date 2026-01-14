import 'package:cloud_firestore/cloud_firestore.dart';

class RollNoService {
  static final _db = FirebaseFirestore.instance;

  static Future<int> getNextRollNo(String className) async {
    final snapshot = await _db
        .collection('students')
        .where('class', isEqualTo: className)
        .orderBy('name')
        .get();
    return snapshot.docs.length + 1;
  }
}
