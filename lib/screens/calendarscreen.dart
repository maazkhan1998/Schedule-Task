import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newui/model/task.dart';
import 'package:newui/screens/timepage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController calendarController = CalendarController();
  Duration initialtimer = new Duration();
  showAlertDialog(BuildContext context) {
    // show the dialog
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoTimerPicker(
          backgroundColor: Colors.white,
          mode: CupertinoTimerPickerMode.hms,
          minuteInterval: 1,
          secondInterval: 1,
          initialTimerDuration: initialtimer,
          onTimerDurationChanged: (Duration changedtimer) {
            setState(() {
              initialtimer = changedtimer;
            });
          },
        );
      },
    );
  }

  showTextField(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Save"),
      onPressed: () {
        //   Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // content: Text("Link has been sent to your Email Account"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Add Task name"),
          )
        ],
      ),
      actions: [okButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
                  child: Column(
            //    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableCalendar(
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
                    Watch(),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: InkWell(
                          onTap: () {
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
                      percent: .40,
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
                itemBuilder: (context, i) => HomeWorkTile(Task()),
                itemCount: 8,
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
              ),
              GestureDetector(
                onTap: () => showTextField(context),
                child: Container(
                  margin: EdgeInsets.all(6),
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
  @override
  _WatchState createState() => _WatchState();
}

class _WatchState extends State<Watch> {

  @override
  Widget build(BuildContext context) {
    return Text(
      '20 : 14 : 30',
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(50)),
    );
  }
}
