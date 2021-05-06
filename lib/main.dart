import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:newui/provider/calendarProvider.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:newui/screens/Homepage.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:newui/utility.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    
    String compareDate=formateDate(DateTime.now());


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone)); 
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() { 
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize:  Size(750, 1334),
          builder :() => MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: TodayProvider()),
              ChangeNotifierProvider.value(value: CalendarProvider())
            ],
      builder:(context,_)=> MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
          ));
  }
}

