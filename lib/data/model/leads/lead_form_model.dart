class LeadFormModel {
  String fullName;
  String mobileNumber;
  String emailId;
  String pancardNumber;
  String aadharNumber;
  String areaPincode;
  String requirementType;
  String monthlyIncome;
  String sourceOfIncome;
  String loanAmount;
  String leadType;
  String referralCode;
  // String companyCode;
  // String transactionId;

  LeadFormModel({
    required this.fullName,
    required this.mobileNumber,
    required this.emailId,
    required this.pancardNumber,
    required this.aadharNumber,
    required this.areaPincode,
    required this.requirementType,
    required this.monthlyIncome,
    required this.sourceOfIncome,
    required this.loanAmount,
    required this.leadType,
    this.referralCode = '',
  //   required this.companyCode,
  //  required this.transactionId,

  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'mobile_number': mobileNumber,
        'email_id': emailId,
        'pancard_number': pancardNumber,
        'aadhar_number': aadharNumber,
        'area_pincode': areaPincode,
        'requirement_type': requirementType,
        'monthly_income': monthlyIncome,
        'source_of_income': sourceOfIncome,
        'loan_amount': loanAmount,
        'lead_type': leadType,
        'referral_code': referralCode,
        // 'company_code': companyCode,
        // 'transaction_code': transactionId,
      };

  factory LeadFormModel.fromJson(Map<String, dynamic> json) {
    return LeadFormModel(
      fullName: json['full_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      emailId: json['email_id'] ?? '',
      pancardNumber: json['pancard_number'] ?? '',
      aadharNumber: json['aadhar_number'] ?? '',
      areaPincode: json['area_pincode'] ?? '',
      requirementType: json['requirement_type'] ?? '',
      monthlyIncome: json['monthly_income'] ?? '',
      sourceOfIncome: json['source_of_income'] ?? '',
      loanAmount: json['loan_amount'] ?? '',
      leadType: json['lead_type'] ?? '',
      referralCode: json['referral_code'] ?? '',
      // companyCode: json['company_code'] ?? '',
      // transactionId: json['transaction_code'] ?? '',
    );
  }
}
