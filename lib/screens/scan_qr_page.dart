import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/storage.dart';
import 'student_detailsUI.dart';

class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan Student QR",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 98, 8, 242),
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) async {
          if (capture.barcodes.isEmpty) return;

          final String? studentId = capture.barcodes.first.rawValue;

          if (studentId == null) return;

          final students = await StorageUtil.getStudentDetails();

          try {
            final student = students.firstWhere((s) => s.id == studentId);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => StudentDetailsPageUI(student: student),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Student not found")));
          }
        },
      ),
    );
  }
}
