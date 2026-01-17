import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormTextField extends StatelessWidget {
  final String labelText;
  final String suffixText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool enableInputFormatting;
  final Widget? suffixIcon;
  final bool isUpperCase;
  final List<TextInputFormatter>? inputFormatter;


  // final bool showSuffix;

  const FormTextField(
      {super.key,
      required this.labelText,
      required this.controller,
      this.suffixText = '',
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onChanged,
      this.enabled = true,
      this.enableInputFormatting = false,
      this.suffixIcon,
      this.isUpperCase = false,
      this.inputFormatter,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        inputFormatters: enableInputFormatting ? inputFormatter : null,
             // No input formatting



        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        enabled: enabled,



        readOnly: readOnly,
        decoration: InputDecoration(
          suffixText: suffixText,
          suffixIcon: suffixIcon,


          suffixStyle: const TextStyle(color: AppColors.accentColor),
         contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          labelText: labelText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
      ),
    );
  }
}
