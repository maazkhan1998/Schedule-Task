import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:intl/intl.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:newui/screens/Homepage.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;  

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone)); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:  Size(750, 1334),
          builder :() => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: TodayProvider(DateFormat('yyyy/MM/dd').format(DateTime.now())))
            ],
      builder:(context,_)=> MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
          ));
  }
}

