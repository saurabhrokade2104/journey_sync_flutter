import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/data/controller/transaction/transfer_controller.dart';
import 'package:finovelapp/data/repo/withdraw/transfer_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/buttons/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import 'package:get/get.dart';

class TransferAmountScreen extends StatefulWidget {
  final int loanAmount;
  const TransferAmountScreen({super.key, required this.loanAmount});

  @override
  State<TransferAmountScreen> createState() => _TransferAmountScreenState();
}

class _TransferAmountScreenState extends State<TransferAmountScreen> {
  String? _selectedDuration;
  late double _preferredLoanAmount;
  late TextEditingController _loanAmountController;
  double _convenienceCharge = 500;
  final double _interestRate = 0.10; // Annual interest rate
  double _totalRepayment = 0;
  double _interestAmount = 0;
  List<List<String>> _emiSchedule = [];

  @override
  void initState() {
    _preferredLoanAmount = widget.loanAmount.toDouble();
    _loanAmountController =
        TextEditingController(text: _preferredLoanAmount.toString());

    // Set default duration to 90 days and initiate calculations
    _selectedDuration = '30 days';
    _calculateTotalRepayment();
    _updateEmiSchedule();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(TransferRepo(apiClient: Get.find()));

    final controller = Get.put(TransferController(transferRepo: Get.find()));

    super.initState();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    super.dispose();
  }

  void _onLoanAmountChanged() {
    String input = _loanAmountController.text;
    double? inputNumber = double.tryParse(input);
    if (inputNumber != null && inputNumber >= 100 && inputNumber <= 10000) {
      setState(() {
        _preferredLoanAmount = (inputNumber / 100).round() * 100;
        _loanAmountController.text = _preferredLoanAmount.toString();
        _calculateTotalRepayment();
        _updateEmiSchedule();
      });
    }
  }

  // void _calculateTotalRepayment() {
  //   if (_selectedDuration != null) {
  //     int duration = int.parse(_selectedDuration!.split(' ')[0]) ~/
  //         30; // Convert days to months
  //     double monthlyInterestRate = _interestRate / 12;

  //     // Calculate interest and convenience charges
  //     double interestCharge = _preferredLoanAmount * 0.10;
  //     double convenienceCharge = _preferredLoanAmount * 0.15;

  //     // Update convenience charge globally
  //     _convenienceCharge = convenienceCharge;

  //     // EMI calculation
  //     double emi = (_preferredLoanAmount *
  //             monthlyInterestRate *
  //             pow((1 + monthlyInterestRate), duration)) /
  //         (pow((1 + monthlyInterestRate), duration) - 1);
  //     double totalInterest = emi * duration - _preferredLoanAmount;

  //     setState(() {
  //       _interestAmount = interestCharge;
  //       _totalRepayment =
  //           _preferredLoanAmount + _interestAmount ;
  //     });
  //   }
  // }

  void _calculateTotalRepayment() {
    if (_selectedDuration != null) {
      int duration = int.parse(_selectedDuration!.split(' ')[0]) ~/
          30; // Get the number of months
      double monthlyInterestRate = _interestRate; // 10% monthly interest

      // Calculate interest and convenience charges
      double interestCharge = _preferredLoanAmount * 0.10;
      double convenienceCharge = _preferredLoanAmount * 0.15;

      // Update convenience charge globally
      _convenienceCharge = convenienceCharge;

      double totalInterest = 0;

      double outstandingPrincipal = _preferredLoanAmount;

      for (int i = 0; i < duration; i++) {
        double interest = outstandingPrincipal * monthlyInterestRate;
        totalInterest += interest;
        outstandingPrincipal -=
            (_preferredLoanAmount / duration); // reduce principal accordingly
      }

      setState(() {
        _interestAmount = totalInterest;
        _totalRepayment = _preferredLoanAmount + totalInterest;
      });
    }
  }

  void _updateEmiSchedule() {
    if (_selectedDuration != null) {
      int duration = int.parse(_selectedDuration!.split(' ')[0]) ~/
          30; // Convert days to months
      double monthlyInterestRate = _interestRate; // 10% monthly interest rate
      double outstandingPrincipal = _preferredLoanAmount;
      List<List<String>> schedule = [];

      for (int i = 1; i <= duration; i++) {
        double interest = outstandingPrincipal * monthlyInterestRate;
        double principal = _preferredLoanAmount / duration;
        double emi = principal + interest;
        outstandingPrincipal -= principal;

        schedule.add([
          i.toString(),
          outstandingPrincipal.toStringAsFixed(2),
          principal.toStringAsFixed(2),
          interest.toStringAsFixed(2),
          emi.toStringAsFixed(2)
        ]);
      }

      setState(() {
        _emiSchedule = schedule;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Approval',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<TransferController>(builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Your documents have been successfully validated!! You are eligible for a loan of up to ',
                      ),
                      TextSpan(
                        text: '₹${widget.loanAmount}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  height: 280,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please select your preferred loan amount',
                          style: TextStyle(
                              color: Color.fromARGB(255, 130, 128, 128),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: Center(
                          child: TextField(
                            controller: _loanAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              hintText: 'Enter amount',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            onChanged: (value) => _onLoanAmountChanged(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Slider(
                              value: _preferredLoanAmount,
                              min: 100,
                              max: widget.loanAmount.toDouble(),
                              divisions: 19,
                              onChanged: (double value) {
                                setState(() {
                                  int multiple = 100;
                                  double newValue = (value / multiple).round() *
                                      multiple.toDouble();
                                  _preferredLoanAmount =
                                      newValue.clamp(100, 10000);
                                  _loanAmountController.text =
                                      _preferredLoanAmount.toString();
                                  _calculateTotalRepayment();
                                  _updateEmiSchedule();
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '₹100',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 130, 128, 128),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '₹${widget.loanAmount.toString()}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 130, 128, 128),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please select your preferred loan tenure',
                          style: TextStyle(
                              color: Color.fromARGB(255, 130, 128, 128),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildDurationRadioButton('30 days'),
                          // buildDurationRadioButton('60 days'),
                          // buildDurationRadioButton('90 days'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Repayment Schedule',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    buildTableRow([
                      'Installment No.',
                      'Outstanding Principal (Rs.)',
                      'Principal',
                      'Interest',
                      'Installment (Rs.)'
                    ]),
                    for (var row in _emiSchedule) buildTableRow(row),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  height: 280,
                  width: double.infinity,
                  child: Column(
                    children: [
                      leftRightText(
                          leftText: 'Loan Amount',
                          rightText: '₹${_preferredLoanAmount.toInt()}'),
                      leftRightText(
                          leftText: 'Interest Amount',
                          rightText: '₹${_interestAmount.toStringAsFixed(2)}'),
                      leftRightText(
                          leftText: 'Convenience Charge',
                          rightText: '₹${_convenienceCharge.toInt()}'),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Repayment',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 130, 128, 128),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Monthly Interest Rate (MPR) will be 10%',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 130, 128, 128),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                '₹$_totalRepayment',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      leftRightText(
                          leftText: 'Net Disbursement',
                          rightText:
                              '₹${(_preferredLoanAmount - _convenienceCharge).toInt()}'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 15),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      leftRightText(
                          leftText: 'Lender(NBFC)', rightText: 'FINOVEL LTD'),
                      leftRightText(
                          leftText: 'RBI NFC Registration Number',
                          rightText: '465KLJKL'),
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: size.height * 0.07,
              //   width: size.width,
              //   decoration: BoxDecoration(
              //     color: Theme.of(context).primaryColor,
              //   ),
              //   child: TextButton(
              //       onPressed: () {
              //         if (kDebugMode) {
              //           print('Clicked On TRANSFER MONEY BUTTON');
              //         }
              //       },
              //       child: const Center(
              //         child: Text(
              //           'TRANSFER MONEY NOW',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       )),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    buttonText: 'TRANSFER MONEY NOW',
                    fontSize: 20.sp,
                    height: size.height * 0.07,
                    width: size.width,
                    textColor: AppColors.whiteColor,
                    isLoading: controller.isLoading,
                    onPressed: () {
                      // Define the maximum amounts for each duration
                      const maxAmount30Days = 2000;
                      const maxAmount60Days = 5000;
                      const maxAmount90Days = 5000;

                      // // Validate the selected duration and amount
                      // if ((_selectedDuration == '30 days' &&
                      //         _preferredLoanAmount > maxAmount30Days) ||
                      //     (_selectedDuration == '60 days' &&
                      //         _preferredLoanAmount > maxAmount60Days) ||
                      //     (_selectedDuration == '90 days' &&
                      //         _preferredLoanAmount < maxAmount90Days)) {
                      //   // Show error dialog with constraints information
                      //   _showAmountConstraintsDialog();
                      //   return; // Stop further execution
                      // }
                      Map<String, dynamic> transferData = {
                        'amount': (_preferredLoanAmount - _convenienceCharge)
                            .toString(), // Calculated amount for transfer
                        'repayment_amount': _totalRepayment
                            .toString(), // Calculated amount for transfer

                        // 'amount':'1',
                        'payment_mode': 'IMPS', // Example payment mode
                        'currency': 'INR', // Currency type
                        'source_virtual_account':
                            '', // Provide the actual source virtual account if available
                        'queue_on_low_balance':
                            '0', // 0 for no queue, 1 for queue on low balance
                        'created_by': 'system',
                        'status_change_reason':
                            'Immediate transfer', // Reason for the status change
                        'narration':
                            'Payment for Credit line', // Description or narration of the transfer
                      };

                      controller.showTransferConfirmationDialog(context, transferData);
                    }),
              ),
              SizedBox(height: 30.h),
            ],
          );
        }),
      ),
    );
  }

  void _showAmountConstraintsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Transfer Amount Constraints'),
          content: const Text(
            'Please select a valid amount for the selected duration:\n\n'
            '• For 30 days: Amount should be less than or equal to ₹2000\n'
            '• For 60 days: Amount should be less than or equal to ₹5000\n'
            '• For 90 days: Amount should be greater than ₹5000',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDurationRadioButton(String duration) {
    return Row(
      children: [
        Radio<String>(
          value: duration,
          groupValue: _selectedDuration,
          onChanged: (value) {
            setState(() {
              _selectedDuration = value;
              _calculateTotalRepayment();
              _updateEmiSchedule();
            });
          },
        ),
        Text(duration),
      ],
    );
  }

  TableRow buildTableRow(List<String> data) {
    return TableRow(
      children: data.map((item) => buildTableCell(item)).toList(),
    );
  }

  Widget buildTableCell(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftRightText({required String leftText, required String rightText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: const TextStyle(
                color: Color.fromARGB(255, 130, 128, 128),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          Text(
            rightText,
            style: const TextStyle(
                color: Color.fromARGB(255, 130, 128, 128),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
