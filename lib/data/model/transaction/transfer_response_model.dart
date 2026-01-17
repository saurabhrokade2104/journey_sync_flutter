class TransferResponseModel {
  String? remark;
  String? status;
  Message? message;
  TransferData? data;

  TransferResponseModel({this.remark, this.status, this.message, this.data});

  TransferResponseModel.fromJson(Map<String, dynamic> json) {
    remark = json['remark'];
    status = json['status'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
    data = json['data'] != null ? TransferData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remark'] = remark;
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Message {
  List<String>? success;
  List<String>? error;

  Message({this.success, this.error});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'] != null ? List<String>.from(json['success']) : null;
    error = json['error'] != null ? List<String>.from(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (success != null) {
      data['success'] = success;
    }
    if (error != null) {
      data['error'] = error;
    }
    return data;
  }
}

class TransferData {
  int? id;
  int? userId;
  String? uniqueRequestNumber;
  String? beneficiaryName;
  String? accountNumber;
  String? ifsc;
  String? upiHandle;
  String? paymentMode;
  String? status;
  String? updatedAt;
  String? createdAt;

  TransferData({
    this.id,
    this.userId,
    this.uniqueRequestNumber,
    this.beneficiaryName,
    this.accountNumber,
    this.ifsc,
    this.upiHandle,
    this.paymentMode,
    this.status,
    this.updatedAt,
    this.createdAt,
  });

  TransferData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    uniqueRequestNumber = json['unique_request_number'];
    beneficiaryName = json['beneficiary_name'];
    accountNumber = json['account_number'];
    ifsc = json['ifsc'];
    upiHandle = json['upi_handle'];
    paymentMode = json['payment_mode'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['unique_request_number'] = uniqueRequestNumber;
    data['beneficiary_name'] = beneficiaryName;
    data['account_number'] = accountNumber;
    data['ifsc'] = ifsc;
    data['upi_handle'] = upiHandle;
    data['payment_mode'] = paymentMode;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
