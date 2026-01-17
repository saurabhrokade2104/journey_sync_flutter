import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  bool isBank = true;
  bool isSavingAccount = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/header_bg.png',
            fit: BoxFit.fill, width: double.infinity, height: 160),
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
          padding: EdgeInsets.only(left: 10.0, top: 80),
          child: Text(
            'Transaction History',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 115),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(6)),
                height: 30,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('2023'), Icon(Icons.arrow_drop_down)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 115),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(6)),
                height: 30,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('All Transaction'),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 175.0, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColors.greyColor),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Today',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )),
                const SizedBox(
                  height: 7,
                ),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Flexi Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salary Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Insta Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '4,76,749',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Flexi Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salary Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salary Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColors.greyColor),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        '23 Jul 2023',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )),
                const SizedBox(
                  height: 7,
                ),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Flexi Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salary Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Insta Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '4,76,749',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Flexi Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salary Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Flexi Loan- 2nd EMI',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                          Text(
                            '16,749',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                const Divider(),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        )
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
