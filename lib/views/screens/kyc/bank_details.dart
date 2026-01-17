import 'dart:async';
import 'dart:convert';

import 'package:finovelapp/core/utils/util.dart';
import 'package:finovelapp/data/controller/bank/bank_detail_controller.dart';
import 'package:finovelapp/data/model/bank/bank_detail.dart';
import 'package:finovelapp/data/repo/bank/bank_detail_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/colors.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/url.dart';
import '../../../data/services/api_service.dart';
import '../../components/buttons/rounded_loading_button.dart';
import '../../components/text-field/form_text_field.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  bool isBank = true;
  bool isSavingAccount = true;
  String? accountHolderName; // New state variable to hold account holder's name
  Timer? _debounce; // Timer for debounce

  // final TextEditingController bankNameController = TextEditingController(text: 'HDFC BANK');
  final TextEditingController bankNameController = TextEditingController();
  // final TextEditingController ifscCodeController = TextEditingController(text: 'HDFC0005819');
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController confirmAccountNumberController =
      TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    bankNameController.dispose();
    ifscCodeController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    confirmAccountNumberController.dispose();
    upiIdController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(BankDetailsRepo(
      apiClient: Get.find(),
    ));
    Get.put(BankDetailsController(bankDetailsRepo: Get.find()));
    super.initState();
  }

// Reset the form validation state
  void resetValidation() {
    formKey.currentState?.reset();
  }

  // New method to handle toggling between bank and UPI
  void toggleBankUPI(bool isBankSelected) {
    setState(() {
      isBank = isBankSelected;
      resetValidation(); // Reset the validation on toggle
    });
  }

  void onUpiIdChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (formKey.currentState?.validate() ?? false) {
        String? token = await authenticate();
        await verifyUpiDetail(token);
      } else {
        setState(() {
          accountHolderName =
              null; // Reset account holder's name if UPI ID is not valid
        });
      }

    });
  }

  Future<String> authenticate() async {
    const String apiUrl = "https://api.sandbox.co.in/authenticate";

    var headers = {
      'accept': 'application/json',
      'x-api-key': apiKey,
      'x-api-secret': apiSecret,
      'x-api-version': '1.0',
    };

    var response = await http.post(Uri.parse(apiUrl), headers: headers);
    print('authentication response : ${response.body}');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String accessToken = data['access_token'];
      return accessToken;
    } else {
      // Handle error or invalid response
      throw Exception("Failed to authenticate with the API");
    }
  }

  Future<String?> verifyUpiDetail(String token) async {
    var headers = {
      'Authorization': token,
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'x-api-version': '1.0',
    };

    try {
      var response = await http.get(
        Uri.parse(
            'https://api.sandbox.co.in/bank/upi/${upiIdController.text.trim()}'),
        headers: headers,
      );

      print('response verify upi id : ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          accountHolderName =
              data['data']['name_at_bank']; // Update account holder's name
        });
        return data['data']['name_at_bank']; // Return ref_id here
      } else {
        // Log or handle the response error message
        print('Request failed with status: ${response.statusCode}.');
        return null; // Return null if request failed
      }
    } catch (e) {
      // Handle any exceptions/errors that might occur
      print('An error occurred: $e');
      return null; // Return null in case of exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BankDetailsController>(builder: (controller) {
        return Stack(children: [
          Image.asset('assets/images/header_bg.png',
              fit: BoxFit.fill, width: double.infinity, height: 130),
          controller.isLoading
              ? Align(
                 alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    color: AppColors.primaryColor.withOpacity(1.0),
                child: const  RoundedLoadingBtn()))
              : Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    color: AppColors.primaryColor.withOpacity(1.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          foregroundColor:
                              AppColors.primaryColor.withOpacity(0.0),
                          backgroundColor:
                              AppColors.primaryColor.withOpacity(1.0)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                         if(isBank){
                           controller.submitBankDetails(BankDetails(
                              accountHolderName:
                                  accountHolderNameController.text.trim(),
                              ifscCode:
                                  ifscCodeController.text.toUpperCase().trim(),
                              accountNumber:
                                  accountNumberController.text.trim(),
                              bankName: bankNameController.text,
                              bankAccountType:
                                  isSavingAccount ? 'saving' : 'current'));
                         }
                         else{
                          controller.submitUpiDetails(upiIdController.text);

                         }
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Center(
                            child: Text(
                                isBank
                                    ? 'SAVE BANK ACCOUNT'
                                    : 'SAVE UPI DETAILS',
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                ))),
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 50),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 15,
                    color: AppColors.whiteColor,
                  ),
                  Text(
                    'BACK',
                    style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 90),
            child: Text(
              'Bank Details',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 140.0, left: 10, right: 10, bottom: 5),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 10),
                        child: Text(
                          'Fill Bank Details',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {
                                toggleBankUPI(true);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: isBank
                                        ? AppColors.cardFillColor
                                        : AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: isBank
                                            ? AppColors.accentColor
                                            : const Color.fromARGB(
                                                255, 169, 166, 166))),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: AppColors.blackColor)),
                                        child: Center(
                                          child: isBank
                                              ? const Icon(
                                                  Icons.circle,
                                                  color: AppColors.accentColor,
                                                  size: 16,
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 12.0, bottom: 12, left: 0),
                                      child: Text('Bank Account'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  toggleBankUPI(false);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: isBank
                                          ? AppColors.whiteColor
                                          : AppColors.cardFillColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: isBank
                                              ? const Color.fromARGB(
                                                  255, 169, 166, 166)
                                              : AppColors.accentColor)),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 18,
                                          width: 18,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  color: AppColors.blackColor)),
                                          child: Center(
                                            child: !isBank
                                                ? const Icon(
                                                    Icons.circle,
                                                    color:
                                                        AppColors.accentColor,
                                                    size: 16,
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 12.0, bottom: 12, left: 0),
                                          child: Text('UPI ID'))
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ),
                      isBank ? bankDetails() : upiDetails(),
                      const Divider(),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: TextFormField(
                      //     controller: mobileNumberController,
                      //     maxLines: 1,
                      //     decoration: const InputDecoration(
                      //       labelText: 'Enter Mobile Number',
                      //       hintText: 'Enter Mobile Number',
                      //       border: OutlineInputBorder(),
                      //     ),

                      //   ),
                      // ),

                      const SizedBox(height: 90),

                      // ElevatedButton(onPressed: (){}, child: const Text('VERIFY BANK ACCOUNT'))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]);
      }),
    );
  }

  Widget bankDetails() {
    return Column(
      children: [
        FormTextField(
          controller: bankNameController,
          labelText: 'Bank Name',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Bank Name';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        FormTextField(
            controller: ifscCodeController,
            labelText: 'IFSC Code',
            keyboardType: TextInputType.name,
            validator: (value) => MyUtil().ifscValidator(value)),
        FormTextField(
          controller: accountHolderNameController,
          labelText: 'Account Holder Name',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Account Holder Name';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        FormTextField(
          controller: accountNumberController,
          labelText: 'Bank Account Number',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Account Number';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        FormTextField(
          controller: confirmAccountNumberController,
          labelText: 'Confirm Account Number',
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Confirm Account Number';
            } else if (value != accountNumberController.text) {
              return 'Please enter Correct Confirm Account Number';
            }
            // Add more specific UPI validation if required
            return null;
          },
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Account Type'),
            )),
        Row(
          children: [
            Expanded(
                flex: 3,
                child: InkWell(
                  onTap: () {
                    isSavingAccount = true;
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isSavingAccount
                            ? AppColors.cardFillColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: isSavingAccount
                                ? AppColors.accentColor
                                : const Color.fromARGB(255, 169, 166, 166))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: AppColors.blackColor)),
                            child: Center(
                              child: isSavingAccount
                                  ? const Icon(
                                      Icons.circle,
                                      color: AppColors.accentColor,
                                      size: 16,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 12.0, bottom: 12, left: 0),
                          child: Text('Saving'),
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  isSavingAccount = false;
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isSavingAccount
                          ? AppColors.whiteColor
                          : AppColors.cardFillColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: isSavingAccount
                              ? const Color.fromARGB(255, 169, 166, 166)
                              : AppColors.accentColor)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColors.blackColor)),
                          child: Center(
                            child: !isSavingAccount
                                ? const Icon(
                                    Icons.circle,
                                    color: AppColors.accentColor,
                                    size: 16,
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      const Padding(
                          padding:
                              EdgeInsets.only(top: 12.0, bottom: 12, left: 0),
                          child: Text('Current'))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  // Widget upiDetails() {
  //   return Column(
  //     children: [
  //       FormTextField(
  //           labelText: 'Enter UPI',
  //           controller: upiIdController,
  //           keyboardType: TextInputType.name,
  //           onChanged: onUpiIdChanged,
  //           suffixText: accountHolderName,
  //           validator: (value) => upiValidator(value)),
  //     ],
  //   );
  // }
  Widget upiDetails() {
  return Column(
    children: [
      const SizedBox(height: 10,),
      TextFormField(
        controller: upiIdController,
        decoration: InputDecoration(
           border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
          labelText: 'Enter UPI ID',
          suffixIcon: accountHolderName!=null
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          // Add the holder's name below the text field
          helperText: accountHolderName,
          helperStyle: const TextStyle(
            color: Color(0xFF128C7E),
            fontSize: 14// Assuming this is the color you want
          ),
        ),
        keyboardType: TextInputType.name,
        onChanged: onUpiIdChanged,
        validator: (value) => MyUtil().upiValidator(value),
      ),
    ],
  );
}
}



