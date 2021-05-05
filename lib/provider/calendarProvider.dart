import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newui/const.dart';
import 'package:newui/helper/DBHelper.dart';
import 'package:newui/model/task.dart';
import 'package:newui/model/timer.dart';

class CalendarProvider with ChangeNotifier{

  List<Task> allTask=[];

  List<Task> selectedDateTask(String date){
    return allTask.where((element) => element.date==date).toList();
  }

  Timer selectedDateTime(String date){
    try{
     return allTimer.firstWhere((element) => element.date==date,orElse: (){
       return Timer(time: 0,date: date);
     });
    }
    catch(e){
      throw e;
    }
  }

  Map<DateTime,List<dynamic>> events(){
    Map<DateTime,List<dynamic>> tempEvents={};
     allTask.forEach((element) {
       tempEvents.addAll({
         DateFormat('yyyy/MM/dd').parse(element.date)
         :allTask.where((e) => e.date==element.date).toList()
       });
     });
     return tempEvents;
  }

  List<Timer> allTimer=[];


  Future<void> getAllData()async{
    try{
     await getAllTask();
     await getAllTimer();
    }
    catch(e){
      throw e;
    }
  }

  Future<void> getAllTask()async{
    try{
      allTask.clear();
      final alltask= await DBHelper.shared.getDataTask(taskTable);
    alltask.forEach((element) { 
      allTask.add(Task.fromJson(element));
    });
    notifyListeners();
    }
    catch(e){
      throw e;
    }
  }

  getAllTimer()async{
    try{
      allTimer.clear();
      final alltimer=await DBHelper.shared.getDataTimer(timerTable);
      alltimer.forEach((element) {
        allTimer.add(Timer.fromJson(element));
      });
      notifyListeners();
    }
    catch(e){
      throw e;
    }
  }

  updateTimer(String date,int time)async{
    try{
      final data =await DBHelper.shared.getDataByQueryTimer(timerTable, date);
      if(data.isEmpty) await DBHelper.shared.insertTimer(timerTable, {"date":"$date","time":0.0});
      await DBHelper.shared.updateDataTimer(timerTable, date, {"date":date,"time":time});
      await getAllTimer();
    }
    catch(e){
      throw e;
    }
  }
}