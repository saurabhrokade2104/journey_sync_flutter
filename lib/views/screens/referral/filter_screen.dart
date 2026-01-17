import 'package:finovelapp/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedStatus = 'Paid';
  final List<String> _statuses = [
    'Paid',
    'Pending',
    'Failed',
    'Locked',
    'Rejected'
  ];
  bool _isStatusOpen = false;
  void _openStatusContainer() {
    setState(() {
      _isStatusOpen = !_isStatusOpen;
    });
  }

  void _selectStatus(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  ///////////////////////// for time range//////////////////////////////////
  String _selectedTimeRange = 'Last Month';

  final List<String> _timeRange = [
    'This Week',
    'Last Week',
    'This Month',
    'Last Month'
  ];
  bool _isTimeRangeOpen = false;

  void _openTimeRangeContainer() {
    setState(() {
      _isTimeRangeOpen = !_isTimeRangeOpen;
    });
  }

  void _selectTimeRange(String timerange) {
    setState(() {
      _selectedTimeRange = timerange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
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
                    top: 42.h,
                    left: 20.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.popAndPushNamed(
                                context, '/mysalesdashboard'),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    size: 15.r,
                                    color: AppColors.whiteColor,
                                  ),
                                  const Text(
                                    'BACK',
                                    style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                "assets/imgs/notification.png",
                                height: 40.h,
                                width: 40.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  /////////////////////// Status //////////////////////////
                  // GestureDetector(
                  //   onTap: _openStatusContainer,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.black12),
                  //       borderRadius: BorderRadius.circular(8.r),
                  //       color: Colors.white,
                  //     ),
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //           padding: EdgeInsets.symmetric(
                  //               horizontal: 12.w, vertical: 16.h),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 'Status',
                  //                 style: TextStyle(
                  //                     fontSize: 16.sp,
                  //                     color: Colors.black,
                  //                     fontWeight: FontWeight.bold),
                  //               ),
                  //               Icon(_isStatusOpen
                  //                   ? Icons.keyboard_arrow_up_outlined
                  //                   : Icons.keyboard_arrow_down_outlined),
                  //             ],
                  //           ),
                  //         ),
                  //         if (_isStatusOpen)
                  //           Column(
                  //             children: [
                  //               Divider(color: Colors.black12, height: 1.h),
                  //               Container(
                  //                 padding: EdgeInsets.all(8.0.r),
                  //                 child: Wrap(
                  //                   spacing: 10.0.w, // space horizontal
                  //                   runSpacing: 14.0.h, // rows vertical space
                  //                   children: _statuses.map((status) {
                  //                     bool isSelected =
                  //                         _selectedStatus == status;
                  //                     return GestureDetector(
                  //                       onTap: () {
                  //                         _selectStatus(status);
                  //                       },
                  //                       child: Container(
                  //                         width: (MediaQuery.of(context)
                  //                                     .size
                  //                                     .width -
                  //                                 64) /
                  //                             2,
                  //                         padding: EdgeInsets.symmetric(
                  //                             vertical: 20.h, horizontal: 8.w),
                  //                         decoration: BoxDecoration(
                  //                           color: isSelected
                  //                               ? const Color(0xFF1769E9)
                  //                               : const Color(0xffE8F0FD),
                  //                           borderRadius:
                  //                               BorderRadius.circular(8.r),
                  //                         ),
                  //                         alignment: Alignment.center,
                  //                         child: Text(
                  //                           status,
                  //                           style: TextStyle(
                  //                               color: isSelected
                  //                                   ? Colors.white
                  //                                   : Colors.black,
                  //                               fontSize: 16.sp,
                  //                               fontWeight: FontWeight.w500),
                  //                         ),
                  //                       ),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  /////////////////////// Time Range //////////////////////////
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: _openTimeRangeContainer,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Time Range',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(_isTimeRangeOpen
                                    ? Icons.keyboard_arrow_up_outlined
                                    : Icons.keyboard_arrow_down_outlined),
                              ],
                            ),
                          ),
                          if (_isTimeRangeOpen)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(color: Colors.black12, height: 1.h),
                                Container(
                                  padding: EdgeInsets.all(8.0.r),
                                  child: Wrap(
                                    spacing: 10.0.w, // space horizontal
                                    runSpacing: 14.0.h, // rows vertical space
                                    children: _timeRange.map((status) {
                                      bool isSelected =
                                          _selectedTimeRange == status;
                                      return GestureDetector(
                                        onTap: () {
                                          _selectTimeRange(status);
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  64) /
                                              2,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.h, horizontal: 8.w),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFF1769E9)
                                                : const Color(0xffE8F0FD),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding: EdgeInsets.only(left: 12.0.w),
                                  child: Text(
                                    "Custom Date",
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                const DatePickerField(),
                                SizedBox(height: 20.h)
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          textStyle: TextStyle(fontSize: 18.sp),
                          backgroundColor: const Color(0xffE8F0FD),
                          foregroundColor: const Color(0xFF1769E9),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                      child: Padding(
                        padding: EdgeInsets.all(14.0.r),
                        child: Text(
                          "CLEAR FILTER",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          textStyle: TextStyle(fontSize: 18.sp),
                          backgroundColor: const Color(0xFF1769E9),
                          foregroundColor: const Color(0xffE8F0FD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.r))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        child: Text(
                          "APPLY",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  const DatePickerField({super.key});

  @override
  DatePickerFieldState createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: TextField(
        controller: _dateController,
        decoration: InputDecoration(
          hintText: 'DD/MM/YYYY',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0.r)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
        ),
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }
}
