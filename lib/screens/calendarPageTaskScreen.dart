import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newui/dialogs/dialogs.dart';
import 'package:newui/model/task.dart';
import 'package:newui/provider/calendarProvider.dart';
import 'package:newui/screens/calendarscreen.dart';
import 'package:newui/utility.dart';
import 'package:provider/provider.dart';

class CalendarPageTaskScreen extends StatefulWidget {

  final Task task;

  CalendarPageTaskScreen(this.task);
  @override
  _CalendarPageTaskScreenState createState() => _CalendarPageTaskScreenState();
}

class _CalendarPageTaskScreenState extends State<CalendarPageTaskScreen> {

  deleteTask(String id)async{
    if(formateDate(calendarCurrentDate)==formateDate(DateTime.now())) return Utility.shared.showToast('Cannot delete today tasks');
    try{
     await Dialogs.shared.deleteTaskDialog(context, id, ()async{
                    try{
                      await Provider.of<CalendarProvider>(context,listen:false).deleteTask(id);
                      Navigator.of(context,rootNavigator: true).pop();
                    }
                    catch(e){
                      throw e;
                    }
                  });
    }catch(e){
      Utility.shared.showToast(e.toString());
    }
  }

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
              color: widget.task.isDone == 1 ? Color(0xff7654f6) : Colors.white,
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
          Expanded(
                      child: Text(
              widget.task.name,
              maxLines: 1,overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(29)),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: ()=>deleteTask(widget.task.id),
            child: Icon(Icons.delete_outline_rounded,size:30,color:Color(0xff7654f6))),
        ]),
      ),
    );
  }
}