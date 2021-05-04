import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:newui/const.dart';
import 'package:newui/helper/DBHelper.dart';
import 'package:newui/model/task.dart';
import 'package:newui/model/timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodayProvider with ChangeNotifier{
  final String date;

  TodayProvider(this.date);

  List<Task> todayTask=[];

  Timer todayTimer=Timer(date: DateFormat('yyyy/MM/dd').format(DateTime.now()),time: 0);

  bool isBreakTime=false;

  Future<void> checkBreakTime()async{
    try{
      SharedPreferences _prefs=await SharedPreferences.getInstance();
      if(_prefs.containsKey('break')) isBreakTime=true;
      else isBreakTime=false;
      notifyListeners();
    }
    catch(e){
      throw e;
    }
  }
  addNotification()async{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    await _prefs.setString('break', 'true');
    await checkBreakTime();
  }

  double get completedTask{
    if(todayTask.length==0) return 1.0;
    List<Task> completeTask=todayTask.where((element) => element.isDone==1).toList();
    return completeTask.length/todayTask.length;
  }

  getTodayData()async{
    try{
      todayTask.clear();
     final timer= await DBHelper.shared.getDataByQueryTimer(timerTable, date);
     final tasks=await DBHelper.shared.getDataByQueryTask(taskTable, date);

     if(timer.isNotEmpty)
       todayTimer=Timer.fromJson(timer[0]);
     else await DBHelper.shared.insertTimer(timerTable, {"date":"$date","time":0.0});

     if(tasks.isNotEmpty)tasks.forEach((element) {
       todayTask.add(Task.fromJson(element));
     });

     notifyListeners();
    }
    catch(e){
      throw e;
    }
  }

  resetTimer()async{
    try{
     await  DBHelper.shared.updateDataTimer(timerTable, date, {"date":"$date","time":0});
     await getTodayData();
    }catch(e){
      throw e;
    }
  }

  pauseTimer(int time)async{
    try{
      await DBHelper.shared.updateDataTimer(timerTable, date, {"date":"$date","time":time+todayTimer.time});
      await getTodayData();
    }catch(e){
      throw e;
    }
  }

  setCustomTimer(int time)async{
    try{
      await DBHelper.shared.updateDataTimer(timerTable, date, {"date":"$date","time":time});
      await getTodayData();
    }catch(e){
      throw e;
    }
  }

  addTask(String name)async{
    try{
     await DBHelper.shared.insertTodoTask(taskTable, {"id":DateTime.now().toString(),"date":date,"name":name,"isDone":0});
     await getTodayData();
    }catch(e){
      throw e;
    }
  }

  updateTask(String id,int val,String name)async{
    try{
     await DBHelper.shared.updateDataTask(taskTable, id, {"id":id,"date":date,"name":name,"isDone":val==0?1:0});
     await getTodayData();
    }catch(e){
      throw e;
    }
  }
}