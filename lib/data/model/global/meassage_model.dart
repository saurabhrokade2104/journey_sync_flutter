class Message {
  Message({
    List<String>? success,
    List<String>? error,
  }) {
    _success = success;
    _error = error;
  }

  Message.fromJson(dynamic json) {
    _success = json['success'] != null ? json['success'].cast<String>() : [];
    _error = json['error'] != null ? json['error'].cast<String>() : [];
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
