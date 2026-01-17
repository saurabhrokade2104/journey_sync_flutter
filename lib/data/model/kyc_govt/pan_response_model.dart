import 'package:flutter/material.dart';

class PanResponse {
  final int code;
  final String transactionId;
  final PanData data;
  final int? timestamp;

  PanResponse({
    required this.code,
    required this.transactionId,
    required this.data,
    this.timestamp,
  });

  factory PanResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('PanResponse: $json');
    return PanResponse(
      code: json['code'],
      transactionId: json['transaction_id'],
      timestamp: json['timestamp'],
      data: PanData.fromJson(json['data']),
    );
  }
}

class PanData {
  final String pan;
  final String status;
  final String? remarks;
  final bool? nameAsPerPanMatch;
  final bool? dobMatch;
  final String category;
  final String aadhaarSeedingStatus;

  PanData({
    required this.pan,
    required this.status,
    this.remarks,
    this.nameAsPerPanMatch,
    this.dobMatch,
    required this.category,
    required this.aadhaarSeedingStatus,
  });

  factory PanData.fromJson(Map<String, dynamic> json) => PanData(
        pan: json['pan'] ?? '',
        status: json['status'] ?? '',
        remarks: json['remarks'],
        nameAsPerPanMatch: json['name_as_per_pan_match'],
        dobMatch: json['date_of_birth_match'],
        category: json['category'] ?? '',
        aadhaarSeedingStatus: json['aadhaar_seeding_status'] ?? '',
      );
}
