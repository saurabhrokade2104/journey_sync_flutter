class BankDetails {
  String bankName;
  String ifscCode;
  String accountHolderName;
  String accountNumber;
  String confirmAccountNumber;
  String bankAccountType;
  // Add additional fields like bankAccountType and bankMobile if needed

  BankDetails({
    this.bankName = '',
    this.ifscCode = '',
    this.accountHolderName = '',
    this.accountNumber = '',
    this.confirmAccountNumber = '',
    this.bankAccountType=''
    // Initialize other fields
  });

  // Convert a BankDetails instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'bank_ifsc_code': ifscCode,
      'bank_account_holder_name': accountHolderName,
      'bank_account_number': accountNumber,
      'bank_account_type':bankAccountType
      // Include other fields as required
    };
  }

  // Create a BankDetails instance from a map.
  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      bankName: json['bank_name'] as String,
      ifscCode: json['bank_ifsc_code'] as String,
      accountHolderName: json['bank_account_holder_name'] as String,
      accountNumber: json['bank_account_number'] as String,
      // Initialize other fields from json as needed
    );
  }

  // Add validation methods or use regex here for fields if needed
}
