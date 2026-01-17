class SalesSummaryModel {
  String? status;
  Message? message;
  Data? data;

  SalesSummaryModel({this.status, this.message, this.data});

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      status: json['status'],
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (message != null) {
      map['message'] = message?.toJson();
    }
    if (data != null) {
      map['data'] = data?.toJson();
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
  int? usersSignedUp;
  LoanByStatus? loanByStatus;
  int? totalLeads;
  List<LeadByStatus>? leadsByStatus;
  int? rewardPoints;
  double? rewardAmount;
  String? totalApprovedAmount ;
String? netDisbursedAmount;


  Data({
    this.usersSignedUp,
    this.loanByStatus,
    this.totalLeads,
    this.leadsByStatus,
    this.rewardPoints,
    this.rewardAmount,
    this.totalApprovedAmount,
    this.netDisbursedAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['leads_by_status'] as List;
    List<LeadByStatus> leadsByStatusList = list.map((i) => LeadByStatus.fromJson(i)).toList();

    return Data(
      usersSignedUp: json['users_signed_up'],
      loanByStatus: json['loan_by_status'] != null ? LoanByStatus.fromJson(json['loan_by_status']) : null,
      totalLeads: json['total_leads'],
      leadsByStatus: leadsByStatusList,
      totalApprovedAmount:  json['total_approved_amount'],
      netDisbursedAmount: json['net_disbursed_amount'],
      rewardPoints: int.parse(json['reward_points']),
     rewardAmount: (json['reward_amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['users_signed_up'] = usersSignedUp;
    if (loanByStatus != null) {
      map['loan_by_status'] = loanByStatus?.toJson();
    }
    map['total_leads'] = totalLeads;
    if (leadsByStatus != null) {
     map['leads_by_status'] = leadsByStatus?.map((v) => v.toJson()).toList() ?? [];

    }
    map['reward_points'] = rewardPoints;
    map['reward_amount'] = rewardAmount;
    return map;
  }
}

class LoanByStatus {
  int? pending;
  int? running;
  int? paid;
  int? rejected;

  LoanByStatus({this.pending, this.running, this.paid, this.rejected});

  factory LoanByStatus.fromJson(Map<String, dynamic> json) {
    return LoanByStatus(
      pending: json['pending'],
      running: json['running'],
      paid: json['paid'],
      rejected: json['rejected'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pending'] = pending;
    map['running'] = running;
    map['paid'] = paid;
    map['rejected'] = rejected;
    return map;
  }
}

class LeadByStatus {
  String? status;
  int? total;

  LeadByStatus({this.status, this.total});

  factory LeadByStatus.fromJson(Map<String, dynamic> json) {
    return LeadByStatus(
      status: json['status'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['total'] = total;
    return map;
  }
}
