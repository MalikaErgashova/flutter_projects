import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module_1/firebase_options.dart';
import 'alarm.dart';
import 'clock.dart';
import 'timer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp( MyApp());
  tz.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  //instance of firebase auth final FirebaseAuth _aa = FirebaseAuth.instance;
  final FirebaseAuth _auth =FirebaseAuth.instance;
   //MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selIndex = 0;

  ///issue was in there because _selIndex was inside of build method;selIndex: Moved it outside of the build method so its value persists.
  //_screens: Defined as a member variable of _HomePageState.
  //Casting: Used as String and as Widget for better type safety.
  @override
  Widget build(BuildContext context) {
    //<Map<String, Object>>
    //type casting
    final List _screens = [
      {"screen": ScreenAlarm(), "title": "Uyg'otkich"},
      {"screen": ScreenClock(), "title": "Soat"},
      {"screen": ScreenTimer(), "title": "Sekundomer&Taymer"},
    ];
    void _selectScreen(int index) {
      setState(() {
        _selIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screens[_selIndex]["title"],
        ),
      ),
      body: _screens[_selIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selIndex,
        onTap: _selectScreen,
        selectedItemColor: Colors.blue,//Colors.black87 was earlier like that
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.alarm), label: "Uyg'otgich "),
          BottomNavigationBarItem(
              icon: Icon(Icons.watch_later_outlined), label: "Soat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined), label: "Sekundomer&Taymer "),
        ],
      ),
    );
  }
}
