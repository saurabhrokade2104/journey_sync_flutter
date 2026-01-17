import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final List<String> options;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final String currentValue;
  final bool isEditable; // Add this line

  const CustomDropdown({
    super.key,
    required this.labelText,
    required this.options,
    this.validator,
    this.onChanged,
    required this.currentValue,
    this.isEditable = true, // Default is true
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
        value: currentValue.isNotEmpty ? currentValue : null,
        onChanged: isEditable ? onChanged : null, // Check isEditable here
        validator: validator,

        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }
}
