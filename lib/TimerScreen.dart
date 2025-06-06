import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget{
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  int seconds = 0,minutes = 0,hours = 0;
  String digitSeconds = "00",digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  void stop(){
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset(){
    timer!.cancel();
    setState(() {

      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
    });
  }

  void addLaps(){
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  void start(){
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localseconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;


      if(localseconds > 59){
        if(localMinutes > 59){
          localHours++;
          localMinutes = 0;
        }
        else{
          localMinutes++;
          localseconds = 0;
        }
      }
      setState(() {
        seconds = localseconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ?"$seconds":"0$seconds";
        digitHours = (seconds >= 10) ?"$hours":"0$hours";
        digitMinutes = (seconds >= 10) ?"$minutes":"0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text("$digitHours:$digitMinutes:$digitSeconds",style: TextStyle(
                    color: Colors.white,
                    fontSize: 82,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: ListView.builder(
                      itemCount: laps.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Lap n°${index+1}",style: TextStyle(color: Colors.white,fontSize: 16)),
                              Text("${laps[index]}",style: TextStyle(color: Colors.white,fontSize: 16)),
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RawMaterialButton(
                      onPressed: (){
                        (!started) ? start() : stop();
                      },



                      shape: StadiumBorder(side: BorderSide(color: Colors.blue),
                      ),
                      child: Text(
                        (!started) ? "Start":"Pause",style: TextStyle(color: Colors.white),
                      ),
                    ),),
                    SizedBox(width: 8),
                    IconButton(color: Colors.white,onPressed: (){addLaps();}, icon: Icon(Icons.flag)),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: (){
                          reset();
                        },
                        fillColor: Colors.blue,
                        shape: StadiumBorder(side: BorderSide(color: Colors.blue),
                        ),
                        child: Text(
                          "Reset",style: TextStyle(color: Colors.white),
                        ),
                      ),)
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }
}