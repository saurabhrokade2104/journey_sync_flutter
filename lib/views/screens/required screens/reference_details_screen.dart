import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReferenceDetailsScreen extends StatefulWidget {
  const ReferenceDetailsScreen({super.key});

  @override
  State<ReferenceDetailsScreen> createState() => _ReferenceDetailsScreenState();
}

class _ReferenceDetailsScreenState extends State<ReferenceDetailsScreen> {
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  void _toggleCheckbox1() {
    setState(() {
      _isChecked1 = !_isChecked1;
    });
  }

  void _toggleCheckbox2() {
    setState(() {
      _isChecked2 = !_isChecked2;
    });
  }

  String? selectedRelation1;
  String? selectedRelation2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/imgs/header_bg1.png',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 190.h,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 60.h,
                    left: 20.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0.w),
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
                        ],
                      ),
                      SizedBox(height: 40.h),
                      const Text(
                        'Reference Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Reference Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const Text(
                    "Please provide 2 References for your Loan Application",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            //reference 1
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleCheckbox1,
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                            child: _isChecked1
                                ? Center(
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        const Text("Reference 1",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    buildTextField("Enter Referred Name", "Name"),
                    SizedBox(height: 20.h),
                    builddropdownField(
                        value: selectedRelation1,
                        hintText: "Select Relation",
                        items: [
                          "Father",
                          "Mother",
                          "Spouse",
                          "Brother",
                          "Sister"
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRelation1 = newValue;
                          });
                        },
                        labelText: "Select Relation"),
                    SizedBox(height: 20.h),
                    buildTextField("Mobile Number", "Mobile Number"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),

            //reference 2
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleCheckbox2,
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                            child: _isChecked2
                                ? Center(
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        const Text(
                          "Reference 2",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    buildTextField("Enter Referred Name", "Name"),
                    SizedBox(height: 20.h),
                    builddropdownField(
                        value: selectedRelation1,
                        hintText: "Select Relation",
                        items: [
                          "Father",
                          "Mother",
                          "Spouse",
                          "Brother",
                          "Sister",
                          "Friend",
                          "Relative",
                          "Colleague"
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRelation2 = newValue;
                          });
                        },
                        labelText: "Select Relation"),
                    SizedBox(height: 20.h),
                    buildTextField("Mobile Number", "Mobile Number"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.security_sharp,
                        color: Colors.green.shade400,
                      ),
                      SizedBox(width: 5.w),
                      const Text(
                        "Your data is safe with us.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18.sp),
                      backgroundColor: const Color(0xFF1769E9),
                      foregroundColor: MyColor.whiteColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.h,
                        child: Center(
                          child: Text(
                            "SAVE AND CONTINUE",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

Widget buildTextField(String hintText, String labelText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: 8.h),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(8.r)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8.r)),
            hintText: hintText,
          ),
        ),
      ),
    ],
  );
}

Widget builddropdownField({
  required String? value,
  required String hintText,
  required List<String> items,
  required void Function(String?) onChanged,
  required String labelText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: 8.h),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              children: [
                Expanded(
                  child: Text(
                    hintText,
                  ),
                ),
              ],
            ),
            items: items
                .map((String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                      ),
                    ))
                .toList(),
            value: value,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              iconSize: 28.sp,
            ),
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              maxHeight: 500.h,
              width: 365.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 40.h,
              padding: EdgeInsets.only(left: 10.w, right: 25.w),
            ),
          ),
        ),
      ),
    ],
  );
}
