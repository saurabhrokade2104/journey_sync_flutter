class RunningLoanModel {
  int? id;
  String? userId;
  String? loanNumber;
  String? amount;
  String? transferredAmount;
  String? perInstallment;
  String? installmentInterval;
  String? delayValue;
  String? chargePerInstallment;
  String? delayCharge;
  String? givenInstallment;
  String? status;
  NextInstallment? nextInstallment;
  Plan? plan;
  RunningLoanModel({
    this.id,
    this.userId,
    this.loanNumber,
    this.amount,
    this.transferredAmount,
    this.perInstallment,
    this.installmentInterval,
    this.delayValue,
    this.chargePerInstallment,
    this.delayCharge,
    this.givenInstallment,
    this.status,
    this.nextInstallment,
    this.plan,
  });

  factory RunningLoanModel.fromJson(Map<String, dynamic> json) =>
      RunningLoanModel(
        id: json["id"],
        userId: json["user_id"].toString(),
        loanNumber: json["loan_number"],
        amount: json["amount"],
        transferredAmount: json["transferred_amount"],
        perInstallment: json["per_installment"],
        installmentInterval: json["installment_interval"] is int
          ? json["installment_interval"].toString()
          : json["installment_interval"],


        delayValue: json["delay_value"] is int ? json["delay_value"].toString() : json["delay_value"] ,
        chargePerInstallment: json["charge_per_installment"],
        delayCharge: json["delay_charge"],
        givenInstallment: json["given_installment"] is int ? json["given_installment"].toString() : json["given_installment"] ,
        status: json["status"].toString(),
        nextInstallment: json["next_installment"] == null
            ? null
            : NextInstallment.fromJson(json["next_installment"]),
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "loan_number": loanNumber,
        "amount": amount,
        "transferred_amount": transferredAmount,
        "per_installment": perInstallment,
        "installment_interval": installmentInterval,
        "delay_value": delayValue,
        "charge_per_installment": chargePerInstallment,
        "delay_charge": delayCharge,
        "given_installment": givenInstallment,
        "status": status,
        "next_installment": nextInstallment?.toJson(),
      };
}

class NextInstallment {
  int? id;
  String? loanId;
  String? delayCharge;
  String? installmentDate;
  dynamic givenAt;
  Loan? loan;

  NextInstallment({
    this.id,
    this.loanId,
    this.delayCharge,
    this.installmentDate,
    this.givenAt,
    this.loan,
  });

  factory NextInstallment.fromJson(Map<String, dynamic> json) =>
      NextInstallment(
        id: json["id"],
        loanId: json["loan_id"].toString(),
        delayCharge: json["delay_charge"] !=null? json["delay_charge"].toString() : '',
        installmentDate: json["installment_date"] == null ? '' : json["installment_date"].toString(),
        givenAt: json["given_at"],
        loan: json["loan"] == null ? null : Loan.fromJson(json["loan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loan_id": loanId,
        "delay_charge": delayCharge,
        "installment_date": installmentDate.toString(),
        "given_at": givenAt,
        "loan": loan?.toJson(),
      };
}

class Loan {
  int? id;
  String? loanNumber;
  String? userId;
  String? planId;
  String? amount;
  String? perInstallment;
  String? installmentInterval;
  String? delayValue;
  String? chargePerInstallment;
  String? delayCharge;
  String? givenInstallment;
  String? totalInstallment;
  List<ApplicationForm>? applicationForm;
  dynamic adminFeedback;
  String? status;
  dynamic dueNotificationSent;
  String? approvedAt;
  String? createdAt;
  String? updatedAt;

  Loan({
    this.id,
    this.loanNumber,
    this.userId,
    this.planId,
    this.amount,
    this.perInstallment,
    this.installmentInterval,
    this.delayValue,
    this.chargePerInstallment,
    this.delayCharge,
    this.givenInstallment,
    this.totalInstallment,
    this.applicationForm,
    this.adminFeedback,
    this.status,
    this.dueNotificationSent,
    this.approvedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json["id"],
        loanNumber: json["loan_number"].toString(),
        userId: json["user_id"].toString(),
        planId: json["plan_id"].toString(),
        amount: json["amount"].toString(),
        perInstallment: json["per_installment"].toString(),
        installmentInterval: json["installment_interval"].toString(),
        delayValue: json["delay_value"].toString(),
        chargePerInstallment: json["charge_per_installment"].toString(),
        delayCharge: json["delay_charge"].toString(),
        givenInstallment: json["given_installment"].toString(),
        totalInstallment: json["total_installment"].toString(),
        applicationForm: json["application_form"] == null ? []
            : List<ApplicationForm>.from(json["application_form"]!.map((x) => ApplicationForm.fromJson(x))),
        adminFeedback: json["admin_feedback"],
        status: json["status"].toString(),
        dueNotificationSent: json["due_notification_sent"],
        approvedAt: json["approved_at"] == '' ? null : json["approved_at"].toString(),
        createdAt: json["created_at"] == '' ? null : json["created_at"].toString(),
        updatedAt: json["updated_at"] == '' ? null : json["updated_at"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loan_number": loanNumber,
        "user_id": userId,
        "plan_id": planId,
        "amount": amount,
        "per_installment": perInstallment,
        "installment_interval": installmentInterval,
        "delay_value": delayValue,
        "charge_per_installment": chargePerInstallment,
        "delay_charge": delayCharge,
        "given_installment": givenInstallment,
        "total_installment": totalInstallment,
        "application_form": applicationForm == null ? [] : List<dynamic>.from(applicationForm!.map((x) => x.toJson())),
        "admin_feedback": adminFeedback,
        "status": status,
        "due_notification_sent": dueNotificationSent,
        "approved_at": approvedAt?.toString(),
        "created_at": createdAt?.toString(),
        "updated_at": updatedAt?.toString(),
      };
}

class ApplicationForm {
  String? name;
  String? type;
  String? value;

  ApplicationForm({
    this.name,
    this.type,
    this.value,
  });

  factory ApplicationForm.fromJson(Map<String, dynamic> json) =>
      ApplicationForm(
        name: json["name"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "value": value,
      };
}

class Plan {
  String? name;
  String? id;
  Plan({
    this.name,
    this.id,
  });

  Plan copyWith({
    String? name,
    String? id,
  }) {
    return Plan(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory Plan.fromJson(Map<String, dynamic> map) {
    return Plan(
      name: map['name'] != '' ? map['name'].toString() : null,
      id: map['id'] != '' ? map['id'].toString() : null,
    );
  }
}
