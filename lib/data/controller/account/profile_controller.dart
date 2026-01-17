import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/helper/shared_preference_helper.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/url.dart';
import 'package:finovelapp/data/model/profile/profile_response_model.dart';
import 'package:finovelapp/data/model/user_post_model/user_post_model.dart';
import 'package:finovelapp/data/repo/account/profile_repo.dart';
import 'package:finovelapp/views/components/snackbar/show_custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  ProfileRepo profileRepo;
  ProfileResponseModel model = ProfileResponseModel();

  ProfileController({required this.profileRepo});

  String imageUrl = '';

  bool isLoading = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
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

   final RxString selectedState = 'Select State'.obs;
   final List<String> states = [  'Select State',
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
    'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya',
    'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim',
    'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand',
    'West Bengal',
  ];

  File? imageFile;


void pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    debugPrint('pickedFile: $pickedFile');
   if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
    else{
      CustomSnackBar.error(
        errorList: ['No image selected'],
      );
    }
  }


  loadProfileInfo() async {
    isLoading = true;
    update();
    model = await profileRepo.loadProfileInfo();
    if (model.data != null &&
        model.status?.toLowerCase() == MyStrings.success.toLowerCase()) {
      loadData(model);
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  bool isSubmitLoading = false;
  updateProfile() async {
    isSubmitLoading = true;
    update();

    String firstName = firstNameController.text;
    String lastName = lastNameController.text.toString();
    String address = addressController.text.toString();
    String city = cityController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = selectedState.value;
    User? user = model.data?.user;

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      isLoading = true;
      update();
      debugPrint('imageFile: $imageFile');

      UserPostModel model = UserPostModel(
          firstname: firstName,
          lastName: lastName,
          mobile: user?.mobile ?? '',
          email: user?.email ?? '',
          username: user?.username ?? '',
          countryCode: user?.countryCode ?? '',
          country: user?.address?.country ?? '',
          mobileCode: '880',
          image: imageFile,
          address: address,
          state: state,
          zip: zip,
          city: city);

      bool b = await profileRepo.updateProfile(model, true);
      debugPrint('updateProfile: $b');

      if (b) {
        await loadProfileInfo();
        update();
      }
    } else {
      if (firstName.isEmpty) {
        CustomSnackBar.error(
          errorList: [MyStrings.kFirstNameNullError.tr],
        );
      }
      if (lastName.isEmpty) {
        CustomSnackBar.error(
          errorList: [MyStrings.kLastNameNullError.tr],
        );
      }
    }

    isSubmitLoading = false;
    update();
  }


// Method to fetch city and state from pincode
  Future<void> fetchCityAndStateFromPincode(String pincode) async {
    final String url = 'https://india-pincode-with-latitude-and-longitude.p.rapidapi.com/api/v1/pincode/$pincode';
    final Map<String, String> headers = {
      'X-RapidAPI-Host': 'india-pincode-with-latitude-and-longitude.p.rapidapi.com',
      'X-RapidAPI-Key': '35a1bdc619mshe0774f99498bfe5p1ff050jsnc9829dfcffcc',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          // Using the first result from the response
          cityController.text = data[0]['area'];
          //  selectedState.value = data[0]['state'];
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

  void loadData(ProfileResponseModel? model) {
    firstNameController.text = model?.data?.user?.firstname ?? '';
    profileRepo.apiClient.sharedPreferences.setString(
        SharedPreferenceHelper.userNameKey, '${model?.data?.user?.username}');
    lastNameController.text = model?.data?.user?.lastname ?? '';
    emailController.text = model?.data?.user?.email ?? '';
    mobileNoController.text = model?.data?.user?.mobile ?? '';
    addressController.text = model?.data?.user?.address?.address ?? '';
    stateController.text = model?.data?.user?.address?.state ?? '';
   // Check if the user's state is in the list of states and set it
  String userState = model?.data?.user?.address?.state ?? 'Select State';
  if (states.contains(userState)) {
    selectedState.value = userState;
  } else {
    selectedState.value = 'Select State'; // or any default value you prefer
  }
    zipCodeController.text = model?.data?.user?.address?.zip ?? '';
    cityController.text = model?.data?.user?.address?.city ?? '';
    imageUrl =
        model?.data?.user?.image == null ? '' : '${model?.data?.user?.image}';
        debugPrint(' profile imageUrl: $imageUrl');
    if (imageUrl.isNotEmpty && imageUrl != '') {
      imageUrl =
          '${UrlContainer.domainUrl}assets/images/user/profile/$imageUrl';
          debugPrint(' profile imageUrl final: $imageUrl');
    }
    isLoading = false;

    update();
  }
}
