class EligibilityUserDataModel {
  String? status;
  Message? message;
  Data? data;

  EligibilityUserDataModel({this.status, this.message, this.data});

  factory EligibilityUserDataModel.fromJson(Map<String, dynamic> json) {
    return EligibilityUserDataModel(
      status: json['status'],
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }


}

class Message {
  Message({
    List<String>? success,
    List<String>? error,
  }){
    _success = success;
    _error=error;
  }

  Message.fromJson(dynamic json) {
    _success = json['success'] != null ?[json['success'].toString()]:null;
    _error = json['error'] != null ? [json['error'].toString()] :null;
  }
  List<String>? _success;
  List<String>? _error;

  List<String>? get success => _success;
  List<String>? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['error'] = _error;
    return map;
  }

}

class Data {
  int? id;
  int? userId;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? mobileNumber;
  String? email;
  String? maritalStatus;
  String? spouseName;
  int? numberOfKids;
  String? motherName;
  String? qualification;
  String? panNumber;
  String? aadharNumber;
  String? purposeOfLoan;
  int? eligibilityAmount;
  int? cibilscore;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.mobileNumber,
    this.email,
    this.maritalStatus,
    this.spouseName,
    this.numberOfKids,
    this.motherName,
    this.qualification,
    this.panNumber,
    this.aadharNumber,
    this.purposeOfLoan,
    this.eligibilityAmount,
    this.cibilscore,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      maritalStatus: json['marital_status'],
      spouseName: json['spouse_name'],
      numberOfKids: json['number_of_kids'],
      motherName: json['mother_name'],
      qualification: json['qualification'],
      panNumber: json['pan_number'],
      aadharNumber: json['aadhar_number'],
      purposeOfLoan: json['purpose_of_loan'],
      eligibilityAmount: json['eligibility_amount'],
      cibilscore: json['cibilscore'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }


}
