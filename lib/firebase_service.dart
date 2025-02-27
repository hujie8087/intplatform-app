import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logistics_app/constants.dart';
import 'package:logistics_app/utils/sp_utils.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("后台通知");
  print("Handling a background message: ${message.messageId}");
  print("title: ${message.notification?.title}");
  print("body: ${message.notification?.body}");
  print("payload: ${message.data}");
  print('Handling a background message: ${message.messageId}');
  // updateAndroidBadge(5);
  await Firebase.initializeApp();
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const _chanelName = "iwip.intplatform.notification";
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  Future<void> notifyInit() async {
    final InitializationSettings initSetting = InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(
      initSetting,
    );
  }

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
    } catch (e) {
      print("请求通知权限失败: $e");
    }
    try {
      await _firebaseMessaging.subscribeToTopic("notification");
    } catch (e) {
      print("订阅通知失败: $e");
    }
    // 获取Firebase Cloud 消息传递令牌
    try {
      final fCMToken = await _firebaseMessaging.getToken();
      print("fCMToken: $fCMToken");
      SpUtils.saveString(Constants.SP_DEVICE_TOKEN, fCMToken ?? '');
    } catch (e) {
      print("获取Firebase Cloud 消息传递令牌失败: $e");
    }
    // 后台运行通知回调
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // 前台运行通知监听
    FirebaseMessaging.onMessage.listen(handleMessage);
    // 监听 后台运行时通过系统信息条打开应用
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
    // 如需在每次令牌更新时获得通知
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.

      // 每当生成新令牌时，都会触发此回调。
    }).onError((err) {
      // Error getting token.
    });
  }

  void onMessageOpenedApp(RemoteMessage message) {
    print("打开通知");
    print("Handling a background message: ${message.messageId}");
    print("title: ${message.notification?.title}");
    print("body: ${message.notification?.body}");
    print("payload: ${message.data}");
  }

  void handleMessage(RemoteMessage? message) {
    // 如果消息不是空的话
    if (message == null) return;
    // 用户点击通知， 进入特定该页面
    // Get.toNamed("/home", arguments: message);
    print("前台通知");
    print("title: ${message.notification?.title}");
    print("body: ${message.notification?.body}");
    print("payload: ${message.data}");
    _notifyShow(0, message.notification?.title ?? '',
        message.notification?.body ?? '', message.data['payload'] ?? '');
  }

  Future<void> _notifyShow(
      int id, String title, String content, String payload) async {
    // const chanel = "me.liucx.demoNotification"; //channel name
    print(
        'id:${id},string:${title},content:${content},_chanelName:${_chanelName}');
    try {
      await flutterLocalNotificationsPlugin.show(
          id,
          title,
          content,
          const NotificationDetails(
              android: AndroidNotificationDetails(_chanelName, _chanelName),
              iOS: DarwinNotificationDetails(
                threadIdentifier: _chanelName,
              )),
          payload: payload);
    } catch (e) {
      print(e);
    }
  }
}
