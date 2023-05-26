import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var  initializationSettingsDarwin = const DarwinInitializationSettings();

  Future initialize() async {
    // Request permission for receiving notifications
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,
      );

       AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'hello', 
        'hello', 
        channelDescription: 'hello',
        importance: Importance.max,
        priority: Priority.max, 
        styleInformation: bigTextStyleInformation, 
        playSound: true
      );

      
      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        0, 
        message.notification?.title, 
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['title']);
      });
  

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'hello', 
        'hello', 
        channelDescription: 'hello',
        importance: Importance.max,
        priority: Priority.max, 
        styleInformation: bigTextStyleInformation, 
        playSound: true
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        0, 
        message.notification?.title, 
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['title']);

    });    
  }

  Future<String> getFCMToken() async {
    String? fcmTokenNullable = await _firebaseMessaging.getToken();
    String fcmToken = "";
    if(fcmTokenNullable == null) {
      fcmToken = "Cannot get token.";
    } else {
      fcmToken = fcmTokenNullable;
    }
    return fcmToken;
  }


}

  