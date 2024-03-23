import 'package:testing_notif/notif_init.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('Socima');
      LocalNotifications.displayNotifs(10, 'Worker Borker');
      print('SocimaWork');
      return Future.value(true);
    } catch (e) {
      print('miaw');
      return Future.value(true);
    }
    //simpleTask will be emitted here.
  });
}

class WorkManager {
  static void startWorkManager() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().registerPeriodicTask("SendReminder", "simpleTask",
        existingWorkPolicy: ExistingWorkPolicy.replace,
        frequency: const Duration(minutes: 15));
  }
}
