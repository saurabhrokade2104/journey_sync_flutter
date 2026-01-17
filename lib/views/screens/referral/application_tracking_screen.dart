import 'dart:math';

import 'package:finovelapp/data/controller/leads/lead_tracker_controller.dart';
import 'package:finovelapp/data/model/leads/lead_tracker_response_model.dart';
import 'package:finovelapp/data/repo/leads/lead_tracker_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ApplicationTrackingScreen extends StatefulWidget {
  final int leadId;

  const ApplicationTrackingScreen({required this.leadId, super.key});

  @override
  _ApplicationTrackingScreenState createState() =>
      _ApplicationTrackingScreenState();
}

class _ApplicationTrackingScreenState extends State<ApplicationTrackingScreen> {
  late LeadApplicationTrackerController controller;

  @override
  void initState() {
    super.initState();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadApplicationTrackerRepo(apiClient: Get.find()));
    controller = Get.put(LeadApplicationTrackerController(leadRepo: Get.find()));
    controller.fetchApplicationTracker(widget.leadId);
  }

  List<Step> _buildSteps(LeadApplicationTrackerResponse? response) {
    if (response == null ||
        response.data == null ||
        response.data?.applicationTracker == null) {
      return [];
    }

    return response.data!.applicationTracker!.map((tracker) {
      bool isCompleted = tracker.status == 'completed';
      return Step(
        title: _buildStepTitle(tracker.description ?? '', isCompleted),
        subtitle: _buildStepSubtitle( _formatTimestamp(tracker.timestamp??''),),
        content: const SizedBox.shrink(),
        isActive: isCompleted,
        state: isCompleted ? StepState.complete : StepState.indexed,
      );
    }).toList();
  }

  String _formatTimestamp(String timestamp) {
    try {
      // Parse the timestamp string into a DateTime object
      DateTime dateTime = DateTime.parse(timestamp);

      // Format the DateTime object to a readable string
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      // In case of an error, return the original timestamp or an empty string
      return timestamp;
    }
  }

   Future<void> _refreshData() async {
    await controller.fetchApplicationTracker(widget.leadId);
  }

// Calculate the current step
int _calculateCurrentStep(LeadApplicationTrackerResponse? response) {
  final steps = _buildSteps(response);
  // Use indexWhere to find the first non-completed step
  int stepIndex = response?.data?.applicationTracker
          ?.indexWhere((tracker) => tracker.status != 'completed') ??
      0;

  // Ensure currentStep is within the valid range [0, steps.length - 1]
  return max(0, min(stepIndex, steps.length - 1));
}


  Widget _customStepIconBuilder(int index, StepState state) {
     final Color backgroundColor =
        state == StepState.complete ? Colors.green : Colors.grey;
    final Color iconColor = Colors.white;

    return Container(
      width: 30.r,
      height: 30.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: Center(
        child: Icon(
          index == 2 ? Icons.verified_rounded : Icons.check,
          size: 18.r,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildStepTitle(String title, bool isActive) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0.h),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStepSubtitle(String subtitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  size: 15.r,
                                  color: Colors.white,
                                ),
                                const Text(
                                  'BACK',
                                  style: TextStyle(
                                      color: Colors.white,
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
                      'Loan Application Tracker',
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                 // Use the helper method to calculate currentStep
              final currentStep = _calculateCurrentStep(controller.trackerResponse.value);

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Transform.translate(
                    offset: Offset(0, -30.h),
                    child: Stepper(
                      connectorColor:
                          WidgetStatePropertyAll(Colors.green.shade500),
                     currentStep: currentStep,

                      onStepTapped: (index) {},
                      onStepContinue: null,
                      onStepCancel: null,
                      steps: _buildSteps(controller.trackerResponse.value),
                      stepIconBuilder: _customStepIconBuilder,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return Container();
                      },
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
