class StudentDetails {
  String? imagePath;
  String name;
  String id;
  int rollNo;
  String age;
  String gender;
  String address;
  String dob;
  String admissionDate;
  String studentClass;
  String parentDetails;

  StudentDetails({
    this.imagePath,
    required this.name,
    required this.id,
    required this.rollNo,
    required this.age,
    required this.gender,
    required this.address,
    required this.dob,
    required this.admissionDate,
    required this.studentClass,
    this.parentDetails = '',
  });

  Map<String, dynamic> toJson() => {
    'imagePath': imagePath, // NULL SAFE
    'name': name,
    'age': age,
    'id':id,
    "rollNo": rollNo,
    'gender': gender,
    'address': address,
    'dob': dob,
    'admissionDate': admissionDate,
    'studentClass': studentClass,
    'parentDetails': parentDetails,
  };

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    return StudentDetails(
      imagePath: json['imagePath'] == null ? null : json['imagePath'] as String,
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      rollNo: json['rollNo'] ?? '',
      age: json['age'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      admissionDate: json['admissionDate'] ?? '',
      studentClass: json['studentClass'] ?? '',
      parentDetails: json['parentDetails'] ?? '',
    );
  }
}
