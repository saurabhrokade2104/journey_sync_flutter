import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finovelapp/core/utils/dimensions.dart';
import 'package:finovelapp/core/utils/my_color.dart';
import 'package:finovelapp/core/utils/my_strings.dart';
import 'package:finovelapp/core/utils/style.dart';
import 'package:finovelapp/data/controller/deposit/add_new_deposit_controller.dart';
import 'package:finovelapp/data/model/authorized/deposit/deposit_method_response_model.dart';
import 'package:finovelapp/data/repo/deposit/deposit_repo.dart';
import 'package:finovelapp/data/services/api_service.dart';
import 'package:finovelapp/views/components/appbar/custom_appbar.dart';
import 'package:finovelapp/views/components/buttons/rounded_button.dart';
import 'package:finovelapp/views/components/buttons/rounded_loading_button.dart';
import 'package:finovelapp/views/components/custom_loader.dart';
import 'package:finovelapp/views/components/text-field/custom_amount_text_field.dart';
import 'package:finovelapp/views/components/text-field/custom_drop_down_button_with_text_field2.dart';
import 'package:finovelapp/views/screens/deposits/new_deposit/info_widget.dart';

class NewDepositScreen extends StatefulWidget {
  const NewDepositScreen({super.key});

  @override
  State<NewDepositScreen> createState() => _NewDepositScreenState();
}

class _NewDepositScreenState extends State<NewDepositScreen> {
  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(DepositRepo(apiClient: Get.find()));
    final controller = Get.put(AddNewDepositController(
      depositRepo: Get.find(),
    ));

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getDepositMethod();

      // ankit - for testing
      controller.amountController.text= 1000.toString();
      controller.changeInfoWidgetValue(1000);
      // controller.setPaymentMethod(Methods(name: 'Razorpay'));
      controller.amount = 1000.toString();



    });
  }

  @override
  void dispose() {
    Get.find<AddNewDepositController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddNewDepositController>(
      builder: (controller) => SafeArea(
          child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor2(),
        appBar: CustomAppBar(title: MyStrings.newDepositScreen),
        body: controller.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                padding: Dimensions.screenPaddingHV1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: MyColor.getScreenBgColor2(),
                    borderRadius:
                        BorderRadius.circular(Dimensions.defaultBorderRadius),
                  ),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropDownTextField2(
                          labelText: MyStrings.paymentMethod.tr,
                          selectedValue: controller.paymentMethod,
                          onChanged: (newValue) {
                            controller.setPaymentMethod(newValue);
                          },
                          items: controller.methodList.map((Methods bank) {
                            return DropdownMenuItem<Methods>(
                              value: bank,
                              child: Text((bank.name ?? '').tr,
                                  style: interRegularDefault),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: Dimensions.space15),
                        CustomAmountTextField(
                          labelText: MyStrings.amount.tr,
                          hintText: MyStrings.enterAmount.tr,
                          inputAction: TextInputAction.done,
                          currency: controller.currency,
                          controller: controller.amountController,
                          onChanged: (value) {
                            if (value.toString().isEmpty) {
                              controller.changeInfoWidgetValue(0);
                            } else {
                              double amount =
                                  double.tryParse(value.toString()) ?? 0;
                              controller.changeInfoWidgetValue(amount);
                            }
                            return;
                          },
                        ),
                        controller.paymentMethod?.name != MyStrings.selectOne
                            ? const InfoWidget()
                            : const SizedBox(),
                        const SizedBox(height: 35),
                        controller.submitLoading
                            ? const RoundedLoadingBtn()
                            : RoundedButton(
                                text: MyStrings.submit,
                                textColor: MyColor.textColor,
                                width: double.infinity,
                                press: () {
                                  controller.submitDeposit();
                                },
                              )
                      ],
                    ),
                  ),
                ),
              ),
      )),
    );
  }
}
