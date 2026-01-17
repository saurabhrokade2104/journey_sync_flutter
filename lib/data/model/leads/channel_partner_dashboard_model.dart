class ChannelPartnerDashboardModel {
  String? status;
  Message? message;
  Data? data;

  ChannelPartnerDashboardModel({this.status, this.message, this.data});

  factory ChannelPartnerDashboardModel.fromJson(Map<String, dynamic> json) {
    return ChannelPartnerDashboardModel(
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

  int? rewardPoints;
  String? rewardAmount;



  Data({

    this.rewardPoints,
    this.rewardAmount,

  });

  factory Data.fromJson(Map<String, dynamic> json) {



    return Data(

      rewardPoints: json['reward_points'],
      rewardAmount: json['reward_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

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
