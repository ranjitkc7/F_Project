import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/student_details.dart';

class StudentQrPage extends StatelessWidget {
  final StudentDetails student;

  const StudentQrPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student QR Code", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 98, 8, 242),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: student.id,
              size: 220,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              student.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Class: ${student.studentClass}"),
            Text("Roll No: ${student.rollNo}"),
          ],
        ),
      ),
    );
  }
}
