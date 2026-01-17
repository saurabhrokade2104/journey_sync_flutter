class EligibilityFormModel {
  bool isMale;
  bool isMarried;
  String dob; // Date of Birth in 'yyyy-MM-dd' format
  String spouseName;
  String noOfKids;
  String motherName;
  String qualification;
  String purposeOfLoan;
  String aadharNumber;
  String panNumber;
  String fullName;
  String email;
  String phoneNumber;

  EligibilityFormModel({
    required this.isMale,
    required this.isMarried,
    required this.dob,
    this.spouseName = '',
    this.noOfKids = '0',
    this.motherName = '',
    required this.qualification,
    required this.purposeOfLoan,
    required this.aadharNumber,
    required this.panNumber,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'gender': isMale ? "Male" : "Female",
        'marital_status': isMarried ? "Married" : "Single",
        'date_of_birth': dob,
        'spouse_name': spouseName,
        'number_of_kids': noOfKids,
        'mother_name': motherName,
        'qualification': qualification,
        'purpose_of_loan': purposeOfLoan,
        'aadhar_number': aadharNumber,
        'pan_number': panNumber,
        'full_name': fullName,
        'email': email,
        'mobile_number': phoneNumber,
      };

  factory EligibilityFormModel.fromJson(Map<String, dynamic> json) {
    return EligibilityFormModel(
      isMale: json['gender'].toString().toLowerCase() == "male",
      isMarried: json['marital_status'].toString().toLowerCase() == "married",
      dob: json['date_of_birth'],
      spouseName: json['spouse_name'] ?? '',
      noOfKids: json['number_of_kids']?.toString() ?? '0',
      motherName: json['mother_name'] ?? '',
      qualification: json['qualification'],
      purposeOfLoan: json['purpose_of_loan'],
      aadharNumber: json['aadhar_number'],
      panNumber: json['pan_number'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['mobile_number'],
    );
  }
}
