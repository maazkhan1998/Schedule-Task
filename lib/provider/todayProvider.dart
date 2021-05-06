import 'package:flutter/cupertino.dart';
import 'package:newui/const.dart';
import 'package:newui/helper/DBHelper.dart';
import 'package:newui/model/task.dart';
import 'package:newui/model/timer.dart';
import 'package:newui/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class TodayProvider with ChangeNotifier{

  List<Task> todayTask=[];

  Timer todayTimer=Timer(date: formateDate(DateTime.now()),time: 0);


  Future<bool> checkBreakTime()async{
    try{
      SharedPreferences _prefs=await SharedPreferences.getInstance();
      if(!_prefs.containsKey('break')) return true;
     final date= _prefs.getString('break');
     if(DateTime.now().difference(DateTime.parse(date)).inMinutes<10) return false;
     return true;
    }
    catch(e){
      throw e;
    }
  }
  addNotification()async{
    try{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    await _prefs.setString('break', DateTime.now().toIso8601String());
    }
    catch(e){
      throw e;
    }
  }

  double get completedTask{
    if(todayTask.length==0) return 0.0;
    List<Task> completeTask=todayTask.where((element) => element.isDone==1).toList();
    return completeTask.length/todayTask.length;
  }

  getTimer(String date)async{
    try{
      final timer= await DBHelper.shared.getDataByQueryTimer(timerTable, date);
      if(timer.isNotEmpty)
       todayTimer=Timer.fromJson(timer[0]);
     else await DBHelper.shared.insertTimer(timerTable, {"date":"$date","time":0.0});

     notifyListeners();
    }catch(e){
      throw e;
    }
  }

  getTask(String date)async{
    try{
      todayTask.clear();
      final tasks=await DBHelper.shared.getDataByQueryTask(taskTable, date);

     if(tasks.isNotEmpty)tasks.forEach((element) {
       todayTask.add(Task.fromJson(element));
     });

     notifyListeners();
    }catch(e){
      throw e;
    }
  }

  getTodayData(String date)async{
    try{
    await getTimer(date);
    await getTask(date);
    }
    catch(e){
      throw e;
    }
  }

  resetTimer(String date)async{
    try{
     await  DBHelper.shared.updateDataTimer(timerTable, date, {"date":"$date","time":0});
     await getTimer(date);
    }catch(e){
      throw e;
    }
  }

  pauseTimer(int time,String date)async{
    try{
      await DBHelper.shared.updateDataTimer(timerTable, date, {"date":"$date","time":time+todayTimer.time});
      await getTimer(date);
    }catch(e){
      throw e;
    }
  }

  setCustomTimer(int time,String date)async{
    try{
      await DBHelper.shared.updateDataTimer(timerTable, date, {"date":"$date","time":time});
      await getTimer(date);
    }catch(e){
      throw e;
    }
  }

  addTask(String name,String date)async{
    try{
     await DBHelper.shared.insertTodoTask(taskTable, {"id":DateTime.now().toString(),"date":date,"name":name,"isDone":0});
     await getTask(date);
    }catch(e){
      throw e;
    }
  }

  updateTask(String id,int val,String name,String date)async{
    try{
     await DBHelper.shared.updateDataTask(taskTable, id, {"id":id,"date":date,"name":name,"isDone":val==0?1:0});
     await getTask(date);
    }catch(e){
      throw e;
    }
  }

  deleteTask(String id,String date)async{
    try{
      await DBHelper.shared.deleteDataTask(taskTable, id);
      await getTask(date);
    }
    catch(e){
      throw e;
    }
  }

  deleteNotification()async{
    try{
      Utility.shared.showToast('Break Time cancelled');
      await flutterLocalNotificationsPlugin.cancel(0);
      SharedPreferences _prefs=await SharedPreferences.getInstance();
      await _prefs.remove('break');
    }
    catch(e){
      throw e;
    }
  }
}