import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:intl/intl.dart';
import 'package:newui/provider/todayProvider.dart';
import 'package:newui/screens/Homepage.dart';
import 'package:provider/provider.dart';


void main() {
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

