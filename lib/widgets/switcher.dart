import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_module_1/model/reminder_model.dart";

class Switcher extends StatefulWidget {
 
  bool onOff;
  //String uid;
  Timestamp timestamp;
  String id;
  Switcher({required this.onOff,required this.timestamp,required this.id});

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (bool value){
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.timestamp =widget.timestamp;
        FirebaseFirestore.instance.collection('users').doc(widget.id).update(reminderModel.toMap());
      },
      value: widget.onOff,
    );
  }
}


// that was previous one
/**import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_module_1/model/reminder_model.dart";

class Switcher extends StatefulWidget {
 
  bool onOff;
  String uid;
  Timestamp timestamp;
  String id;
  Switcher({required this.onOff,required this.uid,required this.timestamp,required this.id});

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: (bool value){
        ReminderModel reminderModel = ReminderModel();
        reminderModel.onOff = value;
        reminderModel.timestamp =widget.timestamp;
        FirebaseFirestore.instance.collection('users').doc(widget.uid).collection('reminder').doc(widget.id).update(reminderModel.toMap());
      },
      value: widget.onOff,
    );
  }
} */