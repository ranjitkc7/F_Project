import 'package:flutter/material.dart';
import '../models/student_details.dart';
import '../utils/storage.dart';
import '../services/student_firestore_service.dart';
import '../widgets/std_form.dart';
import '../widgets/button.dart';
import '../utils/date_picker.dart';

class UpdateStudentPage extends StatefulWidget {
  final StudentDetails student;

  const UpdateStudentPage({super.key, required this.student});

  @override
  State<UpdateStudentPage> createState() => _UpdateStudentPageState();
}

class _UpdateStudentPageState extends State<UpdateStudentPage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController addressController;
  late TextEditingController genderController;
  late TextEditingController dobController;
  late TextEditingController admissionDateController;
  late TextEditingController classController;
  late TextEditingController parentController;

  @override
  void initState() {
    super.initState();
    final s = widget.student;

    nameController = TextEditingController(text: s.name);
    ageController = TextEditingController(text: s.age);
    addressController = TextEditingController(text: s.address);
    genderController = TextEditingController(text: s.gender);
    dobController = TextEditingController(text: s.dob);
    admissionDateController = TextEditingController(text: s.admissionDate);
    classController = TextEditingController(text: s.studentClass);
    parentController = TextEditingController(text: s.parentDetails);
  }

  Future<void> updateStudent() async {
    final updateStudent = widget.student.copyWith(
      name: nameController.text,
      age: ageController.text,
      address: addressController.text,
      gender: genderController.text,
      dob: dobController.text,
      admissionDate: admissionDateController.text,
      studentClass: classController.text,
      parentDetails: parentController.text,
    );

    await StorageUtil.updateStudentDetails(updateStudent);

    await StudentFirestoreService.updateStudent(
      id: updateStudent.id,
      data: updateStudent.toJson(),
    );

    Navigator.pop(context, updateStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Student")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CustomInputField(label: "Name", controller: nameController),
            SizedBox(height: 13),

            CustomInputField(label: "Age", controller: ageController),
            SizedBox(height: 13),

            CustomInputField(label: "Class", controller: classController),
            SizedBox(height: 13),

            CustomInputField(label: "Gender", controller: genderController),
            SizedBox(height: 13),

            CustomInputField(label: "Address", controller: addressController),
            SizedBox(height: 13),
            CustomInputField(
              label: "DOB",
              controller: dobController,
              onTap: () => DatePickerUtil.pickDate(
                context: context,
                controller: dobController,
              ),
            ),
            SizedBox(height: 13),
            CustomInputField(
              label: "Admission Date",
              controller: admissionDateController,
              onTap: () => DatePickerUtil.pickDate(
                context: context,
                controller: admissionDateController,
              ),
            ),
            SizedBox(height: 13),
            CustomInputField(
              label: "Parent Details",
              controller: parentController,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: "Update Student",
              color: const Color.fromARGB(255, 98, 8, 242),
              radius: 12,
              onPressed: updateStudent,
            ),
          ],
        ),
      ),
    );
  }
}
