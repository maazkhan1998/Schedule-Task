import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newui/dialogs/dialogs.dart';
import 'package:newui/provider/calendarProvider.dart';
import 'package:newui/screens/calendarPageTaskScreen.dart';
import 'package:newui/utility.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime calendarCurrentDate=DateTime.now();

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>  {

  CalendarController calendarController;
  Duration initialtimer = new Duration();
  Random random = new Random();

  initState(){
    calendarController = CalendarController();
    Timer.periodic(Duration(milliseconds: 800), (timer) async{ 
      await Provider.of<CalendarProvider>(context,listen:false).getAllTimer();
    });
    super.initState();
  }
  showAlertDialog(BuildContext context) {
    // show the dialog
    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoTimerPicker(
          backgroundColor: Colors.white,
          mode: CupertinoTimerPickerMode.hms,
          minuteInterval: 1,
          secondInterval: 1,
          initialTimerDuration: initialtimer,
          onTimerDurationChanged: (Duration changedtimer) async{
            try{
            await Provider.of<CalendarProvider>(context,listen:false).updateTimer(formateDate(calendarCurrentDate), changedtimer.inMilliseconds);
            }
            catch(e){
              Utility.shared.showToast(e.toString());
            }
          },
        );
      },
    );
  }

  changeDate(DateTime date,List<dynamic> list,List<dynamic> secondList)=>setState(()=>calendarCurrentDate=date);

  @override
  Widget build(BuildContext context) {
    final calendarData=Provider.of<CalendarProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
                  child: Column(
            //    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableCalendar(
                calendarStyle: CalendarStyle(
                  markersAlignment: Alignment.bottomRight
                ),
                builders: CalendarBuilders(
                  markersBuilder: (context,date,event,_){
                    List<Widget> marker=[];
                    marker.add(Container(
                      alignment: Alignment.center,
                      height: 30,width: 30,
                      color: Utility.shared.color[random.nextInt(5)],
                      child: Text(event.length.toString(),style: TextStyle(
                        color: Colors.red
                      ),),
                    ));
                    return marker;
                  }
                ),
                onDaySelected: changeDate,
                events:calendarData.events() ,
                initialSelectedDay: DateTime.now(),
                calendarController: calendarController,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Container(
                height: ScreenUtil().setHeight(80),
                width: ScreenUtil().screenWidth / 1.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 3,
                      offset: Offset(2, 8), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(40),
                  //  border: Border.all(color: Color(0xff5f77f4)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                        color: Color(0xff5f77f4),
                      ),
                      child: Text(
                        "Study\n Time",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    Watch(calendarData.selectedDateTime(formateDate(calendarCurrentDate)).time),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: InkWell(
                          onTap: () {
                            if(formateDate(calendarCurrentDate)==formateDate(DateTime.now())) return Utility.shared.showToast('Cannot edit today timer');
                            showAlertDialog(context);
                          },
                          child: Icon(Icons.edit, color: Color(0xff5f77f4))),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                    child: LinearPercentIndicator(
                      width: ScreenUtil().screenWidth * .7,
                      lineHeight: 10.0,
                      percent: calendarData.selectedDateProgress(formateDate(calendarCurrentDate)),
                      backgroundColor: Colors.grey[300],
                      progressColor: Color(0xff7654f6),
                    ),
                  ),
                ],
              ),
               SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(20)),
                itemBuilder: (context, i) => 
                GestureDetector
                (
                  onTap: ()async{
                    if(formateDate(calendarCurrentDate)==formateDate(DateTime.now())) return Utility.shared.showToast('Cannot modify today tasks');
                    try{
                     await Provider.of<CalendarProvider>(context,listen:false).
                     updateTask(calendarData.selectedDateTask(formateDate(calendarCurrentDate))[i].date,
                      calendarData.selectedDateTask(formateDate(calendarCurrentDate))[i].id, 
                      calendarData.selectedDateTask(formateDate(calendarCurrentDate))[i].isDone,
                       calendarData.selectedDateTask(formateDate(calendarCurrentDate))[i].name);
                    }catch(e){
                      Utility.shared.showToast(e.toString());
                    }
                  },
                  child: 
                  CalendarPageTaskScreen(calendarData.selectedDateTask(formateDate(calendarCurrentDate))[i])),
                itemCount: calendarData.selectedDateTask(formateDate(calendarCurrentDate)).length,
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
              ),
              GestureDetector(
                onTap: () {
                  if(formateDate(calendarCurrentDate)==formateDate(DateTime.now())) return Utility.shared.showToast('Cannot modify today tasks');
                   Dialogs.shared.showTextFieldCalendarPage(context,calendarCurrentDate);
                   },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical:ScreenUtil().setHeight(6),horizontal: ScreenUtil().setWidth(40)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff7654f6),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  height: ScreenUtil().setHeight(60),
                  child: Icon(Icons.add, size: 30, color: Colors.white),
                ),
              ),
                SizedBox(height: ScreenUtil().setHeight(100)),
            ],
          ),
        ),
      ),
    );
  }
}

class Watch extends StatefulWidget {

  final double time;

  Watch(this.time);
  @override
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch> {

  @override
  Widget build(BuildContext context) {
    return Text(
      Utility.shared.formatTime(widget.time.toInt()),
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(50)),
    );
  }
}
