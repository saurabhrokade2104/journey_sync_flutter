import 'dart:convert';
import 'dart:io';

import 'package:finovelapp/core/helper/shared_preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/route/route.dart';
import 'package:finovelapp/data/model/profile/profile_response_model.dart';
import 'package:finovelapp/data/model/user_post_model/user_post_model.dart';
import 'package:finovelapp/data/repo/account/profile_repo.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCompleteController extends GetxController {
  ProfileRepo profileRepo;
  ProfileResponseModel model = ProfileResponseModel();
  ProfileCompleteController({required this.profileRepo});

  File? imageFile;

  bool isLoading = false;
  String imageUrl = '';
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  bool submitLoading = false;
  final RxString selectedState = 'Select State'.obs;
  final List<String> states = [
    'Select State',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  updateProfile() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text.toString();
    String houseNo = houseNoController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = selectedState.value; // Updated line

    submitLoading = true;
    update();

    UserPostModel model = UserPostModel(
        image: imageFile,
        firstname: firstName,
        lastName: lastName,
        mobile: '',
        email: '',
        username: '',
        countryCode: '',
        country: '',
        mobileCode: '8',
        address: '$houseNo $address',
        state: state,
        zip: zip,
        city: city);

    bool b = await profileRepo.updateProfile(model, false);

    if (b) {
      // Get.offAllNamed(RouteHelper.bottomNavScreen);
      SharedPreferences preferences = profileRepo.apiClient.sharedPreferences;

      String? token =
          preferences.getString(SharedPreferenceHelper.accessTokenKey);

      if (token != null) {
        await storeAuthToken(token);
        // Pass a callback function to promptEnableBiometrics
        promptEnableBiometrics(token, () {
          // This gets called after the biometric prompt is resolved
          Get.offAllNamed(RouteHelper.permissonScreen);
        });
      } else {
        // Proceed with navigation if there's no token for some reason
        Get.offAllNamed(RouteHelper.permissonScreen);
      }
    }

    submitLoading = false;
    update();
  }

// Method to check biometric availability
  Future<bool> canCheckBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
  try {
    bool authenticated = await auth.authenticate(
      localizedReason: 'Scan your fingerprint to authenticate',
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
    return authenticated;
  } on PlatformException catch (e) {
    print({'error biometric', e.code, e.message});
    // Handle specific errors related to biometric auth (e.g., no biometrics enrolled)
    switch (e.code) {
      case 'NotEnrolled':
        Get.snackbar("Biometric Authentication", "No biometrics enrolled on this device.");
        break;
      case 'NotAvailable':
        Get.snackbar("Biometric Authentication", "Biometric authentication is not available.");
        break;
      case 'PasscodeNotSet':
        Get.snackbar("Biometric Authentication", "Device passcode not set.");
        break;
      case 'LockedOut':
        Get.snackbar("Biometric Authentication", "Biometric authentication is locked out due to too many attempts. Try again later.");
        break;
      default:
        Get.snackbar("Biometric Authentication", "Authentication error: ${e.message}");
        break;
    }
    return false;
  } catch (e) {
    Get.snackbar("Biometric Authentication", "An unexpected error occurred. Please try again.");
    return false;
  }
}



// Method to store auth token securely
  Future<void> storeAuthToken(String token) async {
    await secureStorage.write(key: 'auth_token', value: token);
  }

  void promptEnableBiometrics(String token, VoidCallback onSuccess) async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
  bool usesFaceID = availableBiometrics.contains(BiometricType.face);
  // This flag will help us determine if the device uses Face ID, Touch ID, or fingerprint.

  bool canCheckBiometric = await canCheckBiometrics();
  if (canCheckBiometric) {
    bool showDialog = true; // Flag to control dialog visibility
    while (showDialog) {
      // User's decision on biometric auth (Yes or No)
      bool userDecision = await Get.dialog<bool>(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                 Icon(usesFaceID ? Icons.face : Icons.fingerprint, size: 60, color: Colors.deepPurple), // Use an icon relevant to biometrics
                const SizedBox(height: 20),
                 Text(usesFaceID ? "Enable Face ID Login" : "Enable Fingerprint Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const Text("Would you like to use biometric authentication for easier login in the future?", textAlign: TextAlign.center),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      label: const Text("No"),
                      onPressed: () => Get.back(result: false),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      label: const Text("Yes"),
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ) ?? false;

      if (!userDecision) {
        await secureStorage.write(key: 'biometric_enabled', value: 'false');
        onSuccess(); // Proceed without biometric authentication
        return;
      }

      // Attempt biometric authentication
      bool authenticated = await authenticateWithBiometrics();
      if (authenticated) {
        await secureStorage.write(key: 'biometric_enabled', value: 'true');
        onSuccess(); // Authentication succeeded; proceed with the flow
        showDialog = false; // Exit loop
      } else {
        // Show retry dialog only if authentication fails
        showDialog = await Get.dialog<bool>(
          AlertDialog(
            title: const Text("Authentication Failed"),
            content: const Text("Would you like to try again?"),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text("No")),
              TextButton(onPressed: () => Get.back(result: true), child: const Text("Yes")),
            ],
          ),
        ) ?? false;
      }
    }
  } else {
    Get.snackbar("Biometric Authentication", "Biometric authentication is not available or not set up on this device.");
    onSuccess(); // Proceed without biometric authentication
  }
}




  // Method to fetch city and state from pincode
  Future<void> fetchCityAndStateFromPincode(String pincode) async {
    final String url =
        'https://india-pincode-with-latitude-and-longitude.p.rapidapi.com/api/v1/pincode/$pincode';
    final Map<String, String> headers = {
      'X-RapidAPI-Host':
          'india-pincode-with-latitude-and-longitude.p.rapidapi.com',
      'X-RapidAPI-Key': '35a1bdc619mshe0774f99498bfe5p1ff050jsnc9829dfcffcc',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          // Using the first result from the response
          cityController.text = data[0]['area'];
          selectedState.value = data[0]['state'];
        }
      } else {
        // Handle non-200 responses
        print('Failed to fetch location data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors (e.g., network errors, parsing errors)
      print('Error fetching location data: $e');
    }
  }
}
