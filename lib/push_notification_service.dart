import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:finovelapp/firebase_options.dart';
import 'core/helper/shared_preference_helper.dart';
import 'core/route/route.dart';
import 'data/repo/splash/splash_repo.dart';
import 'data/services/api_service.dart';

class PushNotificationService {

  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await _requestPermissions();

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {});

    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iOSSettings = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initSetttings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onDidReceiveNotificationResponse: (message) async {
      try {
        String? payloadString = message.payload is String
            ? message.payload
            : jsonEncode(message.payload);
        if (payloadString != null && payloadString.isNotEmpty) {
          Map<dynamic, dynamic> payloadMap = jsonDecode(payloadString);
          Map<String, String> payload = payloadMap
              .map((key, value) => MapEntry(key.toString(), value.toString()));
         /* String? remark = payload['for_app'];
          if (remark != null && remark.isNotEmpty) {
            checkAndRedirect(remark);
          }*/
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                  playSound: true,
                  enableVibration: true,
                  enableLights: true,
                  fullScreenIntent: true,
                  priority: Priority.high,
                  styleInformation: const BigTextStyleInformation(''),
                  importance: Importance.high),
            ),
            payload: jsonEncode(message.data));
      }
    });
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.',
        playSound: true,
        enableVibration: true,
        enableLights: true,
        importance: Importance.high,
      );

  checkAndRedirect(String remark) async {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    SplashRepo splashRepo = Get.put(SplashRepo(apiClient: Get.find()));
    splashRepo.apiClient.sharedPreferences
        .setBool(SharedPreferenceHelper.hasNewNotificationKey, true);
    bool rememberMe = splashRepo.apiClient.sharedPreferences
            .getBool(SharedPreferenceHelper.rememberMeKey) ??
        false;

    if (rememberMe) {
     /*
     List<String> trxHistoryRemark = [
        'BAL_ADD',
        'BAL_SUB',
        'REFERRAL-COMMISSION',
        'BALANCE_TRANSFER',
        'BALANCE_RECEIVE'
      ];
      List<String> withdrawRemark = [
        'WITHDRAW_APPROVE',
        'WITHDRAW_REJECT',
        'WITHDRAW_REJECT',
        'WITHDRAW_REQUEST'
      ];

      List<String> depositHistoryRemark = [
        'DEPOSIT_APPROVE',
        'DEPOSIT_COMPLETE',
        'DEPOSIT_REJECT',
        'DEPOSIT_REQUEST'
      ];
      List<String> loanHistoryRemark = [
        'LOAN_APPROVE',
        'LOAN_REJECT',
        'LOAN_PAID',
        'LOAN_INSTALLMENT_DUE'
      ];
      //List<String>homeRemark = ['KYC_REJECT'];*/

      Get.toNamed(RouteHelper.transactionScreen);
     /* if (trxHistoryRemark.contains(remark)) {
        Get.toNamed(RouteHelper.transactionScreen);
      }*/
    }
  }

  Future<void> _requestPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
await androidImplementation?.requestNotificationsPermission();
    }
  }
}
