import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

deleteReminder(BuildContext context,String id,){//String uid
return showDialog(context: context, builder: (context){
  return AlertDialog(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
  ),
  title: Text("Delete reminder"),
  content: Text("Are you sure to delete? "),
  actions: [
  TextButton(onPressed: (){

try{
  //FirebaseFirestore.instance.collection("reminder").doc(id).delete();// FirebaseFirestore.instance.collection("users").doc(uid).collection("reminder").doc(id).delete();  avvalgisi
  FirebaseFirestore.instance.collection("users").doc(id).delete();
  Fluttertoast.showToast(msg: "Reminder deleted");
}catch(e){
 Fluttertoast.showToast(msg: e.toString());
}

    Navigator.pop(context);
  }, child: Text("Delete")
  ),
  TextButton(onPressed: (){
    Navigator.pop(context);
  }, child: Text("Cancel"),
  ),
  ],);
});
}