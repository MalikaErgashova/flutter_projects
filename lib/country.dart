import 'package:flutter/material.dart';


class Country extends StatefulWidget {
 final String name;
 final String time;
 final String date;
   Country({super.key, required this.name, required this.time, required this.date});

  @override
  State<Country> createState() => _CountryState();
}

class _CountryState extends State<Country> {
  @override
  Widget build(BuildContext context) {
    
    return  Container(
                width: 450,
                height: 160,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(7),color: Color.fromARGB(255, 209, 224, 235),),
                child: Padding(
                  padding: const EdgeInsets.only(left:15.0,right:15.0,top:15),
                  child: Column(
                    children: [
                      Text(widget.name,style: TextStyle(fontSize: 27,fontWeight: FontWeight.bold),),// the reason for widget.name is that it is staful wodget using State ~
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Vaqt",style: TextStyle(fontSize: 27),),
                          Text(
                             widget.time,
                                style: TextStyle(fontSize: 34),
                              ),
                             //  Text(dateR.toString(),style: TextStyle(fontSize: 35),),   
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text("Sana",style: TextStyle(fontSize: 27),),
                           Text(
                                widget.date,
                                style: TextStyle(fontSize: 34),
                              ),
                        ],),
                    ],
                  ),
                ),
              );
  }
}