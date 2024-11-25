import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_module_1/alarm.dart';
import 'package:rxdart/rxdart.dart';// for 2nd var final
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic {
static final _notifications = FlutterLocalNotificationsPlugin();
static final onNotifications = BehaviorSubject<String?>();

static Future _notificationsDetails()async{
return NotificationDetails(
  android: AndroidNotificationDetails(
    'Schedule reminder', "This is your alarm!", importance:Importance.max,
    priority: Priority.max,
    
    ),
 
);
}

static Future init(BuildContext context,String uid)async{
  tz.initializeTimeZones();
  final android = AndroidInitializationSettings("time_workout");
  final settings= InitializationSettings(android: android);
  await _notifications.initialize(settings,
  onDidReceiveBackgroundNotificationResponse: (payLoad){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ScreenAlarm()
    ), );

    onNotifications.add(payLoad as String?);
  }
  );
}

static Future showNotifications({
  int id =0,
  String? title,
  String?  body,
  String? payLoad,
  required DateTime dateTime,
}) async{
  if(dateTime.isBefore(DateTime.now())){
    dateTime =dateTime.add(Duration(days: 1));
  }

  _notifications.zonedSchedule(id, title, body, tz.TZDateTime.from(dateTime, tz.local), await _notificationsDetails(), uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,matchDateTimeComponents: DateTimeComponents.time, androidScheduleMode: AndroidScheduleMode.exact);
}
}