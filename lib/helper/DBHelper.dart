import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper{

  static var shared=DBHelper();

   Future<Database> timerdatabase() async{
    final dbPath= await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath,'timer.db'),onCreate: (db,version){
      return db.execute(
'CREATE TABLE timer(date TEXT PRIMARY KEY,time REAL)'
      );
    },version: 1);
  }

   Future<void> insertTimer(String table,Map<String,Object> data) async{
    final db=await timerdatabase();
    db.insert(table, data);
  }

   Future<List<Map<String,Object>>> getDataTimer(String table) async{
    final db=await timerdatabase();
    return db.query(table);
  }

   Future<void> deleteDataTimer(String table,String date)async{
    final db=await timerdatabase();
    db.delete(table,where: 'date=?',whereArgs: [date]);
  }

    Future<void> updateDataTimer(String table,String date,Map<String,Object>data)async{
    final db=await timerdatabase();
    await db.update(table,data,where: 'date=?',whereArgs: [date]);
  }

  Future<List<Map<String,dynamic>>> getDataByQueryTimer(String table,String date)async{
    final db=await timerdatabase();
    return await db.query(table,where: 'date=?',whereArgs: [date]);
  }

    Future<Database> taskdatabase() async{
    final dbPath= await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath,'task.db'),onCreate: (db,version){
      return db.execute(
'CREATE TABLE task(id TEXT PRIMARY KEY,date TEXT,name TEXT,isDone INTEGER)'
      );
    },version: 1);
  }

   Future<void> insertTodoTask(String table,Map<String,Object> data) async{
    final db=await taskdatabase();
    db.insert(table, data);
  }

   Future<List<Map<String,Object>>> getDataTask(String table) async{
    final db=await taskdatabase();
    return db.query(table);
  }

   Future<void> deleteDataTask(String table,String id)async{
    final db=await taskdatabase();
    await db.delete(table,where: 'id=?',whereArgs: [id]);
  }

    Future<void> updateDataTask(String table,String id,Map<String,Object>data)async{
    final db=await taskdatabase();
    await db.update(table,data,where: 'id=?',whereArgs: [id]);
  }

  Future<List<Map<String,dynamic>>> getDataByQueryTask(String table,String date)async{
    final db=await taskdatabase();
    return await db.query(table,where:'date=?',whereArgs:[date]);
  }
}
