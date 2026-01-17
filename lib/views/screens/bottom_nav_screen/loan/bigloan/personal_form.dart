import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';


import 'package:intl/intl.dart';

class PersonalFormScreen extends StatefulWidget {
  const PersonalFormScreen({super.key});

  @override
  State<PersonalFormScreen> createState() => _PersonalFormScreenState();
}

class _PersonalFormScreenState extends State<PersonalFormScreen> {
  bool isMale = false;
  bool isMarried = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/header_bg.png',
            fit: BoxFit.fill, width: double.infinity, height: 130),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            color: AppColors.primaryColor.withOpacity(1.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  foregroundColor: AppColors.primaryColor.withOpacity(0.0),
                  backgroundColor: AppColors.primaryColor.withOpacity(1.0)),
              onPressed: () => {
                Navigator.pop(context)
                // Navigator.of(context).push(
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             const StatusScreen())),
              },
              child: const SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                    child: Text('Save & Next',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ))),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 50),
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
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 90),
          child: Text(
            '(1) Personal Details',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 140.0, left: 10, right: 10, bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                 const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Fill Person Details'),
                    )),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Full Name as per PAN',
                        hintText: 'Full Name as per PAN'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        (
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        (
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          // dateInput.text =
                          //     formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    maxLines: 1,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Date of Birth',
                        hintText: 'Date of Birth'),
                  ),
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Gender'),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          isMale = true;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: isMale
                                  ? AppColors.cardFillColor
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: isMale
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
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: AppColors.blackColor)),
                                  child: Center(
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
                                    top: 12.0, bottom: 12, left: 0),
                                child: Text('Male'),
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
                            isMale = false;
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isMale
                                    ? AppColors.whiteColor
                                    : AppColors.cardFillColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: isMale
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
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: AppColors.blackColor)),
                                    child: Center(
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
                                        top: 12.0, bottom: 12, left: 0),
                                    child: Text('Female'))
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Mobile Number',
                        hintText: 'Mobile Number'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Email ID',
                        hintText: 'Email ID'),
                  ),
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Marital Status'),
                    )),
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {
                            isMarried = true;
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isMarried
                                    ? AppColors.cardFillColor
                                    : AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: isMarried
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
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: AppColors.blackColor)),
                                    child: Center(
                                      child: isMarried
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
                                  child: Text('Single'),
                                )
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          isMarried = false;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: isMarried
                                  ? AppColors.whiteColor
                                  : AppColors.cardFillColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: isMarried
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
                                      border: Border.all(
                                          color: AppColors.blackColor)),
                                  child: Center(
                                    child: !isMarried
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
                                  child: Text('Married'))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                isMarried ?singleWidget(): marridWidget(),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Qualification',
                        hintText: 'Qualification'),
                  ),
                ),
                const Divider(),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('Additional Details'),
                    )),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Pan Card Number',
                        hintText: 'Pan Card Number'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Aadhaar Number',
                        hintText: 'Aadhaar Number'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        labelText: 'Purpose of Loan',
                        hintText: 'Purpose of Loan'),
                  ),
                ),
                const SizedBox(
                  height: 90,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget marridWidget() {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                labelText: 'Spouse Name',
                hintText: 'Spouse Name'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                labelText: 'No. of Kids',
                hintText: 'No. of Kids'),
          ),
        )
      ],
    );
  }

  Widget singleWidget() {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 1,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                labelText: 'Mother Name',
                hintText: 'Mother Name'),
          ),
        ),
      ],
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
