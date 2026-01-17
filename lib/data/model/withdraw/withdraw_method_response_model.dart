// To parse this JSON data, do
//
//     final withdrawMethodResponseModel = withdrawMethodResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:finovelapp/data/model/global/meassage_model.dart';

WithdrawMethodResponseModel withdrawMethodResponseModelFromJson(String str) =>
    WithdrawMethodResponseModel.fromJson(json.decode(str));

String withdrawMethodResponseModelToJson(WithdrawMethodResponseModel data) =>
    json.encode(data.toJson());

class WithdrawMethodResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  WithdrawMethodResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawMethodResponseModel.fromJson(Map<String, dynamic> json) =>
      WithdrawMethodResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class Data {
  List<WithdrawMethod>? withdrawMethod;

  Data({
    this.withdrawMethod,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        withdrawMethod: json["withdrawMethod"] == null
            ? []
            : List<WithdrawMethod>.from(
                json["withdrawMethod"]!.map((x) => WithdrawMethod.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "withdrawMethod": withdrawMethod == null
            ? []
            : List<dynamic>.from(withdrawMethod!.map((x) => x.toJson())),
      };
}

class WithdrawMethod {
  int? id;
  String? formId;
  String? name;
  String? minLimit;
  String? maxLimit;
  String? fixedCharge;
  String? rate;
  String? percentCharge;
  String? currency;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  WithdrawMethod({
    this.id,
    this.formId,
    this.name,
    this.minLimit,
    this.maxLimit,
    this.fixedCharge,
    this.rate,
    this.percentCharge,
    this.currency,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawMethod.fromJson(Map<String, dynamic> json) => WithdrawMethod(
        id: json["id"],
        formId: json["form_id"].toString(),
        name: json["name"],
        minLimit: json["min_limit"].toString(),
        maxLimit: json["max_limit"].toString(),
        fixedCharge: json["fixed_charge"].toString(),
        rate: json["rate"].toString(),
        percentCharge: json["percent_charge"].toString(),
        currency: json["currency"].toString(),
        description: json["description"].toString(),
        status: json["status"].toString(),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "form_id": formId,
        "name": name,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "fixed_charge": fixedCharge,
        "rate": rate,
        "percent_charge": percentCharge,
        "currency": currency,
        "description": description,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
