import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


void displayNotifs(int id, NotificationDetails notifs) async {
  await flutterLocalNotificationsPlugin.show(
      id, 'Random Num', id.toString(), notifs);
}