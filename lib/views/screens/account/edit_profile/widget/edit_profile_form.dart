import 'package:finovelapp/views/screens/auth/profile_complete/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/data/controller/account/profile_controller.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/buttons/rounded_loading_button.dart';
import 'package:finovelapp/views/components/text-field/custom_text_field.dart';
import 'profile_image.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({
    super.key,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.space12),
                  CustomImageWidget(
                    isEdit: true,
                    imagePath: controller.imageFile?.path ?? controller.imageUrl,
                    onClicked: () {},
                  ),
                  const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  CustomTextField(
                    labelText: MyStrings.firstName.tr,
                    hintText: MyStrings.enterYourFirstName.tr,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    focusNode: controller.firstNameFocusNode,
                    controller: controller.firstNameController,
                    nextFocus: controller.lastNameFocusNode,
                    onChanged: (value) {
                      return;
                    },
                    validator: (value) => nameValidator(value),
                  ),
                  const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  CustomTextField(
                    labelText: MyStrings.lastName.tr,
                    hintText: MyStrings.enterYourLastName,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    focusNode: controller.lastNameFocusNode,
                    controller: controller.lastNameController,
                    nextFocus: controller.addressFocusNode,
                    onChanged: (value) {
                      return;
                    },
                    validator: (value) => validateNonEmpty(value, 'last name'),
                  ),
                  const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  CustomTextField(
                    labelText: 'House/Flat/Door No.',
                    hintText: 'Enter House/Flat/Door No.',
                    inputAction: TextInputAction.next,
                    controller: controller.addressController,  onChanged: (value) {
                      return;
                    },
                    validator: (value) =>
                        validateNonEmpty(value, 'House/Flat/Door No.'),
                    // Additional configurations...
                  ),
                  const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  // CustomTextField(
                  //   labelText: 'Locality/Area',
                  //   hintText: 'Enter Locality/Area',
                  //   controller: controller.addressController,
                  //   validator: (value) =>
                  //       validateNonEmpty(value, 'Locality/Area'),
                  //   onChanged: (value) {
                  //     return;
                  //   },
                  // ),
                  // const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  CustomTextField(
                    labelText: 'Pincode',
                    hintText: 'Enter Pincode',
                    controller: controller.zipCodeController,
                    onChanged: (value) {
                      if (value.length == 6) {
                        controller.fetchCityAndStateFromPincode(value);
                      }
                    },
                    validator: (value) => pincodeValidator(value),
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Accept only digits
                      LengthLimitingTextInputFormatter(6), // Limit to 6 digits
                    ],

                    // Additional configurations...
                  ),
                  const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  CustomTextField(
                    labelText: 'City',
                    hintText: 'Enter City',
                    controller: controller.cityController,
                    onChanged: (value) {
                      return;
                    },
                    // Additional configurations...
                  ),
                  const SizedBox(height: Dimensions.textFieldToTextFieldSpace),
                  Obx(() => DropdownButtonFormField<String>(
  value: controller.states.contains(controller.selectedState.value)
      ? controller.selectedState.value
      : null,
  onChanged: (newValue) {
    if (newValue != null && controller.states.contains(newValue)) {
      controller.selectedState.value = newValue;
    }
  },
  items: controller.states.map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
  decoration: const InputDecoration(
    labelText: MyStrings.state,
    hintText: MyStrings.enterYourState,
  ),
  validator: (value) {
    if (value == null || !controller.states.contains(value)) {
      return 'Please select a valid state.';
    }
    return null;
  },
),
),
                  const SizedBox(height: 20),
                  const Text(
                      '⚠️ Details once updated cannot be changed again for next 30 days',
                      style: TextStyle(fontSize: 14, color: Colors.red)),
                  const SizedBox(height: Dimensions.space35),
                  RoundedButton(
                    text: 'Save Profile',
                    textColor: MyColor.colorWhite,
                    press: () {
                      if (formKey.currentState!.validate()) {
                        controller.updateProfile();
                      }
                    },
                    color: MyColor.getPrimaryColor(),
                  ),
                ],
              ),
            ),
          ),
        );
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    if (!RegExp(r"^[a-zA-Z]+[a-zA-Z-']*$").hasMatch(value)) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? validateNonEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid $fieldName';
    }
    return null;
  }

  String? pincodeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode cannot be empty';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Enter a valid 6-digit Pincode';
    }
    return null;
  }
}
