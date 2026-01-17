
import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/data/controller/loan/big_loan_controller.dart';
import 'package:flutter/material.dart';




class UploadDocFormScreen extends StatelessWidget {
  final BigLoanApplyController loanApplyController;
  const UploadDocFormScreen({super.key, required this.loanApplyController});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/header_bg.png',
            fit: BoxFit.fill, width: double.infinity, height: 130),

        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 55),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: AppColors.whiteColor,
                ),
                Text(
                  'BACK',
                  style: TextStyle(
                      color: AppColors.whiteColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 90),
          child: Text(
            '(4) Upload Documents',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 140.0, left: 10, right: 10, bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Fill Details',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Upload Live Photo'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 10),
                  child: Text(
                    'Kyc Proof Documents',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Pan Card'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Aadhaar Card Front'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Aadhaar Card Back'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 10),
                  child: Text(
                    'Financial Proof',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Last 3 Month Salary Slip'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Last 6 Month Salary Credited Statement'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText:
                            'Recent Organisation Offer/Appointment Letter'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Form 16'),
                  ),
                ),

                  Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 10),
                  child: Text(
                    'Current Residential Proof',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'House Rent Agreement'),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Gas Bill'),
                  ),
                ),
                  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Electricity Bill'),
                  ),
                ),
                  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        hintText: 'Any other Current Residential Proof'),
                  ),
                ),
                SizedBox(
                  height: 90,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

}

class CustomRadio extends StatelessWidget {
  final Gender _gender;

  const CustomRadio(this._gender, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: _gender.isSelected ? const Color(0xFF3B4257) : Colors.white,
        child: Container(
          height: 80,
          width: 80,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Text(
                _gender.name,
                style: TextStyle(
                    color: _gender.isSelected ? Colors.black : Colors.grey),
              )
            ],
          ),
        ));
  }
}

class Gender {
  String name;
  bool isSelected;

  Gender(this.name, this.isSelected);
}
