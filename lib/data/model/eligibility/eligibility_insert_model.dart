import '../auth/registration_response_model.dart';

class EligibilityInsertModel {
  EligibilityInsertModel({
      String? remark,
      String? status,
      Message? message,
      Data? data}){
    _remark = remark;
    _status = status;
    _message = message;
    _data = data;
}

  EligibilityInsertModel.fromJson(dynamic json) {
    _remark = json['remark'];
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _remark;
  String? _status;
  Message? _message;
  Data? _data;

  String? get remark => _remark;
  String? get status => _status;
  Message? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = _remark;
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    return map;
  }

}

class Data {
  String? eligibility;
  int? cibilscore;

  Data({
    this.eligibility,
    this.cibilscore,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        eligibility: json['eligibility'],
        cibilscore: json['cibilscore'],
      );

  Map<String, dynamic> toJson() => {
        'eligibility': eligibility,
        'cibilscore': cibilscore,
      };
}
