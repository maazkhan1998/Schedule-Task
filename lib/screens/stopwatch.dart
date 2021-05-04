import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utility.dart';
import 'package:timezone/timezone.dart' as tz; 

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Stopwatch _stopwatch;
  Timer _timer;
  Duration initialtimer = new Duration();


  showAlertDialog(BuildContext context) async{
    if(_stopwatch.isRunning) return print('Stop timer to edit');
   return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoTimerPicker(
            backgroundColor: Colors.white,
             mode: CupertinoTimerPickerMode.hms,
              minuteInterval: 1,
              secondInterval: 1,
              initialTimerDuration: initialtimer,
              onTimerDurationChanged: (Duration changedtimer) async{
                 await Provider.of<TodayProvider>(context,listen:false).setCustomTimer(changedtimer.inMilliseconds);
                 _stopwatch.reset();
              },
          );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> handleStartStop()async {
    try{
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
     await Provider.of<TodayProvider>(context,listen:false).pauseTimer(_stopwatch.elapsedMilliseconds);
     _stopwatch.reset();
    } else {
      _stopwatch.start();
    }

    setState(() {});
    }catch(e){
      print(e);
    }
  }

  _resetTime()async{
    try{
    _stopwatch.reset();
    await Provider.of<TodayProvider>(context,listen:false).resetTimer();
    }
    catch(e){
      print(e);
    }
  }

  onBreakTime()async{
    print('Running');
    try{
      if(_stopwatch.isRunning) await handleStartStop();
        await flutterLocalNotificationsPlugin.zonedSchedule
        (0, 'Get Back to work', 'Break Time is over get back to work',
         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
          const NotificationDetails(
        android: AndroidNotificationDetails('0',
            '0', 'your channel',playSound: true,importance: Importance.max,priority: Priority.high,visibility: NotificationVisibility.public,
            enableLights: true,enableVibration: true,
            )),
             uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, androidAllowWhileIdle: true); 
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayData=Provider.of<TodayProvider>(context);
    return Column(
      //  mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth / 2.9,
            ),
            Text(
              "STUDY TIMER",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(27),
              ),
            ),
            Spacer(),
            // SizedBox(
            //   height: ScreenUtil().setWidth(70),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 38.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: _resetTime,
                    child: Container(
                        // color: Colors.grey,
                        height: ScreenUtil().setHeight(30),
                        width: ScreenUtil().setWidth(30),
                        child: Image.asset('assets/reset1.png')),
                  ),
                  Text(
                    "Reset",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(30),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                height: ScreenUtil().setHeight(200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(70),
                  //   border: Border.all(color: Colors.grey[400]),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Utility.shared.formatTime(_stopwatch.elapsedMilliseconds+todayData.todayTimer.time.toInt()),
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(60),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      _stopwatch.isRunning
                          ? InkWell(
                              onTap: handleStartStop,
                              child: FaIcon(FontAwesomeIcons.pause))
                          : InkWell(
                              onTap: handleStartStop,
                              child: FaIcon(FontAwesomeIcons.play)),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: ScreenUtil().setHeight(50),
                  right: 15,
                  child: InkWell(
                      onTap: ()=>
                        showAlertDialog(context)
                      ,
                      child: Icon(Icons.edit, color: Color(0xff5f77f4))))
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(50)),
         GestureDetector(
           onTap: onBreakTime,
                    child: SizedBox(
                height: ScreenUtil().setHeight(70),
                width: ScreenUtil().screenWidth / 1.6,
                child: RaisedButton(
                    color: Color(0xff5f77f4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed:null,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Start Break Time",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(33)),
                      ),
                    )),
              ),
         )
      ],
    );
  }
}
