class LeadApplicationTrackerResponse {
  LeadApplicationTrackerResponse({
    String? status,
    Message? message,
    LeadData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  LeadApplicationTrackerResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
    _data = json['data'] != null ? LeadData.fromJson(json['data']) : null;
  }

  String? _status;
  Message? _message;
  LeadData? _data;

  String? get status => _status;
  Message? get message => _message;
  LeadData? get data => _data;

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

class LeadData {
  LeadData({
    int? leadId,
    String? status,
    List<ApplicationTracker>? applicationTracker,
  }) {
    _leadId = leadId;
    _status = status;
    _applicationTracker = applicationTracker;
  }

  LeadData.fromJson(dynamic json) {
    _leadId = json['lead_id'];
    _status = json['status'];
    if (json['application_tracker'] != null) {
      _applicationTracker = [];
      json['application_tracker'].forEach((v) {
        _applicationTracker?.add(ApplicationTracker.fromJson(v));
      });
    }
  }

  int? _leadId;
  String? _status;
  List<ApplicationTracker>? _applicationTracker;

  int? get leadId => _leadId;
  String? get status => _status;
  List<ApplicationTracker>? get applicationTracker => _applicationTracker;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lead_id'] = _leadId;
    map['status'] = _status;
    if (_applicationTracker != null) {
      map['application_tracker'] = _applicationTracker?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ApplicationTracker {
  ApplicationTracker({
    String? status,
    String? timestamp,
    String? description,
  }) {
    _status = status;
    _timestamp = timestamp;
    _description = description;
  }

  ApplicationTracker.fromJson(dynamic json) {
    _status = json['status'];
    _timestamp = json['timestamp'];
    _description = json['description'];
  }

  String? _status;
  String? _timestamp;
  String? _description;

  String? get status => _status;
  String? get timestamp => _timestamp;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['timestamp'] = _timestamp;
    map['description'] = _description;
    return map;
  }
}
