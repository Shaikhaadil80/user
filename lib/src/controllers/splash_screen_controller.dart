import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/custom_trace.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

class SplashScreenController extends ControllerMVC {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  late GlobalKey<ScaffoldState>? scaffoldKey;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SplashScreenController() {
    this.scaffoldKey = GlobalKey<ScaffoldState>();

    // Should define these variables before the app loaded
    progress.value = {"Setting": 0, "User": 0};
  }

  @override
  void initState() {
    init();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    configLocalNotification();
    //getMyCurrantLocation();
    super.initState();
  }

  Future<void> displayNotification(
      String title, String body, String? image) async {
    ByteArrayAndroidBitmap? androidBitmap;

    if (image != null) {
      try {
        Uint8List uint8list = (await http.get(Uri.parse(image))).bodyBytes;
        androidBitmap = ByteArrayAndroidBitmap(uint8list);
      } catch (_) {}
    }
    //android notification details
    var androidNotificationDetails = AndroidNotificationDetails(
      'channel_01',
      'apache_notification_channel',
      channelDescription: 'apache app uses this channel to send notifications',
      importance: Importance.max,
      priority: Priority.max,
      channelShowBadge: true,
      ledOffMs: 3000,
      ledOnMs: 5000,
      largeIcon: androidBitmap != null ? androidBitmap : null,
      styleInformation: BigTextStyleInformation(body, contentTitle: title),
      category: "CATEGORY_SERVICE",
      autoCancel: false,
      visibility: NotificationVisibility.public,
      enableVibration: true,
      playSound: true,
    );

    var notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: '');
  }

  void configLocalNotification() async {
    await flutterLocalNotificationsPlugin
        .initialize(const InitializationSettings(
            android: AndroidInitializationSettings('ic_notification'),
            iOS: IOSInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            )));
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(const AndroidNotificationChannel(
            'channel_01',
            'apache_notification_channel',
            description: 'apache app uses this channel to send notifications',
            enableVibration: true,
            enableLights: true,
            importance: Importance.max,
            showBadge: true,
            playSound: true,
          ));
    }
  }

  void init() async {
    firebaseMessaging.setAutoInitEnabled(true);
    firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    final notificationAuth = firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    configureFirebase(firebaseMessaging);
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != '') {
        progress.value["Setting"] = 41;
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        progress.notifyListeners();
      }
    });
    userRepo.currentUser.addListener(() {
      progress.value["User"] = 59;
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      progress.notifyListeners();
    });
    Timer(const Duration(seconds: 20), () {
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    });
  }

  void configureFirebase(FirebaseMessaging _firebaseMessaging) {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
        if (remoteMessage.notification != null) {
          displayNotification(
              remoteMessage.notification!.title!,
              remoteMessage.notification!.body!,
              remoteMessage.notification!.android!.imageUrl);
        } else {
          displayNotification(remoteMessage.data['title'],
              remoteMessage.data['body'], remoteMessage.data['image']);
        }
      });
      _firebaseMessaging.subscribeToTopic('customers');
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
      print(CustomTrace(StackTrace.current, message: 'Error Config Firebase'));
    }
  }

  Future notificationOnResume(Map<String, dynamic> message) async {
    try {
      if (message['data']['id'] == "orders") {
        settingRepo.navigatorKey.currentState!
            .pushReplacementNamed('/Pages', arguments: 2);
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Future notificationOnLaunch(Map<String, dynamic> message) async {
    String messageId = await settingRepo.getMessageId();
    try {
      if (messageId != message['google.message_id']) {
        if (message['data']['id'] == "orders") {
          await settingRepo.saveMessageId(message['google.message_id']);
          settingRepo.navigatorKey.currentState!
              .pushReplacementNamed('/Pages', arguments: 2);
        }
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }

  Future getMyCurrantLocation() async {
    try {
      await settingRepo.setCurrentLocation();
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e.toString()));
    }
  }
  // Future getMyCurrantLocation() async {
  //   try {
  //     await settingRepo.setCurrentLocation();
  //   } catch (e) {
  //     print(CustomTrace(StackTrace.current, message: e.toString()));
  //   }
  // }

  Future notificationOnMessage(Map<String, dynamic> remoteMessage) async {
    // Fluttertoast.showToast(
    //   msg: message['notification']['title'],
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.TOP,
    //   timeInSecForIosWeb: 5,
    // );
    if (remoteMessage['data']['title'] != null) {
      displayNotification(remoteMessage['data']['title'],
          remoteMessage['data']['body'], remoteMessage['data']['image']);
    } else {
      displayNotification(
          remoteMessage['notification']['title'],
          remoteMessage['notification']['body'],
          remoteMessage['notification']['image']);
    }
  }
}
