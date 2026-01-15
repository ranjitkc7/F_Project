  // ignore_for_file: deprecated_member_use

  import 'dart:io';
  import 'package:att_app/services/rollNo_service.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import '../widgets/std_form.dart';
  import '../utils/date_picker.dart';
  import '../widgets/button.dart';
  import '../models/student_details.dart';
  import '../utils/storage.dart';
  import 'student_detailsUI.dart';
  import 'take_attendence.dart';
  import '../utils/image_storage.dart';
  import '../services/student_firestore_service.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});
    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    bool isShowAdd = false;

    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final addressController = TextEditingController();
    final genderController = TextEditingController();
    final dobController = TextEditingController();
    final admissionDateController = TextEditingController();
    final classController = TextEditingController();
    final parentDetailsController = TextEditingController();

    // All students loaded from JSON
    List<StudentDetails> students = [];

    // Currently selected class to show list for (null => none selected)
    String? selectedClass;

    File? image;
    String searchQuery = "";

    final List<String> studentClass = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
    ];

    @override
    void initState() {
      super.initState();
      loadStudents();
    }

    List<StudentDetails> get studentsForSelectedClass {
      if (selectedClass == null) return [];
      return students
          .where((s) => s.studentClass == selectedClass)
          .where((s) => s.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    void showSearchDialog() {
      showDialog(
        context: context,
        builder: (context) {
          String tempQuery = searchQuery;
          String? tempClass = selectedClass;

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 260,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Search Students",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: "Enter student name",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      tempQuery = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: tempClass,
                    decoration: const InputDecoration(
                      hintText: "Select Class",
                      border: OutlineInputBorder(),
                    ),
                    items: studentClass
                        .map(
                          (cls) => DropdownMenuItem(value: cls, child: Text(cls)),
                        )
                        .toList(),
                    onChanged: (value) {
                      tempClass = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            searchQuery = tempQuery;
                            selectedClass = tempClass;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 98, 8, 242),
                        ),
                        child: const Text(
                          "Search",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    Future<void> loadStudents() async {
      final loaded = await StorageUtil.getStudentDetails();
      setState(() {
        students = loaded;
      });
    }

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
      }
    }

    Future<void> addStudent() async {
      try {
        if (nameController.text.isEmpty ||
            ageController.text.isEmpty ||
            addressController.text.isEmpty ||
            genderController.text.isEmpty ||
            dobController.text.isEmpty ||
            admissionDateController.text.isEmpty ||
            classController.text.isEmpty ||
            parentDetailsController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please fill all the fields"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final rollNo = await RollNoService.getNextRollNo(classController.text);
        final docRef = FirebaseFirestore.instance.collection('students').doc();
        final studentId = docRef.id;

        String? localImagePath;
        if (image != null) {
          localImagePath = await LocalImageStorage.saveImage(image);
        }

        final newStudent = StudentDetails(
          id: studentId,
          rollNo: rollNo,
          name: nameController.text,
          age: ageController.text,
          address: addressController.text,
          gender: genderController.text,
          dob: dobController.text,
          admissionDate: admissionDateController.text,
          studentClass: classController.text,
          parentDetails: parentDetailsController.text,
          imagePath: localImagePath,
        );

        await StorageUtil.saveStudentDetails(newStudent);

        await StudentFirestoreService.addStudent(
          id: studentId,
          rollNo: rollNo.toString(),
          name: nameController.text,
          age: ageController.text,
          address: addressController.text,
          gender: genderController.text,
          dob: dobController.text,
          admissionDate: admissionDateController.text,
          studentClass: classController.text,
          parentDetails: parentDetailsController.text,
          localImagePath: localImagePath,
        );

        nameController.clear();
        ageController.clear();
        addressController.clear();
        genderController.clear();
        dobController.clear();
        admissionDateController.clear();
        classController.clear();
        parentDetailsController.clear();

        setState(() {
          image = null;
          isShowAdd = false;
        });

        await loadStudents();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Student added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }

    void showStudentsForClass(String classValue) {
      setState(() {
        selectedClass = classValue;
      });
    }

    void _showDialog(BuildContext context, StudentDetails s) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 230,
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose an option",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    CustomButton(
                      text: "Delete",
                      onPressed: () async {
                        await deleteStudent(s);
                        Navigator.pop(context);
                      },
                      color: Color.fromARGB(255, 98, 8, 242),
                      radius: 12,
                    ),
                    const SizedBox(height: 5),
                    CustomButton(
                      text: "Update",
                      onPressed: () {},
                      color: Color.fromARGB(255, 98, 8, 242),
                      radius: 12,
                    ),
                    const SizedBox(height: 5),
                    CustomButton(
                      text: "Explore",
                      onPressed: () {
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudentDetailsPageUI(student: s),
                          ),
                        );
                      },
                      color: Color.fromARGB(255, 98, 8, 242),
                      radius: 12,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    Future<void> deleteStudent(StudentDetails student) async {
      await StorageUtil.deleteStudentDetails(student);

      setState(() {
        students.remove(student);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student deleted successfully!"),
          backgroundColor: Colors.red,
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(top:4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 60),
                    SizedBox(
                      width: 160,
                      child: CustomButton(
                        onPressed: () => setState(() => isShowAdd = !isShowAdd),
                        radius: 12,
                        color: const Color.fromARGB(255, 98, 8, 242),
                        text: isShowAdd ? "Hide Form" : "Add Student",
                      ),
                    ),
                    const SizedBox(width: 40),
                    ElevatedButton(
                      onPressed: () {
                        showSearchDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        elevation: 3,
                        padding: const EdgeInsets.all(7),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 98, 8, 242),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              isShowAdd
                  ? Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      padding: const EdgeInsets.only(left: 8, right: 8, top:3),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color.fromARGB(255, 244, 236, 213),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 248, 235, 235),
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: image == null
                                        ? Image.asset(
                                            "assets/images/images.png",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(image!, fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  bottom: 3,
                                  right: 3,
                                  child: GestureDetector(
                                    onTap: pickImage,
                                    child: Container(
                                      height: 32,
                                      width: 32,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 98, 8, 242),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomInputField(
                            label: "Add Student Name",
                            controller: nameController,
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  label: "Add Age",
                                  controller: ageController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomInputField(
                                  label: "Add Class",
                                  controller: classController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputField(
                                  label: "Add Gender",
                                  controller: genderController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomInputField(
                                  label: "Add Address",
                                  controller: addressController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          CustomInputField(
                            label: "Add Student DOB",
                            controller: dobController,
                            icon: Icons.calendar_month,
                            onTap: () => DatePickerUtil.pickDate(
                              context: context,
                              controller: dobController,
                            ),
                          ),
                          const SizedBox(height: 6),
                          CustomInputField(
                            label: "Add Admission Date",
                            controller: admissionDateController,
                            icon: Icons.calendar_month,
                            onTap: () => DatePickerUtil.pickDate(
                              context: context,
                              controller: admissionDateController,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomInputField(
                            label: "Add Parent Details",
                            controller: parentDetailsController,
                          ),
                          CustomButton(
                            text: "Add Details",
                            color: const Color.fromARGB(255, 98, 8, 242),
                            onPressed: addStudent,
                            radius: 12,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),

              SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  itemCount: studentClass.length,
                  itemBuilder: (context, index) {
                    final cls = studentClass[index];
                    // count students in this class
                    final count = students
                        .where((s) => s.studentClass == cls)
                        .length;
                    return Container(
                      margin: const EdgeInsets.all(0),
                      height: 170,
                      width: 140,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Class",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                cls,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "$count students",
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              CustomButton(
                                text: "View",
                                onPressed: () => showStudentsForClass(cls),
                                color: const Color.fromARGB(255, 98, 8, 242),
                                radius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                ),
              ),
              const SizedBox(height: 0),
              if (selectedClass != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Students in class $selectedClass",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => setState(() => selectedClass = null),
                            child: const Text(
                              "Clear",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      CustomButton(
                        text: "Take Attendance",
                        color: const Color.fromARGB(255, 98, 8, 242),
                        onPressed: () {
                          if (selectedClass == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a class"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          final classStudents = students
                              .where((s) => s.studentClass == selectedClass)
                              .toList();
                          if (classStudents.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No students in this class"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentAttendancePage(
                                studentClass: selectedClass!,
                                students: classStudents,
                              ),
                            ),
                          );
                        },
                        radius: 12,
                      ),
                    ],
                  ),
                ),
              ] else
                const Center(
                  child: Text(
                    "Tap 'View' on a class to see its students",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

              if (selectedClass != null)
                studentsForSelectedClass.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          "No students in class $selectedClass",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: studentsForSelectedClass.length,
                        itemBuilder: (context, index) {
                          final s = studentsForSelectedClass[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    s.imagePath != null && s.imagePath!.isNotEmpty
                                    ? FileImage(File(s.imagePath!))
                                    : const AssetImage("assets/images/images.png")
                                          as ImageProvider,
                              ),
                              title: Text(s.name),
                              subtitle: Text("Age: ${s.age}  • DOB: ${s.dob}"),
                              trailing: Text("Class ${s.studentClass}"),
                              onLongPress: () {
                                _showDialog(context, s);
                              },
                            ),
                          );
                        },
                      ),
            ],
          ),
        ),
      );
    }

    @override
    void dispose() {
      nameController.dispose();
      ageController.dispose();
      addressController.dispose();
      genderController.dispose();
      dobController.dispose();
      admissionDateController.dispose();
      classController.dispose();
      parentDetailsController.dispose();
      super.dispose();
    }
  }
