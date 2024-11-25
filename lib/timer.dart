
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class ScreenTimer extends StatefulWidget {
  const ScreenTimer({super.key});

  @override
  State<ScreenTimer> createState() => _ScreenAlarmState();
}

class _ScreenAlarmState extends State<ScreenTimer> {
   late Stopwatch stopwatch;
    late Timer t;
    bool running=false;

    void stopwatchOption(){
      if(stopwatch.isRunning) {
      stopwatch.stop();
      setState(() {
        running=false;
      });
    }
    else{
      stopwatch.start();
      setState(() {
        running=true;
      });
    }
    }

    void stopwatchRetart(){
      if(!stopwatch.isRunning) {
      stopwatch.reset();
    }
    }

     String returnFormattedText() {
    var milli = stopwatch.elapsed.inMilliseconds;
 
    String milliseconds = (milli % 100).toString().padLeft(2, "0"); // this one for the miliseconds
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0"); // this is for the second
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0"); // this is for the minute
    String hours = (((milli ~/ 1000) ~/ 60)%60).toString().padLeft(2, "0"); // this is for the minute
 
    return "$hours:$minutes:$seconds.$milliseconds";
  }

   @override
  void initState() {
    super.initState();
     t = Timer.periodic(Duration(milliseconds: 30), (timer) {
     if (!mounted) return;//there was error with tree with memory leak 
     /* Exception has occurred.
FlutterError (setState() called after dispose(): _ScreenAlarmState#05ff4(lifecycle state: defunct, not mounted)
This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().)*/
      setState(() {
      
      });

    });
    stopwatch = Stopwatch();
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(returnFormattedText(),style: TextStyle(color: Colors.black,
                    fontSize: 55,
                    fontWeight: FontWeight.bold,),),
            SizedBox(height: 200,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ //we can also use cupertino button
              MaterialButton(onPressed: stopwatchRetart,child: Icon(Icons.restart_alt,size: 50,color: Colors.blue,) ,shape:  RoundedRectangleBorder(borderRadius:BorderRadius.circular(52.0) )),
                MaterialButton(onPressed: stopwatchOption,child: running? Icon(Icons.pause,size: 50,color: Colors.blue,):Icon(Icons.stop,size: 50,color: Colors.blue,),shape:  RoundedRectangleBorder(borderRadius:BorderRadius.circular(52.0) ), ),
                
            ],)
          ],
        ),
      
    );
  }
}
