class LeadFetchResponseModel {
  LeadFetchResponseModel({
    String? status,
    Message? message,
    Data? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  LeadFetchResponseModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _status;
  Message? _message;
  Data? _data;

  String? get status => _status;
  Message? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Message {
  Message({
    List<String>? success,
    List<String>? error,
  }) {
    _success = success;
    _error = error;
  }

  Message.fromJson(dynamic json) {
    _success = json['success'] != null ? List<String>.from(json['success']) : null;
    _error = json['error'] != null ? List<String>.from(json['error']) : null;
  }

  List<String>? _success;
  List<String>? _error;

  List<String>? get success => _success;
  List<String>? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_success != null) {
      map['success'] = _success;
    }
    if (_error != null) {
      map['error'] = _error;
    }
    return map;
  }
}


class Data {
  Data({
    List<Lead>? leads,
  }) {
    _leads = leads;
  }

  Data.fromJson(dynamic json) {
    if (json['leads'] != null) {
      _leads = [];
      json['leads'].forEach((v) {
        _leads?.add(Lead.fromJson(v));
      });
    }
  }

  List<Lead>? _leads;

  List<Lead>? get leads => _leads;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_leads != null) {
      map['leads'] = _leads?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Lead {
  Lead({
    int? id,
    int? userId,
    String? fullName,
    String? mobileNumber,
    String? emailId,
    String? pancardNumber,
    String? aadharNumber,
    String? areaPincode,
    String? requirementType,
    String? monthlyIncome,
    String? sourceOfIncome,
    String? loanAmount,
    String? leadType,
    String? referralCode,
    String? createdAt,
    String? status,
    int? customerId,
    User? user,
    Customer? customer,
  }) {
    _id = id;
    _userId = userId;
    _fullName = fullName;
    _mobileNumber = mobileNumber;
    _emailId = emailId;
    _pancardNumber = pancardNumber;
    _aadharNumber = aadharNumber;
    _areaPincode = areaPincode;
    _requirementType = requirementType;
    _monthlyIncome = monthlyIncome;
    _sourceOfIncome = sourceOfIncome;
    _loanAmount = loanAmount;
    _leadType = leadType;
    _referralCode = referralCode;
    _createdAt = createdAt;
    _status = status;
    _customerId = customerId;
    _user = user;
    _customer = customer;
  }

  Lead.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _fullName = json['full_name'];
    _mobileNumber = json['mobile_number'];
    _emailId = json['email_id'];
    _pancardNumber = json['pancard_number'];
    _aadharNumber = json['aadhar_number'];
    _areaPincode = json['area_pincode'];
    _requirementType = json['requirement_type'];
    _monthlyIncome = json['monthly_income'];
    _sourceOfIncome = json['source_of_income'];
    _loanAmount = json['loan_amount'];
    _leadType = json['lead_type'];
    _referralCode = json['referral_code'];
    _createdAt = json['created_at'];
    _status = json['status'];
    _customerId = json['customer_id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  int? _id;
  int? _userId;
  String? _fullName;
  String? _mobileNumber;
  String? _emailId;
  String? _pancardNumber;
  String? _aadharNumber;
  String? _areaPincode;
  String? _requirementType;
  String? _monthlyIncome;
  String? _sourceOfIncome;
  String? _loanAmount;
  String? _leadType;
  String? _referralCode;
  String? _createdAt;
  String? _status;
  int? _customerId;
  User? _user;
  Customer? _customer;

  int? get id => _id;
  int? get userId => _userId;
  String? get fullName => _fullName;
  String? get mobileNumber => _mobileNumber;
  String? get emailId => _emailId;
  String? get pancardNumber => _pancardNumber;
  String? get aadharNumber => _aadharNumber;
  String? get areaPincode => _areaPincode;
  String? get requirementType => _requirementType;
  String? get monthlyIncome => _monthlyIncome;
  String? get sourceOfIncome => _sourceOfIncome;
  String? get loanAmount => _loanAmount;
  String? get leadType => _leadType;
  String? get referralCode => _referralCode;
  String? get createdAt => _createdAt;
  String? get status => _status;
  int? get customerId => _customerId;
  User? get user => _user;
  Customer? get customer => _customer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['full_name'] = _fullName;
    map['mobile_number'] = _mobileNumber;
    map['email_id'] = _emailId;
    map['pancard_number'] = _pancardNumber;
    map['aadhar_number'] = _aadharNumber;
    map['area_pincode'] = _areaPincode;
    map['requirement_type'] = _requirementType;
    map['monthly_income'] = _monthlyIncome;
    map['source_of_income'] = _sourceOfIncome;
    map['loan_amount'] = _loanAmount;
    map['lead_type'] = _leadType;
    map['referral_code'] = _referralCode;
    map['created_at'] = _createdAt;
    map['status'] = _status;
    map['customer_id'] = _customerId;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_customer != null) {
      map['customer'] = _customer?.toJson();
    }
    return map;
  }
}

class User {
  User({
    int? id,
    String? firstname,
    String? lastname,
  }) {
    _id = id;
    _firstname = firstname;
    _lastname = lastname;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
  }

  int? _id;
  String? _firstname;
  String? _lastname;

  int? get id => _id;
  String? get firstname => _firstname;
  String? get lastname => _lastname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    return map;
  }
}

class Customer {
  // Assuming the customer details are included if available.
  // You can add customer-related fields here, similar to the User class.
  Customer();

  Customer.fromJson(dynamic json);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    return map;
  }
}
