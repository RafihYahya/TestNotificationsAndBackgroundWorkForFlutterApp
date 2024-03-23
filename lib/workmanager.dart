import 'package:testing_notif/notif_init.dart';
import 'package:workmanager/workmanager.dart';



class WorkManager {
  static void startWorkManager() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerPeriodicTask("task-identifier", "simpleTask",
        existingWorkPolicy: ExistingWorkPolicy.replace,
        frequency: const Duration(seconds: 15));
  }

  @pragma(
      'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
  static void callbackDispatcher() async {
    Workmanager().executeTask((task, inputData) async {
      if (LocalNotifications.flutterNotificationPlugin == null) {
       LocalNotifications.initialize();
    }
      try {
      } catch (e) {
        print('miaw');
      }
      //simpleTask will be emitted here.
      return Future.value(true);
    });
  }
}
