import 'package:flutter/foundation.dart';
import 'package:finovelapp/data/model/global/meassage_model.dart';

class MyLoanListResponseModel {
  MyLoanListResponseModel({
    String? remark,
    String? status,
    Message? message,
    MainData? data,
  }) {
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
  }

  MyLoanListResponseModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? MainData.fromJson(json['data']) : null;
  }
  String? _remark;
  String? _status;
  Message? _message;
  MainData? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  MainData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
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

class MainData {
  MainData({
    Loans? loans,
  }) {
    _loans = loans;
  }

  MainData.fromJson(dynamic json) {
    _loans = json['loans'] != null ? Loans.fromJson(json['loans']) : null;
  }
  Loans? _loans;

  Loans? get loans => _loans;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_loans != null) {
      map['loans'] = _loans?.toJson();
    }
    return map;
  }
}

class Loans {
  Loans({List<MyLoan>? data, dynamic nextPageUrl, String? path}) {
    _data = data;
    _nextPageUrl = nextPageUrl;
    _path = path;
  }

  Loans.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(MyLoan.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'];
    _path = json['path'];
  }
  List<MyLoan>? _data;
  dynamic _nextPageUrl;
  String? _path;

  List<MyLoan>? get data => _data;
  dynamic get nextPageUrl => _nextPageUrl;
  String? get path => _path;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['next_page_url'] = _nextPageUrl;
    map['path'] = _path;
    return map;
  }
}

class MyLoan {
  MyLoan({
    int? id,
    String? loanNumber,
    String? userId,
    String? planId,
    String? amount,
    String? perInstallment,
    String? installmentInterval,
    String? delayValue,
    String? chargePerInstallment,
    String? delayCharge,
    String? givenInstallment,
    String? totalInstallment,
    List<ApplicationForm>? applicationForm,
    dynamic adminFeedback,
    String? status,
    dynamic dueNotificationSent,
    dynamic approvedAt,
    String? createdAt,
    String? updatedAt,
    NextInstallment? nextInstallment,
    LoanPlan? plan,
  }) {
    _id = id;
    _loanNumber = loanNumber;
    _userId = userId;
    _planId = planId;
    _amount = amount;
    _perInstallment = perInstallment;
    _installmentInterval = installmentInterval;
    _delayValue = delayValue;
    _chargePerInstallment = chargePerInstallment;
    _delayCharge = delayCharge;
    _givenInstallment = givenInstallment;
    _totalInstallment = totalInstallment;
    _applicationForm = applicationForm;
    _adminFeedback = adminFeedback;
    _status = status;
    _dueNotificationSent = dueNotificationSent;
    _approvedAt = approvedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _nextInstallment = nextInstallment;
    _plan = plan;
  }

  MyLoan.fromJson(dynamic json) {
    _id = json['id'];
    _loanNumber = json['loan_number'].toString();
    _userId = json['user_id'].toString();
    _planId = json['plan_id'].toString();
    _amount = json['amount'].toString();
    _perInstallment = json['per_installment'].toString();
    _installmentInterval = json['installment_interval'].toString();
    _delayValue = json['delay_value'].toString();
    _chargePerInstallment = json['charge_per_installment'].toString();
    _delayCharge = json['delay_charge'].toString();
    _givenInstallment = json['given_installment'].toString();
    _totalInstallment = json['total_installment'].toString();
    if (json['application_form'] != null) {
      try {
        _applicationForm = [];
        if (json['application_form'] is List<dynamic>) {
          json['application_form'].forEach((v) {
            _applicationForm?.add(ApplicationForm.fromJson(v));
          });
        } else {
          var map = Map.from(json['application_form'])
              .map((key, value) => MapEntry(key, value));

          List<ApplicationForm>? list = map.entries
              .map((e) => ApplicationForm(
                  name: e.key ?? '',
                  type: e.value['type'],
                  value: e.value['value']))
              .toList();
          _applicationForm?.addAll(list);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    _adminFeedback = json['admin_feedback'].toString();
    _status = json['status'].toString();
    _dueNotificationSent = json['due_notification_sent'].toString();
    _approvedAt = json['approved_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _nextInstallment = json['next_installment'] != null
        ? NextInstallment.fromJson(json['next_installment'])
        : null;
    _plan = json['plan'] != null ? LoanPlan.fromJson(json['plan']) : null;
  }
  int? _id;
  String? _loanNumber;
  String? _userId;
  String? _planId;
  String? _amount;
  String? _perInstallment;
  String? _installmentInterval;
  String? _delayValue;
  String? _chargePerInstallment;
  String? _delayCharge;
  String? _givenInstallment;
  String? _totalInstallment;
  List<ApplicationForm>? _applicationForm;
  dynamic _adminFeedback;
  String? _status;
  dynamic _dueNotificationSent;
  dynamic _approvedAt;
  String? _createdAt;
  String? _updatedAt;
  NextInstallment? _nextInstallment;
  LoanPlan? _plan;

  int? get id => _id;
  String? get loanNumber => _loanNumber;
  String? get userId => _userId;
  String? get planId => _planId;
  String? get amount => _amount;
  String? get perInstallment => _perInstallment;
  String? get installmentInterval => _installmentInterval;
  String? get delayValue => _delayValue;
  String? get chargePerInstallment => _chargePerInstallment;
  String? get delayCharge => _delayCharge;
  String? get givenInstallment => _givenInstallment;
  String? get totalInstallment => _totalInstallment;
  List<ApplicationForm>? get applicationForm => _applicationForm;
  dynamic get adminFeedback => _adminFeedback;
  String? get status => _status;
  dynamic get dueNotificationSent => _dueNotificationSent;
  dynamic get approvedAt => _approvedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  NextInstallment? get nextInstallment => _nextInstallment;
  LoanPlan? get plan => _plan;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['loan_number'] = _loanNumber;
    map['user_id'] = _userId;
    map['plan_id'] = _planId;
    map['amount'] = _amount;
    map['per_installment'] = _perInstallment;
    map['installment_interval'] = _installmentInterval;
    map['delay_value'] = _delayValue;
    map['charge_per_installment'] = _chargePerInstallment;
    map['delay_charge'] = _delayCharge;
    map['given_installment'] = _givenInstallment;
    map['total_installment'] = _totalInstallment;
    if (_applicationForm != null) {
      map['application_form'] =
          _applicationForm?.map((v) => v.toJson()).toList();
    }
    map['admin_feedback'] = _adminFeedback;
    map['status'] = _status;
    map['due_notification_sent'] = _dueNotificationSent;
    map['approved_at'] = _approvedAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['next_installment'] = _nextInstallment;
    if (_plan != null) {
      map['plan'] = _plan?.toJson();
    }
    return map;
  }
}

class LoanPlan {
  int? id;
  String? categoryId;
  String? formId;
  String? name;
  String? title;
  String? minimumAmount;
  String? maximumAmount;
  String? perInstallment;
  String? installmentInterval;
  String? totalInstallment;
  String? applicationFixedCharge;
  String? applicationPercentCharge;
  String? instruction;
  String? delayValue;
  String? fixedCharge;
  String? percentCharge;
  String? isFeatured;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  LoanPlan({
    this.id,
    this.categoryId,
    this.formId,
    this.name,
    this.title,
    this.minimumAmount,
    this.maximumAmount,
    this.perInstallment,
    this.installmentInterval,
    this.totalInstallment,
    this.applicationFixedCharge,
    this.applicationPercentCharge,
    this.instruction,
    this.delayValue,
    this.fixedCharge,
    this.percentCharge,
    this.isFeatured,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory LoanPlan.fromJson(Map<String, dynamic> json) => LoanPlan(
        id: json["id"],
        categoryId: json["category_id"].toString(),
        formId: json["form_id"].toString(),
        name: json["name"],
        title: json["title"],
        minimumAmount: json["minimum_amount"] != null? json["minimum_amount"].toString() : '' ,
        maximumAmount: json["maximum_amount"] != null? json["maximum_amount"].toString() : '' ,
        perInstallment: json["per_installment"] != null? json["per_installment"].toString() : '' ,
        installmentInterval: json["installment_interval"] != null? json["installment_interval"].toString() : '' ,
        totalInstallment: json["total_installment"] != null? json["total_installment"].toString() : '' ,
        applicationFixedCharge: json["application_fixed_charge"] != null? json["application_fixed_charge"].toString() : '' ,
        applicationPercentCharge: json["application_percent_charge"] != null? json["application_percent_charge"].toString() : '' ,
        instruction: json["instruction"] != null? json["instruction"].toString() : '' ,
        delayValue: json["delay_value"] != null? json["delay_value"].toString() : '' ,
        fixedCharge: json["fixed_charge"] != null? json["fixed_charge"].toString() : '' ,
        percentCharge: json["percent_charge"] != null? json["percent_charge"].toString() : '' ,
        isFeatured: json["is_featured"] != null? json["is_featured"].toString() : '' ,
        status: json["status"].toString(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "form_id": formId,
        "name": name,
        "title": title,
        "minimum_amount": minimumAmount,
        "maximum_amount": maximumAmount,
        "per_installment": perInstallment,
        "installment_interval": installmentInterval,
        "total_installment": totalInstallment,
        "application_fixed_charge": applicationFixedCharge,
        "application_percent_charge": applicationPercentCharge,
        "instruction": instruction,
        "delay_value": delayValue,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "is_featured": isFeatured,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ApplicationForm {
  ApplicationForm({
    String? name,
    String? type,
    String? value,
  }) {
    _name = name;
    _type = type;
    _value = value;
  }

  ApplicationForm.fromJson(dynamic json) {
    _name = json['name'].toString();
    _type = json['type'].toString();
    _value = json['value'].toString();
  }
  String? _name;
  String? _type;
  String? _value;

  String? get name => _name;
  String? get type => _type;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['type'] = _type;
    map['value'] = _value;
    return map;
  }
}

class NextInstallment {
  NextInstallment({
    int? id,
    String? installmentableType,
    String? installmentableId,
    String? delayCharge,
    String? installmentDate,
    dynamic givenAt,
  }) {
    _id = id;
    _installmentableType = installmentableType;
    _installmentableId = installmentableId;
    _delayCharge = delayCharge;
    _installmentDate = installmentDate;
    _givenAt = givenAt;
  }

  NextInstallment.fromJson(dynamic json) {
    _id = json['id'];
    _installmentableType = json['installmentable_type'].toString();
    _installmentableId = json['installmentable_id'].toString();
    _delayCharge = json['delay_charge'] != null ? json['delay_charge'].toString() : '';
    _installmentDate = json['installment_date'];
    _givenAt = json['given_at'];
  }
  int? _id;
  String? _installmentableType;
  String? _installmentableId;
  String? _delayCharge;
  String? _installmentDate;
  dynamic _givenAt;

  int? get id => _id;
  String? get installmentableType => _installmentableType;
  String? get installmentableId => _installmentableId;
  String? get delayCharge => _delayCharge;
  String? get installmentDate => _installmentDate;
  dynamic get givenAt => _givenAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['installmentable_type'] = _installmentableType;
    map['installmentable_id'] = _installmentableId;
    map['delay_charge'] = _delayCharge;
    map['installment_date'] = _installmentDate;
    map['given_at'] = _givenAt;
    return map;
  }
}
