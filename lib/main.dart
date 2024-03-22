import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for Android platform specific initialization

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var myNumber = <int>[];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Stream<int> streamFunAsync() async* {
    while (true) {
      var rand = await http.get(
          Uri.parse('https://www.randomnumberapi.com/api/v1.0/randomnumber'));
      var asnwer = jsonDecode(rand.body);
      yield asnwer[0];
      await Future.delayed(const Duration(seconds: 30));
    }
  }

  @override
  void initState() {
    super.initState();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    streamFunAsync().listen((event) async {
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(event.toString(), 'channelName',
              importance: Importance.max, priority: Priority.max));
      print(event);
      await flutterLocalNotificationsPlugin.show(
          event, 'Random Num', event.toString(), notificationDetails);
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
