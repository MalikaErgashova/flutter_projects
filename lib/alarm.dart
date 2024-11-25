/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_module_1/widgets/deleteReminder.dart';
import 'package:flutter_module_1/widgets/switcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module_1/services/notification_logic.dart';
import 'package:flutter_module_1/widgets/add_reminder.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class ScreenAlarm extends StatefulWidget {
  const ScreenAlarm({super.key});

  @override
  State<ScreenAlarm> createState() => _ScreenAlarmState();
}

class _ScreenAlarmState extends State<ScreenAlarm> {
  User? user;
  bool on =false;

   @override
   void initState() {
    // TODO: implement initState
    super.initState();
    user =FirebaseAuth.instance.currentUser;
    //NotificationLogic.init(context, user!.uid);
    //listenNotifications();
    if (user != null) {
    NotificationLogic.init(context, user!.uid);
    listenNotifications();
  } else {
    // Handle the case when the user is not logged in
    // For example, you could show a login screen or error message
    print("User is not logged in.");
  }
  }
 
 void listenNotifications(){
  NotificationLogic.onNotifications.listen((value){

  });
 }
 void onClickedNotifications(String? payLoad){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ScreenAlarm()));

 }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
         floatingActionButton: FloatingActionButton(onPressed: ()async{
          addReminder(context);//addReminder(context, user!.uid); previous
         },
         shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
         ),
         child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: Colors.accents,begin: Alignment.centerLeft,end: Alignment.centerRight),
            borderRadius:  BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(0, 2)
              )
            ]
          ),
          child: Center(child: Icon(Icons.add,color: Colors.white,size: 30,)),
         ),
         ),
         body: StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(), builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
              ),
            );
          }

          if(snapshot.data!.docs.isEmpty){
            return Center(child: Text("Nothing to show!!!",style: TextStyle(fontSize: 30),),);
          }
          final data =snapshot.data;
          return ListView.builder( itemCount: data?.docs.length,
            itemBuilder: (context, index){

            Timestamp t = data?.docs[index].get('time');// Timestamp t = data!.docs[index].data()?['time'];

            DateTime date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);

            String formattedTime = DateFormat.jm().format(date);  // format qilish dart bo'yicha
           
          on = data!.docs[index].get('onOff');
          if(on){
            NotificationLogic.showNotifications(dateTime: date,id: 0,title: "Reminder title",body: "Be quick!!!");
          }
return SingleChildScrollView(child: Column(children: [
  
  Padding(padding: EdgeInsets.all(8),child: Card(child: ListTile(
    title: Text(formattedTime,style: TextStyle(fontSize: 30),),subtitle: Text("Every morning"),
    trailing: Container(width: 110,child: Row(children: [
      Switcher(onOff: on, timestamp: data.docs[index].get('time'), id: data.docs[index].id),
      IconButton(onPressed: (){
        deleteReminder(context, data.docs[index].id);
      }, icon: FaIcon(FontAwesomeIcons.circleXmark)),
      
      ],),),
  ),),),
],),);

          },
         );


         }),
      ),
    );
  }
}*/

//hammasini userlarsiz ko'rib chiq!!!


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_module_1/widgets/add_reminder.dart';
import 'package:flutter_module_1/widgets/deleteReminder.dart';
import 'package:flutter_module_1/widgets/switcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // **Import the flutter_local_notifications package**
import 'package:flutter_module_1/services/notification_logic.dart'; // Assuming NotificationLogic exists
//import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';


class ScreenAlarm extends StatefulWidget {
  const ScreenAlarm({super.key});

  @override
  State<ScreenAlarm> createState() => _ScreenAlarmState();
}

class _ScreenAlarmState extends State<ScreenAlarm> {
  User? user;
  bool on = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); // **Declare the local notifications plugin**

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    // Initialize Firebase notification logic
    if (user != null) {
      NotificationLogic.init(context, user!.uid);
      listenNotifications();
    } else {
      print("User is not logged in.");
    }

    // **Initialize local notifications**
    _initializeLocalNotifications();
    requestExactAlarmPermission();
  }

  // **Initialize the local notifications plugin**
  void _initializeLocalNotifications() async {

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Replace with your app icon

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to request the 'SCHEDULE_EXACT_ALARM' permission
Future<void> requestExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.request();
  if (status.isGranted) {
    print("Exact alarm permission granted.");
  } else {
    print("Exact alarm permission denied.");
  }
}

  // **Function to schedule a notification at the specified time**
  Future<void> scheduleNotification(DateTime scheduledTime) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    // **Scheduling the notification**
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Reminder Title',
      'Reminder Body',
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformDetails,
     // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time, androidScheduleMode: AndroidScheduleMode.exact, // Repeat every day at the same time
    );
  }

  // Listen for notifications when the app is running in the foreground
  void listenNotifications() {
    NotificationLogic.onNotifications.listen((String? payload) {
      if (payload != null) {
        // Handle notification click action
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScreenAlarm()));
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addReminder(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: Colors.accents,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Nothing to show!!!",
                style: TextStyle(fontSize: 30),
              ),
            );
          }

          final data = snapshot.data;

          return ListView.builder(
            itemCount: data?.docs.length,
            itemBuilder: (context, index) {
              Timestamp t = data?.docs[index].get('time');
              DateTime date = DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
              String formattedTime = DateFormat.jm().format(date);

              on = data!.docs[index].get('onOff');

              // **If the reminder is on, schedule the notification**
              if (on) {
                scheduleNotification(date);
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            formattedTime,
                            style: TextStyle(fontSize: 30),
                          ),
                          subtitle: Text("Every day"),
                          trailing: Container(
                            width: 110,
                            child: Row(
                              children: [
                                Switcher(
                                  onOff: on,
                                  timestamp: data.docs[index].get('time'),
                                  id: data.docs[index].id,
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteReminder(context, data.docs[index].id);
                                  },
                                  icon: FaIcon(FontAwesomeIcons.circleXmark),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}





















// only exapmle from cahtgpt
// final FirebaseAuth _auth =FirebaseAuth.instance;
  //CollectionReference _users= FirebaseFirestore.instance.collection("users");

  // Function to add a user document with fields
  /*Future<void> addUserToFirestore() async {  // that was only try
    try {
      // Create a new document in the 'users' collection with fields
      await _users.add({
        'name': 'John Doe',           // Field 1
        'email': 'johndoe@example.com', // Field 2
        'age': 30,                    // Field 3
        'isActive': true,             // Field 4 (boolean)
        'createdAt': FieldValue.serverTimestamp(), // Field 5 (timestamp)
      });

      print("User added to Firestore");
    } catch (e) {
      print("Error adding user: $e");
    }
  }*/
    // body: ElevatedButton(onPressed: addUserToFirestore, child: Icon(Icons.add)), //that was for future function above
//also this line of code




//that was earlier
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Initialize settings for Android and iOS
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  //final IOSInitializationSettings iosInitializationSettings =
  //    IOSInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
   // iOS: iosInitializationSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(ScreenAlarm(flutterLocalNotificationsPlugin));
}
class ScreenAlarm extends StatelessWidget {
  //const ScreenAlarm(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, {super.key});
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  ScreenAlarm(this.flutterLocalNotificationsPlugin);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;  // Import the timezone package
import 'package:timezone/timezone.dart' as tz; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      // Initialize timezone data
  tz.initializeTimeZones();

  // Set the default timezone (e.g., Local timezone)
  tz.setLocalLocation(tz.getLocation('Uzbekistan/Tashkent'));  

  // Initialize settings for Android and iOS
  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
 // final IOSInitializationSettings iosInitializationSettings =
     // IOSInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
   // iOS: iosInitializationSettings,
  );
  
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp(flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MyApp(this.flutterLocalNotificationsPlugin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: AlarmScreen(flutterLocalNotificationsPlugin),
    );
  }
}
class AlarmScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AlarmScreen(this.flutterLocalNotificationsPlugin);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  TextEditingController _timeController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Alarm'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Enter Time (HH:MM)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                _selectTime(context);
              },
              child: Text('Select Time'),
            ),
            ElevatedButton(
              onPressed: () {
                _setAlarm();
              },
              child: Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
  void _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
      _timeController.text = _selectedTime!.format(context);
    }
  }

  void _setAlarm() async {
    if (_selectedTime == null) return;

    final scheduledTime = DateTime.now().add(
      Duration(
        hours: _selectedTime!.hour - DateTime.now().hour,
        minutes: _selectedTime!.minute - DateTime.now().minute,
      ),
    );

    // Show notification
    await _showNotificationAtTime(scheduledTime);
  }

  Future<void> _showNotificationAtTime(DateTime time) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    /*await widget.flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm',
      'Your alarm time has arrived!',
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails notificationDetails,{
     // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,}
    );*/
  }
  
}*/
/*
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

class ScreenAlarm extends StatefulWidget {
  const ScreenAlarm({super.key});

  @override
  State<ScreenAlarm> createState() => _ScreenAlarmState();
}

class _ScreenAlarmState extends State<ScreenAlarm> {
  TextEditingController hourC= TextEditingController();
  TextEditingController minuteC= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
       Column(
children:<Widget> [
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: 100),
      Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromARGB(255, 209, 224, 235),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: hourC,keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "hour",
              hintStyle: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
              border: InputBorder.none
            ),
            
            ),
          ),
        ),
      ),
      SizedBox(width: 20),
       Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromARGB(255, 209, 224, 235),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: minuteC,keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "minute",
              hintStyle: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
              border: InputBorder.none
            ),
            
            ),
          ),
        ),
      ),

    ],
  ),
  Container(
margin: EdgeInsets.all(25),
child: TextButton(child: Text("Create alarm",style: TextStyle(fontSize: 20,color: Colors.black),),
onPressed: (){
  int hour;
  int minute;
  hour=int.parse(hourC.text);
  minute=int.parse(minuteC.text);
  //create the alarm using Flutter itself
  FlutterAlarmClock.createAlarm(hour: hour, minutes: minute,title: "For test");
},),
  ),
  ElevatedButton(onPressed: (){
    //show Alarms
    FlutterAlarmClock.showAlarms();
  }, child: Text("Show alarms",style: TextStyle(fontSize: 20,color: Colors.black),)
  ),
  Container(
    margin: EdgeInsets.all(25),
    child: TextButton(child: Text(
                  'Create timer',
                  style: TextStyle(fontSize: 20.0,color: Colors.black),
                ),
                onPressed: (){
                  int? minutes=int.parse(minuteC.text);
                  if(minutes != null){
                    FlutterAlarmClock.createTimer(length: minutes);
                    showDialog(context: context, builder: (context){
return AlertDialog(
  content: Center(child: Text(
    "Timer is set",
    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
  ),),
);
                    });
                  }
                  else{
                    showErrorDialog(context,"Please,enter valid values!");
                  }
                },
                ),
  ),
  ElevatedButton(onPressed: (){
    //show timers
    FlutterAlarmClock.showTimers();
  }, child: Text("Show timers",style: TextStyle(fontSize: 20,color: Colors.black),))
  
],
      )
      ),
    /*  floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),*/
    );
  }
   showErrorDialog(BuildContext context,String massage){
showDialog(context: context, builder: (context){
 return AlertDialog(content: Text(massage),);
});
    }
}
////work for alarm !!!!!!!!!!!!
*/