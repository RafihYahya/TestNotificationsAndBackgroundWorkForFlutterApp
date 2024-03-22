import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:testing_notif/notif_init.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
  
}

void displayNotifs( int id,NotificationDetails notifs) async {
  await flutterLocalNotificationsPlugin.show(id, 'Random Num', id.toString(), notifs);
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Required for Android platform specific initialization
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask("task-identifier", "simpleTask");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var myNumber = <int>[];

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
    streamFunAsync().listen((event) async {
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(event.toString(), 'channelName',
              importance: Importance.max, priority: Priority.max));
      displayNotifs(event,notificationDetails);
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
