import 'package:flutter/material.dart';

import '../../../core/utils/colors.dart';
import '../custom_loader.dart';

class FormButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool isLoading;

  const FormButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  _FormButtonState createState() => _FormButtonState();
}

class _FormButtonState extends State<FormButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          foregroundColor: AppColors.primaryColor.withOpacity(0.0),
          backgroundColor: AppColors.primaryColor,
        ),
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: widget.isLoading
                ? const CustomLoader()
                : Text(widget.buttonText, style: const TextStyle(color: AppColors.whiteColor)),
          ),
        ),
      ),
    );
  }
}
