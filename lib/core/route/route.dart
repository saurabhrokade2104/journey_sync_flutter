import 'package:finovelapp/views/screens/about/faq/tawk_to.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bnpl/credit_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bnpl/eligibility_check_form.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/bnpl/loan_success_screen.dart';
import 'package:finovelapp/views/screens/login_sms_verification/login_sms_verification_screen.dart';
import 'package:finovelapp/views/screens/referral/add_new_leads_screen.dart';
import 'package:finovelapp/views/screens/referral/application_tracking_screen.dart';
import 'package:finovelapp/views/screens/referral/dashboard_screen.dart';
import 'package:finovelapp/views/screens/referral/filter_screen.dart';
import 'package:finovelapp/views/screens/referral/main_dashboard.dart';
import 'package:finovelapp/views/screens/referral/my_sales_dashboard_screen.dart';
import 'package:finovelapp/views/screens/referral/referral_program_screen.dart';
import 'package:finovelapp/views/screens/referral/referral_steps.dart';
import 'package:finovelapp/views/screens/referral/revenue_screen.dart';
import 'package:finovelapp/views/screens/referral/terms_conditions_screen.dart';
import 'package:finovelapp/views/screens/repayment/enach_resgister.dart';
import 'package:finovelapp/views/screens/repayment/transfer_amount_screen.dart';
import 'package:finovelapp/views/screens/required%20screens/all_partners_screen.dart';
import 'package:finovelapp/views/screens/required%20screens/channel_partner_dashboard.dart';
import 'package:finovelapp/views/screens/required%20screens/earnings_from_partners_screen.dart';
import 'package:finovelapp/views/screens/required%20screens/faqq_screen.dart';
import 'package:finovelapp/views/screens/required%20screens/my_all_revenue_screen.dart';
import 'package:finovelapp/views/screens/required%20screens/my_sales_earnings_dash.dart';
import 'package:finovelapp/views/screens/required%20screens/reference_details_screen.dart';
import 'package:finovelapp/views/screens/required%20screens/support_screen.dart';
import 'package:get/get.dart';
import 'package:finovelapp/views/screens/all_loan/all_loan_screen.dart';
import 'package:finovelapp/views/screens/about/faq/faq_screen.dart';
import 'package:finovelapp/views/screens/about/privacy/privacy_screen.dart';
import 'package:finovelapp/views/screens/account/change-password/change_password_screen.dart';
import 'package:finovelapp/views/screens/account/profile/my_profile_screen.dart';
import 'package:finovelapp/views/screens/auth/email_verification_page/email_verification_screen.dart';
import 'package:finovelapp/views/screens/auth/forget-password/forget_password_screen.dart';
import 'package:finovelapp/views/screens/auth/kyc/kyc.dart';
import 'package:finovelapp/views/screens/auth/login/login_screen.dart';
import 'package:finovelapp/views/screens/auth/profile_complete/profile_complete_screen.dart';
import 'package:finovelapp/views/screens/auth/registration/registration_screen.dart';
import 'package:finovelapp/views/screens/auth/reset_password/reset_password_screen.dart';
import 'package:finovelapp/views/screens/auth/sms_verification_page/sms_verification_screen.dart';
import 'package:finovelapp/views/screens/auth/two_factor_screen/two_factor_verification_screen.dart';
import 'package:finovelapp/views/screens/auth/verify_forget_password/verify_forget_password_screen.dart';
import 'package:finovelapp/views/screens/deposits/deposit_webview/deposit_payment_webview.dart';
import 'package:finovelapp/views/screens/deposits/deposits_screen.dart';
import 'package:finovelapp/views/screens/deposits/new_deposit/new_deposit_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan_confirm_screen/loan_confirm_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan_installment_log/loan_installment_log_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/loan_screen/loan_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/loan/my_loan_screen/my_loan_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/menu/menu_screen.dart';
import 'package:finovelapp/views/screens/notification/notification_screen.dart';
import 'package:finovelapp/views/screens/otp_screen/otp_screen.dart';
import 'package:finovelapp/views/screens/splash/splash_screen.dart';
import 'package:finovelapp/views/screens/bottom_nav_screen/transaction/transaction_screen.dart';
import 'package:finovelapp/views/screens/withdraw/add_withdraw_screen/add_withdraw_method_screen.dart';
import 'package:finovelapp/views/screens/withdraw/confirm_withdraw_screen/withdraw_confirm_screen.dart';
import 'package:finovelapp/views/screens/withdraw/withdraw_history/withdraw_screen.dart';
import '../../views/screens/account/edit_profile/edit_profile_screen.dart';
import '../../views/screens/auth/permission/permission_screen.dart';
import '../../views/screens/bottom_nav_screen/home/home_screen_new.dart';
import '../../views/screens/onboard/onboarding_screen.dart';

class RouteHelper {

  static const String bottomNavScreen = '/bottom_nav_screen';
  static const String splashScreen = "/splash";
  static const String forgotPasswordScreen = "/forgot_password_screen";
  static const String onBoardScreen = "/onboard";
  static const String loginScreen = "/login";
  static const String registrationScreen = "/registration";
  static const String homeScreen = "/home_screen";
  static const String permissonScreen = "/permission_screen";

  static const String emailVerificationScreen = '/verify_email';
  static const String smsVerificationScreen = '/verify_sms';
  static const String loginSmsVerificationScreen = '/login-verify_sms';
  static const String forgetPasswordScreen = '/forget_password';
  static const String verifyPassCodeScreen = '/verify_pass_code';
  static const String resetPasswordScreen = '/reset_pass';
  static const String twoFactorVerificationScreen = '/two_fa_screen';
  static const String privacyScreen = '/privacy_screen';

  //account
  static const String profileScreen = '/profile';
  static const String editProfileScreen = "/edit_profile";
  static const String profileCompleteScreen = '/profile_complete_screen';
  static const String changePasswordScreen = '/change_password';

  //notification
  static const String notificationScreen = '/notification_screen';

  static const String kycScreen = '/kyc_screen';
  static const String menuScreen = '/menu_screen';



  //deposit
  static const String depositsScreen = "/deposits";
  static const String depositsDetailsScreen = "/deposits_details";
  static const String newDepositScreenScreen = "/deposits_money";
  static const String depositWebViewScreen = '/deposit_webView';

  //withdraw
  static const String withdrawScreen = "/withdraw";
  static const String addWithdrawMethodScreen = "/withdraw_method";

  static const String withdrawOtpScreen = "/withdraw_otp";
  static const String withdrawConfirmScreenScreen = "/withdraw_confirm_screen";

  static const String otpScreen = "/otp_screen";


  //load screen
  static const String loanScreen = "/loan_plan_screen";
  static const String allLoanPlanScreen = "/all_loan_plan_screen";
  static const String loanConfirmScreen = "/loan_confirm_screen";
  static const String applyLoanScreen = "/apply_loan";
  static const String loanInstallmentLogScreen = "/loan_installment_log_screen";
  static const String myLoanScreen = "/my_loan_screen";
  static const String loanSuccessScreen = "/loan_success_screen";
  static const String  eligibilityCheckForm = "/eligibility_check_form";
  static const String  creditScoreScreen = "/credit_score_screen";
  static const  String loanTransferScreen = "/loan_approval_screen";
  static const String enachRegisterScreen = "/enach_register_screen";

  //transaction screen
  static const String transactionScreen = "/transaction";

  //privacy policy screen
  static const String termsServicesScreen = "/terms_services";
  static const String faqScreen = "/faq-screen";
  static const String tawkToScreen = "/tawk_to_screen";

  //refer screen
  static const String referralScreen = "/referral";
  static const String referralStepsScreen = '/referralsteps';
  static const String termsAndConditionsScreen = '/tncscreen';
  static const String dashboardScreen = '/dashboardscreen';
  static const String mySalesDashboardScreen = '/mysalesdashboard';
  static const String addNewLeadsScreen = '/leadsscreen';
  static const String filterScreen = '/filterscreen';
  static const String revenueScreen = '/revenuescreen';
  static const String mainDashboardScreen = '/maindashscreen';
  static const String applicationTrackingScreen = '/applicationtrackingscreen';
  static const String referenceDetailsScreen = '/referencedetails';
  static const String supportScreen = '/supportscreen';
  static const String channelPartnerDashboardScreen = '/channelscreen';
  static const String allPartnersScreen = '/allpartners';
  static const String earningsFromPartnersScreen = '/earningfrompartners';
  static const String faqScreen2 = '/faqscreen2';
  static const String myAllRevenueScreen = '/myallrevenue';
  static const String mySalesEarningDashboardScreen = '/mysalesearningdashboard';


  static List<GetPage> routes = [
    GetPage(name: bottomNavScreen, page: () => const DashboardScreen()),
    //  GetPage(name: bottomNavScreen, page: () => const HomeScreenNew ()),
    GetPage(name: splashScreen, page: () => const DashboardScreen()),// Only for adding new lead button originally route was to Splashscreen();
    GetPage(name: forgotPasswordScreen, page: () => const ForgetPasswordScreen()),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: onBoardScreen, page: () => const OnBoardingScreen()),
    GetPage(name: registrationScreen, page: () =>  RegistrationScreen(phoneNumber: Get.arguments[0],)),
    GetPage(name: homeScreen, page: () => const HomeScreenNew()),
    GetPage(name: permissonScreen, page: () => const PermissonScreen()),
    GetPage(name: emailVerificationScreen, page: () => EmailVerificationScreen(needSmsVerification: Get.arguments[0], isProfileCompleteEnabled: Get.arguments[1], needTwoFactor: Get.arguments[2] ,emailId: Get.arguments[3],phoneNumber: Get.arguments[4],)),
    GetPage(name: smsVerificationScreen, page: () =>  SmsVerificationScreen(phoneNumber: Get.arguments[2],)),
    GetPage(name: loginSmsVerificationScreen, page: () => const LoginSmsVerificationScreen()),
    GetPage(name: forgetPasswordScreen, page: () => const ForgetPasswordScreen()),
    GetPage(name: verifyPassCodeScreen, page: () => const VerifyForgetPassScreen()),
    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),
    GetPage(name: profileCompleteScreen, page: () => const ProfileCompleteScreen()),
    GetPage(name: depositsScreen, page: () => const DepositsScreen()),
    GetPage(name: newDepositScreenScreen, page: () => const NewDepositScreen()),
    GetPage(name: withdrawScreen, page: () => const WithdrawScreen()),
    GetPage(name: addWithdrawMethodScreen, page: () => const AddWithdrawMethod()),
    GetPage(name: withdrawConfirmScreenScreen, page: () => const WithdrawConfirmScreen()),
    GetPage(name: allLoanPlanScreen, page: () => const AllLoanPlanScreen()),
    GetPage(name: loanScreen, page: () => const LoanScreen()),
    GetPage(name: loanConfirmScreen, page: () => const LoanConfirmScreen()),
    GetPage(name: loanInstallmentLogScreen, page: () => const LoanInstallmentLogScreen()),
    GetPage(name: myLoanScreen, page: () => const MyLoanScreen()),
    GetPage(name: eligibilityCheckForm, page: () =>   EligibilityCheckForm(isBigLoan: Get.arguments[0],)),
    GetPage(name: loanSuccessScreen, page: () =>  const LoanSuccessScreen()),
    GetPage(name: loanTransferScreen , page: () =>   TransferAmountScreen(loanAmount: Get.arguments[0],)),
    GetPage(name: enachRegisterScreen, page: () =>  const eNachRegisterScreen()),
    GetPage(name: creditScoreScreen, page: () =>   CreditScreen(elgibileAmount: Get.arguments[0],cibilScore: Get.arguments[1],showEligibleAmount: Get.arguments[2],)),
    GetPage(name: transactionScreen, page: () => const TransactionScreen()),
    GetPage(name: editProfileScreen, page: () => const EditProfileScreen()),
    GetPage(name: changePasswordScreen, page: () => const ChangePasswordScreen()),
    GetPage(name: menuScreen, page: () => const MenuScreen()),
    GetPage(name: profileScreen, page: () => const MyProfileScreen()),
    GetPage(name: termsServicesScreen, page: () => const PrivacyScreen()),
    GetPage(name: notificationScreen, page: () => const NotificationScreen()),
    GetPage(name: depositWebViewScreen, page: () => WebViewExample(redirectUrl: Get.arguments)),
    GetPage(name: faqScreen, page: () => const FaqScreen()),
    GetPage(name: tawkToScreen, page: () => const TawkSupport()),
    GetPage(name: privacyScreen, page: () => const PrivacyScreen()),
    GetPage(name: kycScreen, page: () => const KycScreen()),
    GetPage(name: otpScreen, page: () => const OtpScreen()),
    GetPage(name: twoFactorVerificationScreen, page: () => TwoFactorVerificationScreen(isProfileCompleteEnable: Get.arguments)),
    GetPage(name: referralScreen, page: () => const ReferralProgramScreen()),
    GetPage(name: referralStepsScreen, page: () => const ReferralSteps()),
    GetPage(name: termsAndConditionsScreen, page: () => const TermsAndConditionsScreen()),
    GetPage(name: dashboardScreen, page: () =>  const DashboardScreen()),
    GetPage(name: mySalesDashboardScreen, page: () => const MySalesDashboardScreen()),
    GetPage(name: addNewLeadsScreen, page: () => const AddNewLeadsScreen()),
    GetPage(name: filterScreen, page: () => const FilterScreen()),
    GetPage(name: revenueScreen, page: () => const RevenueScreen()),
    GetPage(name: mainDashboardScreen, page: () => const MainDashboard()),
    GetPage(name: applicationTrackingScreen, page: () =>  ApplicationTrackingScreen(leadId: Get.arguments,)),
    GetPage(name: referenceDetailsScreen, page: () => const ReferenceDetailsScreen()),
    GetPage(name: supportScreen, page: () => const SupportScreen()),
    GetPage(name: channelPartnerDashboardScreen, page: () => const ChannelPartnerDashboardScreen()),
    GetPage(name: allPartnersScreen, page: () => const AllPartnersScreen()),
    GetPage(name: earningsFromPartnersScreen, page: () => const EarningsFromPartnersScreen()),
    GetPage(name: faqScreen2, page: () => FAQScreen()),
    GetPage(name: myAllRevenueScreen, page: () => const MyAllRevenueScreen()),
    GetPage(name: mySalesEarningDashboardScreen, page: () => const MySalesEarningDashboardScreen()),

  ];
}
