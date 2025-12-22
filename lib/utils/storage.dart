import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/student_details.dart';

class StorageUtil {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    final file = File('$path/students.json');

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    return file;
  }

  static Future<void> saveStudentDetails(StudentDetails student) async {
    final file = await _localFile;

    List<StudentDetails> students = [];

    String content = await file.readAsString();
    if (content.isNotEmpty) {
      List jsonData = jsonDecode(content);
      students = jsonData.map((e) => StudentDetails.fromJson(e)).toList();
    }

    students.add(student);

    await file.writeAsString(
      jsonEncode(students.map((s) => s.toJson()).toList()),
    );
  }

  static Future<List<StudentDetails>> getStudentDetails() async {
    final file = await _localFile;

    String content = await file.readAsString();
    if (content.isEmpty) return [];

    List jsonData = jsonDecode(content);
    return jsonData.map((e) => StudentDetails.fromJson(e)).toList();
  }

  static Future<void> deleteStudentDetails(StudentDetails student) async {
    final file = await _localFile;

    String content = await file.readAsString();
    if (content.isEmpty) return;

    List jsonData = jsonDecode(content);
    List<StudentDetails> students = jsonData
        .map((e) => StudentDetails.fromJson(e))
        .toList();

    students.removeWhere(
      (s) =>
          s.name == student.name &&
          s.dob == student.dob &&
          s.studentClass == student.studentClass,
    );

    await file.writeAsString(
      jsonEncode(students.map((s) => s.toJson()).toList()),
    );
  }
}