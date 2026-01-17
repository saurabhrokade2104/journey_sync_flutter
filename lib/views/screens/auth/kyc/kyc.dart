import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/components/no_data/no_data_found_screen.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../../../core/utils/url.dart';
import '../../../../data/controller/kyc_controller/kyc_controller.dart';

import '../../../../data/repo/kyc/kyc_repo.dart';
import '../../../../data/services/api_service.dart';
import '../../kyc/status_screen.dart';
import 'widget/already_verifed.dart';
import 'package:http/http.dart' as http;

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  int currentStep = 1; // Moved inside the class

  bool isMale = false;
  bool isMarried = true;
  String gender = 'Male';
  DateTime? dob; // Date of Birth
  bool agreeToTerms = false;
  final Uri _url = Uri.parse('https://finovel.in/');
  bool otpRequested = false;
  DateTime? lastOtpRequestTime;
    String? _selfieImagePath;

  String formattedAadharData = '';
  String formattedPanData = '';
  File? aadharPhoto;
  String? aadharPhotoLink;

  String? refId;
  String enteredOtp = '';

  @override
  void dispose() {
    aadharNumberController.dispose();
    panNumberController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void toggleWidget() async {
    print('toggleWidget - Current Step: $currentStep'); // Log current step
    if (currentStep < 3) {
      print(
          'Handling Intermediate Steps'); // Log for entering intermediate steps
      handleIntermediateSteps();
    }
  }

  void handleIntermediateSteps() async {
    print('handleIntermediateSteps - Current Step: $currentStep');
    if (_formKey.currentState!.validate() && agreeToTerms) {
      if (currentStep == 1) {
        bool isPanValid = await verifyPanNumber();
        // bool isPanValid = true;
        if (!isPanValid) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid PAN number. Please enter a valid PAN."),
            ),
          );
          return; // Stop the process if the PAN is invalid
        }
      }

      setState(() {
        currentStep++;
        print('Incremented Step - New Current Step: $currentStep');
      });

      if (currentStep == 3) {
        print('Reaching Final Step');
        handleFinalStep();
      }
    } else if (!agreeToTerms) {
      print('Terms not agreed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must agree to the terms and conditions"),
        ),
      );
    }
  }



  // This method is triggered when the user presses the 'TAKE A SELFIE' button.
  Future<void> captureSelfie() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front, // Use the front camera
      );
      if (pickedFile != null) {
        setState(() {
          _selfieImagePath = pickedFile.path; // Set the selfie path
        });
        // Here, you can also handle the upload of the image if necessary
      } else {
        // User canceled the picker
      }
    } catch (e) {
      // Handle any errors here
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to capture selfie: $e'),
        ),
      );
    }
  }

  Future<void> handleFinalStep() async {
    print('handleFinalStep - Starting');
    await requestAndStoreAadharOtp();
    print('handleFinalStep - Completed');
    // Additional logic if needed after OTP request
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

  Future<String?> requestAadharOtp(String aadharNumber, String token) async {
    var headers = {
      'Authorization': token,
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'x-api-version': '1.0',
    };

    var body = json.encode({
      "aadhaar_number": aadharNumber,
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.sandbox.co.in/kyc/aadhaar/okyc/otp'),
        headers: headers,
        body: body,
      );

      print('response request aadhar otp : ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['data']['ref_id']; // Return ref_id here
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

  Future<void> requestAndStoreAadharOtp() async {
    print('going to execute');
    String token = await authenticate();
    String? receivedRefId =
        await requestAadharOtp(aadharNumberController.text, token);
    print('checkign requested Aadhar otp $receivedRefId');

    if (receivedRefId != null) {
      setState(() {
        refId = receivedRefId; // Update the state with the received ref_id
      });

      // Further actions after receiving ref_id, like showing the OTP input field
    } else {
      // Handle the case where ref_id is not received
    }
  }

  Future<bool> verifyAadharOtp(String otp, String refId, String token) async {
    var headers = {
      'Authorization': token,
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'x-api-version': '1.0',
    };

    var body = json.encode({
      "otp": otp,
      "ref_id": refId,
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.sandbox.co.in/kyc/aadhaar/okyc/otp/verify'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
       handleAadharResponse(data);
        // Handle the success scenario. You might want to parse the response.
        return true;
      } else {
        // Log or handle the response error message
        print('OTP Verification failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      // Handle any exceptions/errors that might occur
      print('An error occurred during OTP verification: $e');
      return false;
    }
  }

  Future<bool> verifyPanNumber() async {
    String token = await authenticate();
    var headers = {
      'Authorization': token,
      'accept': 'application/json',
      'content-type': 'application/json',
      'x-api-key': apiKey,
      'x-api-version': '1.0',
    };

    var body = json.encode({
      "pan": panNumberController.text.trim(),
      "consent": "Y",
      "reason": "For KYC of User"
    });

    try {
      var response = await http.post(
        Uri.parse('https://api.sandbox.co.in/kyc/pan'),
        headers: headers,
        body: body,
      );

      print('PAN verification response: ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
       handlePanResponse(data);
        // Check if the status in the data is "VALID"
        String status = data['data']['status'];
        return status == "VALID";
      } else {
        print('PAN Verification failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('An error occurred during PAN verification: $e');
      return false; // Return false in case of exception
    }
  }

  void proceedToNextStep() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const StatusScreen()));
  }

  Map<String, dynamic> gatherFormData() {
    return {
      "full_name": fullNameController.text,
      "aadhar_number": aadharNumberController.text,
      "pan_number": panNumberController.text,
      "date_of_birth": dob,
      "gender": gender,
      "email": emailController.text,
      "phone_number": phoneNumberController.text,
      "pan_data":formattedPanData,
      "aadhar_data":formattedAadharData,



      // Add other fields similarly
    };
  }

  void handleAadharResponse(Map<String, dynamic> aadharResponse) async {
  setState(() {
    formattedAadharData = formatAadharData(aadharResponse);
    aadharPhotoLink  = aadharResponse['data']['photo_link'];

  });
}

void handlePanResponse(Map<String, dynamic> panResponse) {
  setState(() {
    formattedPanData = formatPanData(panResponse);
  });
}


  Future<void> submitOtp(KycController controller) async {
    if (refId == null) {
      // Handle the error if refId is not available
      return;
    }


print('calling');
    try {
      String token = await authenticate(); // Authenticate and get token
      bool otpVerified = await verifyAadharOtp(
          enteredOtp, refId!, token); // Pass the entered OTP for verification
      // bool otpVerified = true;

      if (otpVerified) {
        // OTP is correct, proceed further
        // proceedToNextStep();



        var formData = gatherFormData();

        // Decode Aadhar photo and add it to formData
      if (aadharPhotoLink != null) {
        File aadharPhoto = await decodeAadharPhoto(aadharPhotoLink??'');
        formData['aadhar_photo'] = aadharPhoto;
      }

      // Add user selfie to formData if it's captured
      if (_selfieImagePath != null) {
        File selfieImage = File(_selfieImagePath!);
        formData['user_selfie'] = selfieImage;
      }

      print('checking formData : $formData');


        controller.submitKycData(formData);
      } else {
        // OTP verification failed, show error to user

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("YOTP verification failed. Please try again."),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: $e"),
        ),
      );
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(KycRepo(apiClient: Get.find()));
    Get.put(KycController(repo: Get.find()));
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<KycController>().beforeInitLoadKycData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KycController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: controller.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSize15),
                  child: CustomLoader())
              : controller.isAlreadyVerified
                  ? const AlreadyVerifiedWidget()
                  : controller.isAlreadyPending
                      ? const AlreadyVerifiedWidget(
                          isPending: true,
                        )
                      : controller.isNoDataFound
                          ? const NoDataFoundScreen()
                          : Form(
                              key: _formKey,
                              child: Stack(children: [
                                Image.asset('assets/images/header_bg.png',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: 210),
                                 Padding(
                                  padding: const EdgeInsets.only(left: 10.0, top: 50),
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child:  const Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back_ios,
                                          size: 20,
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
                                Align(
                                    alignment: FractionalOffset.bottomCenter,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor),
                                        onPressed: toggleWidget,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 54,
                                          child: currentStep == 1
                                              ? const Center(
                                                  child: Text(
                                                    'ADD DETAILS',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .whiteColor),
                                                  ),
                                                )
                                              : currentStep == 2
                                                  ? const Center(
                                                      child: Text('GET OTP',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1))),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        submitOtp(controller);
                                                      },
                                                      child: const Center(
                                                        child: Text('VERIFY',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .whiteColor)),
                                                      ),
                                                    ),
                                        ))),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 80.0, right: 10, left: 15),
                                  child: Stack(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Get your profile verify in 3 Steps',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.whiteColor),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(30.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 18.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16)),
                                                          color: currentStep >=
                                                                  1
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .progressFaintColor),
                                                      child: InkWell(
                                                        onTap: () => {
                                                          currentStep = 1,
                                                          setState(() {})
                                                        },
                                                        child: const Center(
                                                            child: Text(
                                                          '1',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColors
                                                                  .accentColor),
                                                        )),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      height: 5,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  5),
                                                          color: currentStep > 1
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .progressFaintColor),
                                                    ),
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16)),
                                                          color: currentStep >=
                                                                  2
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .progressFaintColor),
                                                      child: InkWell(
                                                        onTap: () => {
                                                          // currentStep = 2,
                                                          // setState(() {})
                                                        },
                                                        child: const Center(
                                                            child: Text(
                                                          '2',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColors
                                                                  .accentColor),
                                                        )),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 5,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  5),
                                                          color: currentStep >=
                                                                  3
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .progressFaintColor),
                                                    ),
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          16)),
                                                          color: currentStep >=
                                                                  3
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .progressFaintColor),
                                                      child: InkWell(
                                                        onTap: () => {
                                                          // currentStep = 3,
                                                          // setState(() {})
                                                        },
                                                        child: const Center(
                                                            child: Text(
                                                          '3',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColors
                                                                  .accentColor),
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 86.0, right: 5, left: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 2,
                                                child: Text(
                                                    'Add Personal Details',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontSize: 11))),
                                            Spacer(),
                                            Flexible(
                                                flex: 2,
                                                child: Text(
                                                    'Upload Selfie & Capture ID Proof',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .whiteColor,
                                                        fontSize: 11))),
                                            Spacer(),
                                            Flexible(
                                              flex: 2,
                                              child: Text(
                                                'Get OTP & Verify Account',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: AppColors.whiteColor,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      (currentStep == 1)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 150, bottom: 60),
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0,
                                                            right: 10,
                                                            left: 6),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Fill Details',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 10.0,
                                                            bottom: 10,
                                                          ),
                                                          child: TextFormField(
                                                            maxLines: 1,
                                                            validator: (value) =>
                                                                value!.isEmpty
                                                                    ? 'Please enter full name'
                                                                    : null,
                                                            controller:
                                                                fullNameController,
                                                            decoration: const InputDecoration(
                                                                contentPadding:
                                                                    EdgeInsets.symmetric(
                                                                        vertical:
                                                                            8.0,
                                                                        horizontal:
                                                                            8),
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            5))),
                                                                labelText:
                                                                    'Full Name',
                                                                hintText:
                                                                    'Full Name'),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 8.0),
                                                          child: TextFormField(
                                                            controller:
                                                                _dobController,
                                                            validator: (value) {
                                                              if (dob == null) {
                                                                return 'Please select your date of birth';
                                                              } else {
                                                                final currentDate =
                                                                    DateTime
                                                                        .now();
                                                                var age = currentDate
                                                                        .year -
                                                                    dob!.year;
                                                                if (dob!.month >
                                                                        currentDate
                                                                            .month ||
                                                                    (dob!.month ==
                                                                            currentDate
                                                                                .month &&
                                                                        dob!.day >
                                                                            currentDate.day)) {
                                                                  // Adjust the age if the birthday has not occurred this year
                                                                  age--;
                                                                }

                                                                if (age < 21) {
                                                                  return 'You must be at least 21 years old';
                                                                }
                                                              }
                                                              return null;
                                                            },
                                                            readOnly: true,
                                                            onTap: () async {
                                                              DateTime?
                                                                  pickedDate =
                                                                  await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate:
                                                                          DateTime
                                                                              .now(),
                                                                      firstDate:
                                                                          DateTime(
                                                                              1950),
                                                                      //DateTime.now() - not to allow to choose before today.
                                                                      lastDate:
                                                                          DateTime(
                                                                              2100));

                                                              if (pickedDate !=
                                                                  null) {
                                                                setState(() {
                                                                  dob =
                                                                      pickedDate; // Update the DOB variable with the selected date
                                                                });
                                                                //pickedDate output format => 2021-03-10 00:00:00.000

                                                                // Format the date and update the controller text
                                                                String
                                                                    formattedDate =
                                                                    DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            pickedDate);
                                                                setState(() {
                                                                  _dobController
                                                                          .text =
                                                                      formattedDate; // Set formatted date to TextField value
                                                                });
                                                              } else {}
                                                            },
                                                            maxLines: 1,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  const Icon(Icons
                                                                      .calendar_month),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          8.0),
                                                              border: const OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              6))),
                                                              labelText:
                                                                  'Date of Birth',
                                                              hintText: dob !=
                                                                      null
                                                                  ? DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          dob!)
                                                                  : 'Select Date of Birth',
                                                            ),
                                                          ),
                                                        ),
                                                        const Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 0.0,
                                                                      top: 8),
                                                              child: Text(
                                                                'Gender',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            )),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: InkWell(
                                                                onTap: () => {
                                                                  setState(() {
                                                                    isMale =
                                                                        true;
                                                                    gender =
                                                                        'Male';
                                                                  })
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                      .only(
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                                  decoration: BoxDecoration(
                                                                      color: isMale
                                                                          ? AppColors
                                                                              .cardFillColor
                                                                          : AppColors
                                                                              .whiteColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      border: Border.all(
                                                                          color: isMale
                                                                              ? AppColors.accentColor
                                                                              : const Color.fromARGB(255, 169, 166, 166))),
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              18,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              border: Border.all(color: AppColors.blackColor)),
                                                                          child:
                                                                              Center(
                                                                            child: isMale
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
                                                                            top:
                                                                                12.0,
                                                                            bottom:
                                                                                12,
                                                                            left:
                                                                                0),
                                                                        child: Text(
                                                                            'Male'),
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
                                                                  setState(() {
                                                                    isMale =
                                                                        false;
                                                                    gender =
                                                                        'Female';
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10),
                                                                  decoration: BoxDecoration(
                                                                      color: isMale
                                                                          ? AppColors
                                                                              .whiteColor
                                                                          : AppColors
                                                                              .cardFillColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                      border: Border.all(
                                                                          color: isMale
                                                                              ? const Color.fromARGB(255, 169, 166, 166)
                                                                              : AppColors.accentColor)),
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              18,
                                                                          width:
                                                                              18,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(30),
                                                                              border: Border.all(color: AppColors.blackColor)),
                                                                          child:
                                                                              Center(
                                                                            child: !isMale
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
                                                                              top: 12.0,
                                                                              bottom: 12,
                                                                              left: 0),
                                                                          child: Text('Female'))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10.0,
                                                                  bottom: 10),
                                                          child: TextFormField(
                                                            maxLines: 1,
                                                            controller:
                                                                emailController,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter email';
                                                              } else if (!RegExp(
                                                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                                  .hasMatch(
                                                                      value)) {
                                                                return 'Please enter a valid email address';
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          8),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                              labelText:
                                                                  'Email',
                                                              hintText: 'Email',
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10.0,
                                                                  bottom: 10),
                                                          child: TextFormField(
                                                            maxLines: 1,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number, // Use number keyboard
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly, // Accept only digits
                                                              LengthLimitingTextInputFormatter(
                                                                  10), // Limit to 10 digits
                                                            ],
                                                            controller:
                                                                phoneNumberController,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter phone number';
                                                              } else if (value
                                                                      .length !=
                                                                  10) {
                                                                return 'Please enter a valid 10-digit phone number';
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          8),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                              labelText:
                                                                  'Phone Number',
                                                              hintText:
                                                                  'Phone Number',
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10.0,
                                                                  bottom: 10),
                                                          child: TextFormField(
                                                            controller:
                                                                aadharNumberController,
                                                            maxLines: 1,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly, // Accept only digits
                                                              LengthLimitingTextInputFormatter(
                                                                  12), // Limit to 12 digits
                                                            ],
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter Aadhar number';
                                                              } else if (!RegExp(
                                                                      r'^\d{12}$')
                                                                  .hasMatch(
                                                                      value)) {
                                                                // Regular expression for a 12-digit number
                                                                return 'Please enter a valid 12-digit Aadhar number';
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          8),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                              labelText:
                                                                  'Aadhar Number',
                                                              hintText:
                                                                  'Aadhar Number',
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10.0,
                                                                  bottom: 10),
                                                          child: TextFormField(
                                                            controller:
                                                                panNumberController,
                                                            maxLines: 1,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      r'^[A-Za-z0-9]+$')), // Allow alphanumeric characters
                                                              LengthLimitingTextInputFormatter(
                                                                  10), // Limit to 10 characters
                                                            ],
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter PAN number';
                                                              } else if (!RegExp(
                                                                      r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                                                                  .hasMatch(
                                                                      value)) {
                                                                // Regular expression for PAN format
                                                                return 'Please enter a valid PAN number';
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          8),
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5))),
                                                              labelText:
                                                                  'PAN Number',
                                                              hintText:
                                                                  'PAN Number',
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Theme(
                                                              data: ThemeData(
                                                                unselectedWidgetColor:
                                                                    Colors
                                                                        .grey, // Color for the unchecked checkbox
                                                              ),
                                                              child: Checkbox(
                                                                value:
                                                                    agreeToTerms,
                                                                onChanged: (bool?
                                                                    newValue) {
                                                                  setState(() {
                                                                    agreeToTerms =
                                                                        newValue!;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            const Text(
                                                              'Agree to ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13.0,
                                                                  color: AppColors
                                                                      .blackColor),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                if (!await launchUrl(
                                                                    _url)) {
                                                                  throw Exception(
                                                                      'Could not launch $_url');
                                                                }
                                                              },
                                                              child: const Text(
                                                                'terms & conditions.',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13.0,
                                                                    color: AppColors
                                                                        .accentColor),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 80,
                                                  ),
                                                ]),
                                              ),
                                            )
                                          : (currentStep == 2)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 150.0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'CAPTURE SELFIE',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                         if (_selfieImagePath != null)
                                                         Image.file(File(_selfieImagePath!)),

                                                       _selfieImagePath == null ? Container(
                                                          decoration: BoxDecoration(
                                                              color: AppColors
                                                                  .cardFillColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Image.asset(
                                                              'assets/images/selfi.png'),
                                                        ) : const SizedBox.shrink(),
                                                        Row(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      height: 8,
                                                                      width: 8,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .accentColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(3)),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    const Text(
                                                                      'Good Lightning onn your face',
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppColors
                                                                            .textGray,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      height: 8,
                                                                      width: 8,
                                                                      decoration: BoxDecoration(
                                                                          color: AppColors
                                                                              .accentColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(3)),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    const Text(
                                                                        'No Glasses & Hat')
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            OutlinedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  side: WidgetStateProperty.all(
                                                                      const BorderSide(
                                                                          color:
                                                                              AppColors.accentColor)), // Change the color to your desired color
                                                                ),
                                                                // style: OutlinedButton.styleFrom(
                                                                //     shadowColor: AppColors.primaryColor),
                                                                onPressed: captureSelfie
                                                                  ,
                                                                child:
                                                                    const Text(
                                                                  'TAKE A SELFIE',
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .accentColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0, left: 8),
                                                  child: Wrap(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 158.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'VERIFICATION',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                '09.47',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          const SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              'You Will get OTP on your  aadhar mobile number. OTP will be available for 2 min.',
                                                              style: TextStyle(
                                                                  fontSize: 13),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/otp.png',
                                                                height: 150,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Center(
                                                            child: Pinput(
                                                              length: 6,
                                                              pinputAutovalidateMode:
                                                                  PinputAutovalidateMode
                                                                      .onSubmit,
                                                              showCursor: true,
                                                              onCompleted:
                                                                  (pin) =>
                                                                      enteredOtp =
                                                                          pin,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Center(
                                                              child: Text(
                                                                  'Don’t receive the verification details?'),
                                                            ),
                                                          ),
                                                          const Center(
                                                              child: Text(
                                                            'RESEND OTP',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .accentColor),
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
        ),
      ),
    );
  }

  String formatAadharData(Map<String, dynamic> aadharData) {
  var data = aadharData['data'];
  String formattedData = 'Name: ${data['name']}\n'
                         'DOB: ${data['dob']}\n'
                         'Gender: ${data['gender'] == "M" ? "Male" : "Female"}\n'
                         'Address: ${data['address']}\n'
                         'Care Of: ${data['care_of']}\n'
                         'Email (Hashed): ${data['email']}\n'
                         'Mobile (Hashed): ${data['mobile_hash']}\n'
                         'Year of Birth: ${data['year_of_birth']}\n'
                         'Reference ID: ${data['ref_id']}\n';

  // Formatting split address if available
  if (data.containsKey('split_address')) {
    var splitAddress = data['split_address'];
    formattedData += '\nSplit Address:\n'
                     'House: ${splitAddress['house']}\n'
                     'Street: ${splitAddress['street']}\n'
                     'Landmark: ${splitAddress['landmark']}\n'
                     'Postal Office: ${splitAddress['po']}\n'
                     'District: ${splitAddress['dist']}\n'
                     'State: ${splitAddress['state']}\n'
                     'Country: ${splitAddress['country']}\n'
                     'Pincode: ${splitAddress['pincode']}\n';
  }

  return formattedData;
}

String formatPanData(Map<String, dynamic> panData) {
  var data = panData['data'];
  return 'Full Name: ${data['full_name']}\n'
         'PAN: ${data['pan']}\n'
         'Status: ${data['status']}\n'
         'Category: ${data['category']}\n'
         'Last Updated: ${data['last_updated']}\n';
}

Future<File> decodeAadharPhoto(String base64String) async {
  final decodedBytes = base64Decode(base64String);
  final directory = await getTemporaryDirectory();
  final file = File('${directory.path}/aadhar_photo.jpg');
  await file.writeAsBytes(decodedBytes);
  return file;
}
}


//  Check if OTP has already been requested and if the timeout hasn't expired
//       if (!otpRequested ||
//           (lastOtpRequestTime != null &&
//               DateTime.now().difference(lastOtpRequestTime!).inMinutes > 10)) {
//         otpRequested = true;
//         lastOtpRequestTime = DateTime.now();

//         // Trigger Aadhar OTP request

//        await  requestAndStoreAadharOtp();

//       } else {
//         // Inform user that OTP has already been sent or provide option to resend after timeout
//         // submitForm();
//       }

