import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logistics_app/utils/sp_utils.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _FireBaseMeesaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _FireBaseMeesaging.requestPermission();
    final fCMToken = await _FireBaseMeesaging.getToken();
    // 储存token
    SpUtils.saveString('fCMToken', fCMToken!);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
