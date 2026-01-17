// To parse this JSON data, do
//
//     final withdrawRequestResponseModel = withdrawRequestResponseModelFromJson(jsonString);

// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

import 'package:finovelapp/data/model/dynamic_form/form.dart';
import 'package:finovelapp/data/model/global/meassage_model.dart';

WithdrawRequestResponseModel withdrawRequestResponseModelFromJson(String str) =>
    WithdrawRequestResponseModel.fromJson(json.decode(str));

String withdrawRequestResponseModelToJson(WithdrawRequestResponseModel data) =>
    json.encode(data.toJson());

class WithdrawRequestResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  WithdrawRequestResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      WithdrawRequestResponseModel(
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
  String? trx;
  WithdrawData? withdrawData;
  FormData? form;

  Data({
    this.trx,
    this.withdrawData,
    this.form,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        trx: json["trx"],
        withdrawData: json["withdraw_data"] == null
            ? null
            : WithdrawData.fromJson(json["withdraw_data"]),
        form: json["form"] == null ? null : FormData.fromJson(json["form"]),
      );

  Map<String, dynamic> toJson() => {
        "trx": trx,
        "withdraw_data": withdrawData?.toJson(),
        "form": form,
      };
}

class WithdrawData {
  String? methodId;
  String? userId;
  String? amount;
  String? currency;
  String? rate;
  String? charge;
  String? finalAmount;
  String? afterCharge;
  String? trx;
  DateTime? updatedAt;
  DateTime? createdAt;
  String? id;

  WithdrawData({
    this.methodId,
    this.userId,
    this.amount,
    this.currency,
    this.rate,
    this.charge,
    this.finalAmount,
    this.afterCharge,
    this.trx,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory WithdrawData.fromJson(Map<String, dynamic> json) => WithdrawData(
        methodId: json["method_id"].toString(),
        userId: json["user_id"].toString(),
        amount: json["amount"].toString(),
        currency: json["currency"],
        rate: json["rate"].toString(),
        charge: json["charge"] == null ? null : json["charge"].toString(),
        finalAmount: json["final_amount"] == null
            ? null
            : json["final_amount"].toString(),
        afterCharge: json["after_charge"] == null
            ? null
            : json["after_charge"].toString(),
        trx: json["trx"] == null ? null : json["charge"].toString(),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"] == null ? null : json["id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "method_id": methodId,
        "user_id": userId,
        "amount": amount,
        "currency": currency,
        "rate": rate,
        "charge": charge,
        "final_amount": finalAmount,
        "after_charge": afterCharge,
        "trx": trx,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
