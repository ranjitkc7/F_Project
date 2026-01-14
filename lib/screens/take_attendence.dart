// ignore_for_file: deprecated_member_use

import 'package:att_app/services/attendance_firebaseService.dart';
import 'package:att_app/widgets/button.dart';
import 'package:flutter/material.dart';
import '../models/student_details.dart';
import '../widgets/toggle.dart';

class StudentAttendancePage extends StatefulWidget {
  final String studentClass;
  final List<StudentDetails> students;

  final monthController = TextEditingController();

  StudentAttendancePage({
    super.key,
    required this.studentClass,
    required this.students,
  });

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final monthController = TextEditingController();

  String selectedMonth = "Baisakh";

  final List<String> nepaliMonths = [
    "Baisakh",
    "Jestha",
    "Ashadh",
    "Shrawan",
    "Bhadra",
    "Ashwin",
    "Kartik",
    "Mangsir",
    "Poush",
    "Magh",
    "Falgun",
    "Chaitra",
  ];

  late List<String?> tempStatus; // allow null
  late List<int> totalAttendance;

  @override
  void initState() {
    super.initState();
    tempStatus = List<String?>.filled(widget.students.length, null);
    totalAttendance = List<int>.filled(widget.students.length, 0);
  }

  void showAttendanceDialog({
    required BuildContext context,
    required String studentName,
    required int presentDays,
  }) {
    const int totalDays = 30;
    final double percentage = (presentDays / totalDays) * 100;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$studentName Attendance",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                Text(
                  "Present Days: $presentDays",
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(),
                Text(
                  "Percentage: ${percentage.toStringAsFixed(2)}%",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomButton(
                  text: "Close",
                  onPressed: () => Navigator.pop(context),
                  color: Color.fromARGB(255, 98, 8, 242),
                  radius: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 236, 213),
      appBar: AppBar(
        title: Text(
          "Class ${widget.studentClass} Attendance",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 98, 8, 242),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Column(
            children: [
              DropdownButtonFormField(
                initialValue: nepaliMonths.first,
                items: nepaliMonths
                    .map(
                      (month) =>
                          DropdownMenuItem(value: month, child: Text(month)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMonth = value!;
                  });
                },

                decoration: InputDecoration(
                  hintText: "Select Month",
                  suffixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(7),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "ID",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "Name",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child: Text(
                        "Status",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Total",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.students.length,
                itemBuilder: (context, index) {
                  final student = widget.students[index];
                  return Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            student.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AttendanceToggle(
                                label: "P",
                                activeColor: const Color.fromARGB(
                                  255,
                                  3,
                                  244,
                                  11,
                                ),
                                isActive: tempStatus[index] == "P",
                                onTap: () async {
                                  final success =
                                      await AttendanceFirebaseService.makeAttendance(
                                        className: widget.studentClass,
                                        studentId: student.id,
                                        studentName: student.name,
                                        rollNo: student.rollNo,
                                        status: "P",
                                        month: selectedMonth,
                                      );
                                  if (!success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Attendance already marked for today",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    totalAttendance[index] += 1;
                                    tempStatus[index] = "P";
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              AttendanceToggle(
                                label: "A",
                                activeColor: const Color.fromARGB(
                                  255,
                                  252,
                                  22,
                                  6,
                                ),
                                isActive: tempStatus[index] == "A",
                                onTap: () async {
                                  final success =
                                      await AttendanceFirebaseService.makeAttendance(
                                        className: widget.studentClass,
                                        studentId: student.id,
                                        studentName: student.name,
                                        rollNo: student.rollNo,
                                        status: "A",
                                        month: selectedMonth,
                                      );
                                  if (!success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Attendance already marked for today",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    tempStatus[index] = "A";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                showAttendanceDialog(
                                  context: context,
                                  studentName: widget.students[index].name,
                                  presentDays: totalAttendance[index],
                                );
                              },
                              child: Text(
                                totalAttendance[index].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
