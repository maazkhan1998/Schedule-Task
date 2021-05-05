import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:newui/dialogs/dialogs.dart';

import 'package:newui/provider/todayProvider.dart';
import 'package:newui/screens/TimerPageTaskScreen.dart';
import 'package:newui/screens/stopwatch.dart';
import 'package:newui/utility.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TimePage extends StatefulWidget {
  @override
  _TimePageState createState() => _TimePageState();
}



class _TimePageState extends State<TimePage> {
  
  initState(){
    Timer.periodic(Duration(seconds:3), (timer) { 
      setState((){});
    });
    super.initState();
  }

  dispose(){
    super.dispose();
  }
  

  onTaskUpdate(String id,int val,String name)async{
    try{
     await Provider.of<TodayProvider>(context,listen:false).updateTask(id, val, name,formateDate(DateTime.now()));
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayData=Provider.of<TodayProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: Text(
          "Timer",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat('yyyy /MM/ dd').format(DateTime.now()),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: ScreenUtil().setSp(40),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            StopwatchPage(),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Text(
              "Today Todo",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(30)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0, bottom: 20),
                  child: LinearPercentIndicator(
                    width: ScreenUtil().screenWidth * .7,
                    lineHeight: 10.0,
                    percent: todayData.completedTask,
                    //  percent:( Methods.leftspace(usedstorage,storagelimit )*100)/totalamount,
                    backgroundColor: Colors.grey[300],
                    progressColor: Color(0xff7654f6),
                  ),
                ),
              ],
            ),
            ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: ()=>onTaskUpdate(todayData.todayTask[i].id,todayData.todayTask[i].isDone,todayData.todayTask[i].name),
                child: TimerPageTaskScreen(todayData.todayTask[i])),
              itemCount: todayData.todayTask.length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
            GestureDetector(
              onTap: () => Dialogs.shared.showTextFieldTimerPage(context,),
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
    );
  }
}


