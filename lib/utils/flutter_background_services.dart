import 'dart:async';
import 'dart:ui';

import 'package:background_location/background_location.dart';
import 'package:background_sms/background_sms.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';
import 'package:women_safety_app/db/db_services.dart';
import 'package:women_safety_app/model/contactsm.dart';

sendMessage(String messageBody) async {
  List<TContact> contactList = await DatabaseHelper().getContactList();
  if (contactList.isEmpty) {
    Fluttertoast.showToast(msg: "no number exist please add a number");
  } else {
    for (var i = 0; i < contactList.length; i++) {
      Telephony.backgroundInstance
          .sendSms(to: contactList[i].number, message: messageBody)
          .then((value) {
        Fluttertoast.showToast(msg: "message send");
      });
    }
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    "script academy",
    "foregrounf service",
    "used for imp notifcation",
    importance: Importance.low,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: true,
        notificationChannelId: "script academy",
        initialNotificationTitle: "foregrounf service",
        initialNotificationContent: "initializing",
        foregroundServiceNotificationId: 888,
      ));
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  Location? clocation;

  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  await BackgroundLocation.setAndroidNotification(
    title: "Location tracking is running in the background!",
    message: "You can turn it off from settings menu inside the app",
    icon: '@mipmap/ic_logo',
  );
  BackgroundLocation.startLocationService(
    distanceFilter: 20,
  );

  BackgroundLocation.getLocationUpdates((location) {
    clocation = location;
  });
  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      // await Geolocator.getCurrentPosition(
      //         desiredAccuracy: LocationAccuracy.high,
      //         forceAndroidLocationManager: true)
      //     .then((Position position) {
      //   _curentPosition = position;
      //   print("bg location ${position.latitude}");
      // }).catchError((e) {
      //   //Fluttertoast.showToast(msg: e.toString());
      // });

      ShakeDetector.autoStart(
          shakeThresholdGravity: 7,
          shakeSlopTimeMS: 500,
          shakeCountResetTime: 3000,
          minimumShakeCount: 1,
          onPhoneShake: () async {
            if (await Vibration.hasVibrator() ?? false) {
              print("Test 2");
              if (await Vibration.hasCustomVibrationsSupport() ?? false) {
                print("Test 3");
                Vibration.vibrate(duration: 1000);
              } else {
                print("Test 4");
                Vibration.vibrate();
                await Future.delayed(Duration(milliseconds: 500));
                Vibration.vibrate();
              }
              print("Test 5");
            }
            String messageBody =
                "https://www.google.com/maps/search/?api=1&query=${clocation!.latitude}%2C${clocation!.longitude}";
            sendMessage(messageBody);
          });

      flutterLocalNotificationsPlugin.show(
        888,
        "women safety app",
        clocation == null
            ? "please enable location to use app"
            : "shake feature enable ${clocation!.latitude}",
        NotificationDetails(
            android: AndroidNotificationDetails(
          "script academy",
          "foregrounf service",
          "used for imp notifcation",
          icon: 'ic_bg_service_small',
          ongoing: true,
        )),
      );
    }
  }
}
