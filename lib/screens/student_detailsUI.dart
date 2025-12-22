import 'package:flutter/material.dart';
import 'dart:io';
import '../models/student_details.dart';
import "../widgets/table.dart";

class StudentDetailsPageUI extends StatelessWidget {
  final StudentDetails student;

  const StudentDetailsPageUI({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 236, 213),
      appBar: AppBar(
        title: Text(student.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 98, 8, 242),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
               
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 120,
                  backgroundImage: student.imagePath != null
                      ? FileImage(File(student.imagePath!))
                      : const AssetImage("assets/images/ppp.png")
                            as ImageProvider,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                DetailsTable(title: "Name", value: student.name),
                DetailsTable(title: "Age", value: student.age.toString()),
                DetailsTable(title: "Gender", value: student.gender),
                DetailsTable(title: "Address", value: student.address),
                DetailsTable(title: "DOB", value: student.dob),
                DetailsTable(
                  title: "Admission Date",
                  value: student.admissionDate,
                ),
                DetailsTable(title: "Class", value: student.studentClass),
                DetailsTable(
                  title: "Parent Details",
                  value: student.parentDetails,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}