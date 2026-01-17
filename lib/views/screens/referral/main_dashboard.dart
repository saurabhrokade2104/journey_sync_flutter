import 'package:finovelapp/core/utils/colors.dart';
import 'package:finovelapp/data/controller/leads/lead_controller.dart';
import 'package:finovelapp/data/repo/leads/lead_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  late LeadController controller;

   TextEditingController searchController = TextEditingController();
    String? selectedStatus;

  @override
  void initState() {
    super.initState();
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(LeadRepo(apiClient: Get.find()));

    controller = Get.put(LeadController(leadRepo: Get.find()));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       selectedStatus = Get.arguments?['status'] ?? 'all';
      controller.fetchLeads(selectedStatus);
    });

     searchController.addListener(() {
      controller.searchLeads(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 18.0.h),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Lead ID, Name, Mobile Number',
                  hintStyle: const TextStyle(color: Colors.black45),
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0.h, vertical: 12.0.w),
                ),
              ),
            ),

            // GetBuilder<LeadController>(builder: (leadController) {
            //   return Column(
            //     children: leadController.leads.map((lead) {
            //       if (leadController.submitLoading) {
            //         return const Center(child: CircularProgressIndicator());
            //       } else if (leadController.leads.isEmpty) {
            //         return const Center(child: Text('No leads available.'));
            //       } else {
            //         return buildData(
            //           lead.fullName ?? '',
            //           lead.mobileNumber ?? '',
            //           lead.id.toString(),
            //           lead.requirementType ?? '',
            //           lead.loanAmount ?? '',
            //           lead.status ?? '',
            //           () {
            //             Navigator.pushNamed(
            //                 context, '/applicationtrackingscreen');
            //           },
            //         );
            //       }
            //     }).toList(),
            //   );
            // }),


            Obx(() {
              if (controller.submitLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.filteredLeads.isEmpty) {
                return const  Center(child: Text('No leads available.'));
              } else {
                return Column(
                  children: controller.filteredLeads.map((lead) {
                    return buildData(
                      lead.fullName ?? '',
                      lead.mobileNumber ?? '',
                      lead.id.toString(),
                      lead.requirementType ?? '',
                      lead.loanAmount ?? '',
                      lead.status ?? '',
                      () {
                        Navigator.pushNamed(context, '/applicationtrackingscreen',arguments: lead.id);
                      },
                    );
                  }).toList(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
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
          padding: EdgeInsets.only(top: 42.h, left: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.popAndPushNamed(context, '/mysalesdashboard'),
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
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Image.asset(
                        "assets/imgs/notification.png",
                        height: 40.h,
                        width: 40.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.only(right: 16.0.w),
                child: Row(
                  children: [
                    Text(
                      "Dashboard",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8)),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/filterscreen');
                        },
                        icon: SvgPicture.asset("assets/images/filter.svg"),
                        label: const Text("Filter"),
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildData(
      String name,
      String number,
      String leadId,
      String product,
      String loanAmount,
      String leadStatus,
      VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.all(14.0.r),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.all(8.0.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 180.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      paddedText('User Name:'),
                      paddedText('Mobile Number:'),
                      paddedText('Lead Id:'),
                      paddedText('Product:'),
                      paddedText('Loan Amount:'),
                      paddedText('Lead Status:'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    paddedText(name),
                    paddedText(number),
                    paddedText(leadId),
                    paddedText(product),
                    paddedText(loanAmount),
                    paddedText(leadStatus),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paddedText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.sp, color: Colors.black87),
      ),
    );
  }
}
