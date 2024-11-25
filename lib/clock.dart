import 'dart:async';
//import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_module_1/country.dart';
//import 'package:http/http.dart';
//import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
//import 'main.dart';

class ScreenClock extends StatefulWidget {
  const ScreenClock({super.key});

  @override
  State<ScreenClock> createState() => _ScreenClockState();
}

class _ScreenClockState extends State<ScreenClock> {
late Timer t;
final count=[];

 @override
  void initState() {
    super.initState();
     t = Timer.periodic(Duration(milliseconds: 30), (timer) {
     if (!mounted) return; 
     
      setState(() {
      });

    });

 
  }

  @override
  Widget build(BuildContext context) {
  //String time=DateTime.now().toString();
  //TextEditingController text= TextEditingController();
  final arab = getLocation("Asia/Riyadh");//index0
final bolgar = getLocation('Europe/Sofia');//index1
final frans = getLocation('Europe/Paris');//index2
final rus = getLocation('Europe/Moscow');//index3
final turk = getLocation('Europe/Istanbul');//index4


final nowDetroit =  TZDateTime.now(arab);
final nowBolgar =  TZDateTime.now(bolgar);
final nowFrans = TZDateTime.now(frans);
final nowRus = TZDateTime.now(rus);
final nowTurk = TZDateTime.now(turk);


  DateTime date= DateTime.now();
  int dateD=date.day;
  int dateM=date.month;
  int dateY=date.year;
  String hour (){
    if(date.hour.toString().length==1){
      return "0${date.hour} ";
    }
    return "${date.hour} ";
  };
  String minute (){
    if(date.minute.toString().length==1){
      return "0${date.minute} ";
    }
    return "${date.minute} ";
  };
  String second (){
    if(date.second.toString().length==1){
      return "0${date.second} ";
    }
    return "${date.second} ";
  };

  ///example of how to get data from API
  /* void getTime() async{
    //make the request
    Response response =await get(Uri.parse('https://www.timeapi.io/api/time/current/zone?timeZone=Asia%2FTashkent'));
    Map data =jsonDecode(response.body);
    print(data);
  }*/
  // this is permission for the data
  /**<uses-permission android:name="android.permission.INTERNET"/> */
  
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(20),
          child: Column(
            children: [
                Container(
                    width: 450,
                    height: 160,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Color.fromARGB(255, 209, 224, 235),),
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0,right:15.0,top:15),

                      child: Column(//It would be better to use MediaQuery or Flexible/Expanded to make the layout responsive to different screen sizes.
                        children: [
                          Text("O'zbekiston",style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Vaqt",style: TextStyle(fontSize: 27),),
                              Text(
                                    "${hour()}: ${minute()}: ${second()}",
                                    style: TextStyle(fontSize: 34),
                                  ),
                                 //  Text(dateR.toString(),style: TextStyle(fontSize: 35),),   
                            ],
                          ),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text("Sana",style: TextStyle(fontSize: 27),),
                               Text(
                                    "${dateD.toString()}/${dateM.toString()}/${dateY.toString()}",
                                    style: TextStyle(fontSize: 34),
                                  ),
                            ],),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
              Expanded(child: ListView.builder(
                itemCount: count.length,
                itemBuilder: ( context,index){
                return Dismissible(//there was an error that- A dismissible widget is stil part of the tree,make shure to implement the on Dismissed handler and to immideately remove from the Application
                  key: Key(count[index]),
                  onDismissed: (direction)async{
                                    setState(() {
                                      count.removeAt(index);
                                    });
                                  }, 
                  background:  Container(
                                  alignment: Alignment.centerLeft,
                                  color: Colors.red,
                                  child: const Icon(Icons.delete),),
                                          //there was also function
                  child: Column(
                    children: [
                      Country(name: count[index], time:index==0?"${nowDetroit.hour} : ${nowDetroit.minute} : ${nowDetroit.second}":index==1?"${nowBolgar.hour} : ${nowBolgar.minute} : ${nowBolgar.second}":index==2?"${nowFrans.hour} : ${nowFrans.minute} : ${nowFrans.second}":index==3?"${nowRus.hour} : ${nowRus.minute} : ${nowRus.second}":index==4?"${nowTurk.hour} : ${nowTurk.minute} : ${nowTurk.second}":"${hour()}: ${minute()}: ${second()}" , date:index==0?"${nowDetroit.day}/${nowDetroit.month}/${nowDetroit.year}":index==1?"${nowBolgar.day}/${nowBolgar.month}/${nowBolgar.year}":index==2?"${nowFrans.day}/${nowFrans.month}/${nowFrans.year}":index==3?"${nowRus.day}/${nowRus.month}/${nowRus.year}":index==4?"${nowTurk.day}/${nowTurk.month}/${nowTurk.year}":"${dateD.toString()}/${dateM.toString()}/${dateY.toString()}" ),
                     //Country(name: count[index], time:"${hour()}: ${minute()}: ${second()}" , date:"${dateD.toString()}/${dateM.toString()}/${dateY.toString()}" ),
                      SizedBox(height: 10,),
            
                    ],
                  ),
                );
              
              }),
              ),
            ],
          )
          ),
          floatingActionButton: FloatingActionButton(onPressed: _showDialog,
          backgroundColor: Colors.white,
          shape: CircleBorder(),
          child: Icon(Icons.add,size: 27,color: Colors.blue,),),
    );
  }
  final count1=["Arabiston","Bolgariya","Fransiya","Rossiya","Turkiya"];
  TextEditingController text= TextEditingController();
  void _showDialog(){
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      shadowColor: Colors.teal[300],
      //icon: Icon(Icons.abc), was only for text
      title: Text("Add country",style: TextStyle(fontSize: 23),),
      actions: [
        Container(height: 250,width: 350,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           TextField(//there should be searchbar,
           controller: text,
            decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                  ),
           ),
           Expanded(child: ListView.builder(itemCount: 5,
            itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                  setState(() {
                    text.text=count1[index];
                  });
              },
              child: ListTile(
                         title: Text(count1[index]),
              ),
            );
           })),
           Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment:CrossAxisAlignment.end,
            children: [
              TextButton(onPressed: (){Navigator.pop(context);
              }, child: Text("Cancel",style: TextStyle(color: Colors.blue,fontSize: 18)),
              style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 198, 209, 216),padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),),
              isSemanticButton: true,
              ),
              SizedBox(width:8,),
              TextButton( isSemanticButton: true,onPressed: (){
                setState(() {
                  count.add(text.text);
                   Navigator.pop(context);
                });
              }, child: Text("Save",style: TextStyle(color: Colors.blue,fontSize: 18),),style: TextButton.styleFrom(backgroundColor: Color.fromARGB(255, 198, 209, 216),padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),),),
            ],
           ),
        ],),),

      ],
    );
  });
}
}
//final work is to fix their time and date using API or any local work

///also add another countries time from maybe searchbar,
///
/////Hozir oddiy qilaman,lekin keyin ApI dan foydalanaib asosiy vazifasi ya'ni directly olishi kk
//Yakunladi😃
//but see it again because there are errors
