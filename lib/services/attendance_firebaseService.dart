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
    final dateKey =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final docRef = _db
        .collection("attendance")
        .doc("class_$className")
        .collection(className)
        .doc(studentId);

    final docSnapshot = await docRef.get();

    Map<String, dynamic> monthAttendance = {};

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      monthAttendance = Map<String, dynamic>.from(
        data['month_attendance'] ?? {},
      );

      final todayStatus = monthAttendance[month] != null
          ? monthAttendance[month][dateKey]
          : null;
      if (todayStatus != null) return false;
    }

    if (monthAttendance[month] == null) {
      monthAttendance[month] = {};
    }
    monthAttendance[month][dateKey] = status;

    // Save/update the document
    await docRef.set({
      "name": studentName,
      "rollNo": rollNo,
      "month_attendance": monthAttendance,
    }, SetOptions(merge: true));

    return true;
  }

  static Future<int> getAttendanceCount({
    required String className,
    required String studentId,
    required String month,
  }) async {
    final docRef = _db
        .collection("attendance")
        .doc("class_$className")
        .collection(className)
        .doc(studentId);

    final snapshot = await docRef.get();
    if (!snapshot.exists) return 0;

    final data = snapshot.data()!;
    final monthAttendance = Map<String, dynamic>.from(
      data['month_attendance'] ?? {},
    );
    final days = Map<String, dynamic>.from(monthAttendance[month] ?? {});

    // Count the "P"s
    int presentDays = days.values.where((status) => status == "P").length;
    return presentDays;
  }
}
