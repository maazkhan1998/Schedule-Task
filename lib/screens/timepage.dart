import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:intl/intl.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:newui/screens/stopwatch.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class TimePage extends StatefulWidget {
  @override
  _TimePageState createState() => _TimePageState();
}



class _TimePageState extends State<TimePage> {
  TextEditingController controller=TextEditingController();
  showTextField(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Save"),
      onPressed: () {
        try{
        if(controller.text.isEmpty) print('Enter task name');
        else{
          Provider.of<TodayProvider>(context,listen:false).addTask(controller.text);
          Navigator.of(context,rootNavigator: true).pop();
        }
        }catch(e){
          print(e);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // content: Text("Link has been sent to your Email Account"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
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

  onTaskUpdate(String id,int val,String name)async{
    try{
     await Provider.of<TodayProvider>(context,listen:false).updateTask(id, val, name);
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
            new SizedBox(
              height: ScreenUtil().setHeight(70),
              width: ScreenUtil().screenWidth / 1.6,
              child: RaisedButton(
                  color: Color(0xff5f77f4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onPressed: () {},
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
                child: HomeWorkTile(todayData.todayTask[i].isDone)),
              itemCount: todayData.todayTask.length,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
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
    );
  }
}

class HomeWorkTile extends StatefulWidget {

  final int isDone;

  HomeWorkTile(this.isDone);
  @override
  _HomeWorkTileState createState() => _HomeWorkTileState();
}

class _HomeWorkTileState extends State<HomeWorkTile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: Color(0xff7654f6),
          ),
        ),
        child: Row(children: [
          Container(
            height: ScreenUtil().setHeight(40),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isDone == 1 ? Color(0xff7654f6) : Colors.white,
              border: Border.all(
                color: Color(0xff7654f6),
              ),
            ),
            child: Icon(
              Icons.check,
              size: 20.0,
              color: Colors.white,
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(40)),
          Text(
            "Homework",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(29)),
          ),
        ]),
      ),
    );
  }
}
