import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testing_notif/notif_init.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task");
    const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('105', 'MiawMiaw',
            importance: Importance.max, priority: Priority.max));
    displayNotifs(105, notificationDetails); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

void startWorkManager() {
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask("task-identifier", "simpleTask",
      frequency: const Duration(minutes: 15));
}
