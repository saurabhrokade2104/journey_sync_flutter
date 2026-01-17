

import 'dart:convert';

import 'package:finovelapp/data/model/dynamic_form/form.dart';
import 'package:finovelapp/data/model/global/meassage_model.dart';

LoanPreviewResponseModel loanPreviewResponseModelFromJson(String str) => LoanPreviewResponseModel.fromJson(json.decode(str));

String loanPreviewResponseModelToJson(LoanPreviewResponseModel data) => json.encode(data.toJson());

class LoanPreviewResponseModel {
  String? remark;
  String? status;
  Message? message;
  MainData? data;

  LoanPreviewResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory LoanPreviewResponseModel.fromJson(Map<String, dynamic> json) =>
      LoanPreviewResponseModel(
        remark: json["remark"],
        status: json["status"].toString(),
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
        data: json["data"] == null ? null : MainData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message?.toJson(),
        "data": data?.toJson(),
      };
}

class MainData {
  Plan? plan;
  String? applicationFee;
  String? amount;
  String? delayCharge;

  MainData({
    this.plan,
    this.applicationFee,
    this.amount,
    this.delayCharge,
  });

  factory MainData.fromJson(Map<String, dynamic> json) => MainData(
      plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
      applicationFee: json["application_fee"] == null ? '' : json["application_fee"].toString(),
      amount: json["amount"].toString(),
      delayCharge: json["delay_charge"].toString());

  Map<String, dynamic> toJson() => {
        "plan": plan?.toJson(),
        "application_fee": applicationFee,
        "amount": amount,
        "delay_charge": delayCharge
      };
}

class Plan {
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
  String? createdAt;
  String? updatedAt;
  Form? form;

  Plan({
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
    this.form,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        categoryId: json["category_id"].toString(),
        formId: json["form_id"].toString(),
        name: json["name"],
        title: json["title"],
        minimumAmount: json["minimum_amount"] !=null? json["minimum_amount"].toString() : '',
        maximumAmount: json["maximum_amount"] !=null? json["maximum_amount"].toString() : '',
        perInstallment: json["per_installment"] !=null? json["per_installment"].toString() : '',
        installmentInterval: json["installment_interval"] !=null? json["installment_interval"].toString() : '',
        totalInstallment: json["total_installment"] !=null? json["total_installment"].toString() : '',
        applicationFixedCharge: json["application_fixed_charge"] !=null? json["application_fixed_charge"].toString() : '',
        applicationPercentCharge: json["application_percent_charge"] !=null? json["application_percent_charge"].toString() : '',
        instruction: json["instruction"] !=null? json["instruction"].toString() : '',
        delayValue: json["delay_value"] !=null? json["delay_value"].toString() : '',
        fixedCharge: json["fixed_charge"] !=null? json["fixed_charge"].toString() : '',
        percentCharge: json["percent_charge"] !=null? json["percent_charge"].toString() : '',
        isFeatured: json["is_featured"] !=null? json["is_featured"].toString() : '',
        status: json["status"].toString(),
        createdAt: json["created_at"] == null ? '' : json["created_at"].toString(),
        updatedAt: json["updated_at"] == null ? '' : json["updated_at"].toString(),
        form: json["form"] == null ? null : Form.fromJson(json["form"]),
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
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
        "form": form?.toJson(),
      };
}

