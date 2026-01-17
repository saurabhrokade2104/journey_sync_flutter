import 'dart:convert';

import 'package:finovelapp/data/model/global/meassage_model.dart';

LoanPlanResponseModel loanPlanResponseModelFromJson(String str) =>
    LoanPlanResponseModel.fromJson(json.decode(str));

String loanPlanResponseModelToJson(LoanPlanResponseModel data) =>
    json.encode(data.toJson());

class LoanPlanResponseModel {
  String? remark;
  String? status;
  Message? message;
  Data? data;

  LoanPlanResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory LoanPlanResponseModel.fromJson(Map<String, dynamic> json) =>
      LoanPlanResponseModel(
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
  List<CategoryPlans>? categories;
  LoanPlans? loanPlans;

  Data({
    this.categories,
    this.loanPlans,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: json["categories"] == null
            ? []
            : List<CategoryPlans>.from(
                json["categories"]!.map((x) => CategoryPlans.fromJson(x))),
        loanPlans: json["loan_plans"] == null
            ? null
            : LoanPlans.fromJson(json["loan_plans"]),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "loan_plans": loanPlans?.toJson(),
      };
}

class CategoryPlans {
  int? id;
  String? name;
  String? image;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<LoanPlan>? plans;

  CategoryPlans({
    this.id,
    this.name,
    this.image,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.plans,
  });

  factory CategoryPlans.fromJson(Map<String, dynamic> json) => CategoryPlans(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        status: json["status"].toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        plans: json["plans"] == null
            ? []
            : List<LoanPlan>.from(
                json["plans"]!.map((x) => LoanPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "plans": plans == null
            ? []
            : List<dynamic>.from(plans!.map((x) => x.toJson())),
      };
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
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
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

class LoanPlans {
  int? currentPage;
  List<LoanPlan>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  LoanPlans({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory LoanPlans.fromJson(Map<String, dynamic> json) => LoanPlans(
        data: json["data"] == null ? [] : List<LoanPlan>.from(json["data"]!.map((x) => LoanPlan.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

