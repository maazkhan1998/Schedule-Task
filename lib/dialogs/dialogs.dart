import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newui/provider/calendarProvider.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:provider/provider.dart';

import '../utility.dart';

class Dialogs{

  static var shared=Dialogs();

  deleteTaskDialog(BuildContext context,String id,Function func)async{
    return await showDialog(
      context: context,
      builder: (_)=>SimpleDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color(0xff7654f6),width: 2,
          )
        ),
        title: Center(child: Text('Delete Task')),
        children: [
          Center(child: Text('Are you sure you want to delete this task?')),
          SizedBox(height:ScreenUtil().setHeight(30)),
          Container(
            padding: EdgeInsets.only(right:ScreenUtil().setWidth(10)),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: ()=>Navigator.of(context,rootNavigator: true).pop(),
                  child: Text('Cancel',style: TextStyle(
                    color: Color(0xff7654f6)
                  ),),
                ),
                SizedBox(height:ScreenUtil().setWidth(15)),
                TextButton(
                  onPressed:()=>func(),
                  child: Text('Yes',style:TextStyle(
                    color: Color(0xff7654f6)
                  )),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  showTextFieldTimerPage(BuildContext context) {
    TextEditingController controller=TextEditingController();
    // set up the button
    Widget okButton = TextButton(
      child: Text("Save"),
      onPressed: () {
        try{
        if(controller.text.isEmpty) print('Enter task name');
        else{
          Provider.of<TodayProvider>(context,listen:false).addTask(controller.text,formateDate(DateTime.now()));
          Navigator.of(context,rootNavigator: true).pop();
        }
        }catch(e){
          print(e);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color(0xff5f77f4),width: 2)
      ),
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

  showTextFieldCalendarPage(BuildContext context,DateTime date) {
    TextEditingController controller=TextEditingController();
    // set up the button
    Widget okButton = TextButton(
      child: Text("Save"),
      onPressed: () {
        try{
        if(controller.text.isEmpty) print('Enter task name');
        else{
          Provider.of<CalendarProvider>(context,listen:false).addTask(controller.text,formateDate(date));
          Navigator.of(context,rootNavigator: true).pop();
        }
        }catch(e){
          print(e);
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color(0xff5f77f4),width: 2)
      ),
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
}

