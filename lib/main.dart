import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testing_notif/notif_init.dart';
import 'package:testing_notif/stream.dart';
import 'package:testing_notif/workmanager.dart';



void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for Android platform specific initialization
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  startWorkManager();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var myNumber = <int>[];

 

  @override
  void initState() {
    super.initState();
    streamFunAsync().listen((event) async {
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(event.toString(), 'channelName',
              importance: Importance.max, priority: Priority.max));
      displayNotifs(event, notificationDetails);
      setState(() {
        myNumber.add(event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: ListView.builder(
              itemCount: myNumber.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(myNumber[index].toString()),
                  ))),
    );
  }
}
